// firmware/smart_charger.ino - CÓDIGO PRONTO PARA SENSORES REAIS
#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "EmonLib.h"  // Para sensor de corrente
#include <DHT.h>      // Para sensor de temperatura

// ==================== CONFIGURAÇÕES REAIS ====================
const char* ssid = "BRASILINO5G";
const char* password = "42081467";

// HiveMQ Cloud - CONFIGURAÇÕES REAIS
const char* mqtt_server = "76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_user = "mateus";
const char* mqtt_password = "Mateus6615";

// ==================== CONFIGURAÇÃO DOS SENSORES REAIS ====================
// Pinos dos sensores (conectar fisicamente)
#define PINO_SCT013   35    // Sensor de corrente SCT-013 no GPIO35
#define PINO_ZMPT101B 34    // Sensor de tensão ZMPT101B no GPIO34  
#define PINO_DHT22    15    // Sensor temperatura DHT22 no GPIO15

// Objetos dos sensores
EnergyMonitor emon1;        // Sensor de corrente
DHT dht(PINO_DHT22, DHT22); // Sensor de temperatura

// Calibração dos sensores (ajustar com multímetro)
const float CALIBRACAO_SCT013 = 30.0;    // 30A para SCT-013
const float CALIBRACAO_ZMPT101B = 0.00488; // Ajustar conforme teste
const float OFFSET_TENSAO = 0.0;         // Ajustar offset se necessário

// ==================== LIMITES DE SEGURANÇA ====================
const float CORRENTE_MAXIMA = 15.0;      // 15A - limite máximo seguro
const float CORRENTE_ALERTA = 12.0;      // 12A - alerta amarelo
const float TEMPERATURA_MAXIMA = 70.0;   // 70°C - desligamento emergencial
const float TEMPERATURA_ALERTA = 60.0;   // 60°C - alerta laranja
const float TENSAO_MINIMA = 200.0;       // 200V - tensão muito baixa
const float TENSAO_MAXIMA = 250.0;       // 250V - tensão muito alta

// ==================== VARIÁVEIS GLOBAIS ====================
WiFiClient espClient;
PubSubClient mqttClient(espClient);

// Tópicos MQTT
const char* topic_data = "smart-charger/001/data";
const char* topic_status = "smart-charger/001/status";
const char* topic_alertas = "smart-charger/001/alertas";
const char* topic_controle = "smart-charger/001/controle";

// Controle de tempo
unsigned long ultimoEnvio = 0;
const unsigned long intervaloEnvio = 10000; // 10 segundos

// Estado do sistema
bool sistemaAtivo = true;
bool emergencia = false;

// ==================== SETUP PRINCIPAL ====================
void setup() {
  Serial.begin(115200);
  delay(1000);
  
  Serial.println();
  Serial.println("🔋 SMART CHARGER - PRONTO PARA SENSORES REAIS");
  Serial.println("==============================================");
  
  inicializarSensores();  // Inicializa todos os sensores
  conectarWiFi();
  conectarMQTT();
  
  publicarStatus("sistema_iniciado");
  publicarAlerta("info", "Sistema pronto para sensores reais", "Conecte os sensores e alimente o circuito");
}

// ==================== LOOP PRINCIPAL ====================
void loop() {
  verificarConexoes();
  mqttClient.loop();
  
  // Publicar dados a cada 10 segundos (se sistema ativo)
  if (sistemaAtivo && millis() - ultimoEnvio >= intervaloEnvio) {
    publicarDadosReais();  // Agora com leituras REAIS
    ultimoEnvio = millis();
  }
  
  delay(1000);
}

// ==================== INICIALIZAÇÃO DOS SENSORES REAIS ====================
void inicializarSensores() {
  Serial.println();
  Serial.println("🔧 INICIALIZANDO SENSORES REAIS...");
  
  // Sensor de Corrente SCT-013
  emon1.current(PINO_SCT013, CALIBRACAO_SCT013);
  Serial.println("✅ SCT-013 - Sensor de corrente configurado");
  
  // Sensor de Temperatura DHT22
  dht.begin();
  Serial.println("✅ DHT22 - Sensor de temperatura configurado");
  
  // Sensor de Tensão ZMPT101B (pino analógico já configurado)
  Serial.println("✅ ZMPT101B - Sensor de tensão configurado");
  
  Serial.println("🎯 PRONTO: Conecte os sensores nos pinos:");
  Serial.println("   Corrente (SCT-013) → GPIO35");
  Serial.println("   Tensão (ZMPT101B)  → GPIO34");
  Serial.println("   Temperatura (DHT22)→ GPIO15");
  Serial.println();
}

// ==================== LEITURAS REAIS DOS SENSORES ====================
float lerCorrenteReal() {
  // Leitura REAL do SCT-013
  double corrente = emon1.calcIrms(1480); // 1480 amostras para precisão
  
  // Filtrar ruído (valores muito baixos são ruído)
  if (corrente < 0.1) {
    corrente = 0.0;
  }
  
  return corrente;
}

float lerTensaoReal() {
  // Leitura REAL do ZMPT101B
  int leituraAnalogica = analogRead(PINO_ZMPT101B);
  
  // Converter para tensão (ajustar CALIBRACAO_ZMPT101B com multímetro)
  float tensao = (leituraAnalogica * CALIBRACAO_ZMPT101B) + OFFSET_TENSAO;
  
  return tensao;
}

float lerTemperaturaReal() {
  // Leitura REAL do DHT22
  float temperatura = dht.readTemperature();
  
  // Verificar se a leitura é válida
  if (isnan(temperatura)) {
    Serial.println("❌ ERRO: Leitura do DHT22 falhou");
    return -99.9; // Valor de erro
  }
  
  return temperatura;
}

// ==================== CONEXÕES ====================
void conectarWiFi() {
  Serial.println();
  Serial.println("📡 CONECTANDO WiFi...");
  Serial.print("Rede: ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  Serial.print("Aguardando conexão");
  unsigned long startTime = millis();
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    
    if (millis() - startTime > 20000) {
      Serial.println();
      Serial.println("❌ TIMEOUT: WiFi não conectado");
      return;
    }
  }
  
  Serial.println();
  Serial.println("✅ WIFI CONECTADO!");
  Serial.print("📡 IP: ");
  Serial.println(WiFi.localIP());
}

void conectarMQTT() {
  Serial.println();
  Serial.println("🔌 CONECTANDO MQTT...");
  
  mqttClient.setServer(mqtt_server, mqtt_port);
  mqttClient.setCallback(mqttCallback);
  
  if (mqttClient.connect("ESP32_SmartCharger_001", mqtt_user, mqtt_password)) {
    Serial.println("✅ MQTT CONECTADO!");
    mqttClient.subscribe(topic_controle);
    Serial.println("📩 Inscrito no tópico de controle");
  } else {
    Serial.print("❌ FALHA MQTT - Código: ");
    Serial.println(mqttClient.state());
  }
}

void mqttCallback(char* topic, byte* payload, unsigned int length) {
  String mensagem;
  for (int i = 0; i < length; i++) {
    mensagem += (char)payload[i];
  }
  
  Serial.print("📨 COMANDO RECEBIDO: ");
  Serial.println(mensagem);
  
  if (mensagem == "reiniciar") {
    sistemaAtivo = true;
    emergencia = false;
    publicarStatus("sistema_reativado");
    publicarAlerta("info", "Sistema reativado", "Comando de reinício recebido");
  } else if (mensagem == "parar") {
    sistemaAtivo = false;
    publicarStatus("sistema_pausado");
    publicarAlerta("aviso", "Sistema pausado", "Comando de parada recebido");
  }
}

void verificarConexoes() {
  bool wifiOk = (WiFi.status() == WL_CONNECTED);
  bool mqttOk = mqttClient.connected();
  
  if (!wifiOk) {
    Serial.println("🔄 Reconectando WiFi...");
    conectarWiFi();
  }
  
  if (wifiOk && !mqttOk) {
    Serial.println("🔄 Reconectando MQTT...");
    conectarMQTT();
  }
}

// ==================== SISTEMA DE ALERTAS ====================
void verificarSeguranca(float tensao_V, float corrente_A, float temperatura_C) {
  // Verificar condições críticas (EMERGÊNCIA)
  if (corrente_A > CORRENTE_MAXIMA && !emergencia) {
    emergencia = true;
    sistemaAtivo = false;
    publicarAlerta("emergencia", "SOBRECORRENTE CRÍTICA", 
                   String("Corrente: ") + corrente_A + "A > " + CORRENTE_MAXIMA + "A - SISTEMA DESLIGADO");
    return;
  }
  
  if (temperatura_C > TEMPERATURA_MAXIMA && !emergencia) {
    emergencia = true;
    sistemaAtivo = false;
    publicarAlerta("emergencia", "SUPERAQUECIMENTO CRÍTICO", 
                   String("Temperatura: ") + temperatura_C + "°C > " + TEMPERATURA_MAXIMA + "°C - SISTEMA DESLIGADO");
    return;
  }
  
  if (tensao_V < TENSAO_MINIMA && sistemaAtivo) {
    publicarAlerta("perigo", "TENSÃO BAIXA", 
                   String("Tensão: ") + tensao_V + "V < " + TENSAO_MINIMA + "V - RISCO DE DANOS");
  }
  
  if (tensao_V > TENSAO_MAXIMA && sistemaAtivo) {
    publicarAlerta("perigo", "TENSÃO ALTA", 
                   String("Tensão: ") + tensao_V + "V > " + TENSAO_MAXIMA + "V - RISCO DE DANOS");
  }
  
  // Verificar alertas de atenção (AVISOS)
  if (corrente_A > CORRENTE_ALERTA && sistemaAtivo && !emergencia) {
    publicarAlerta("aviso", "CORRENTE ELEVADA", 
                   String("Corrente: ") + corrente_A + "A > " + CORRENTE_ALERTA + "A - MONITORAR");
  }
  
  if (temperatura_C > TEMPERATURA_ALERTA && sistemaAtivo && !emergencia) {
    publicarAlerta("aviso", "TEMPERATURA ELEVADA", 
                   String("Temperatura: ") + temperatura_C + "°C > " + TEMPERATURA_ALERTA + "°C - MONITORAR");
  }
}

void publicarAlerta(String severidade, String titulo, String mensagem) {
  StaticJsonDocument<300> doc;
  doc["dispositivo"] = "smart-charger-001";
  doc["severidade"] = severidade;
  doc["titulo"] = titulo;
  doc["mensagem"] = mensagem;
  doc["timestamp_ms"] = millis();
  
  String payload;
  serializeJson(doc, payload);
  
  if (mqttClient.connected()) {
    mqttClient.publish(topic_alertas, payload.c_str());
    Serial.println("🚨 ALERTA: " + titulo + " - " + mensagem);
  }
}

// ==================== PUBLICAÇÃO DE DADOS REAIS ====================
void publicarDadosReais() {
  // LEITURAS REAIS DOS SENSORES
  float tensao_V = lerTensaoReal();
  float corrente_A = lerCorrenteReal();
  float temperatura_C = lerTemperaturaReal();
  float potencia_W = tensao_V * corrente_A;
  
  // Verificar segurança ANTES de publicar
  verificarSeguranca(tensao_V, corrente_A, temperatura_C);
  
  // Criar JSON com dados REAIS
  StaticJsonDocument<300> doc;
  doc["dispositivo"] = "smart-charger-001";
  doc["tensao_V"] = round(tensao_V * 10) / 10.0;
  doc["corrente_A"] = round(corrente_A * 10) / 10.0;
  doc["potencia_W"] = round(potencia_W * 10) / 10.0;
  doc["temperatura_C"] = round(temperatura_C * 10) / 10.0;
  doc["timestamp_ms"] = millis();
  doc["status"] = sistemaAtivo ? (emergencia ? "emergencia" : "carregando") : "pausado";
  doc["emergencia"] = emergencia;
  
  String payload;
  serializeJson(doc, payload);
  
  // Publicar no MQTT
  if (mqttClient.connected() && sistemaAtivo) {
    if (mqttClient.publish(topic_data, payload.c_str())) {
      Serial.println("📤 DADOS REAIS PUBLICADOS:");
      Serial.println(payload);
      
      // Mostrar valores formatados
      Serial.println("📊 LEITURAS REAIS:");
      Serial.print("  ⚡ Tensão: "); Serial.print(tensao_V, 1); Serial.println(" V");
      Serial.print("  🔌 Corrente: "); Serial.print(corrente_A, 2); Serial.println(" A");
      Serial.print("  💡 Potência: "); Serial.print(potencia_W, 1); Serial.println(" W");
      Serial.print("  🌡️ Temperatura: "); Serial.print(temperatura_C, 1); Serial.println(" °C");
      Serial.print("  🚦 Status: "); Serial.println(sistemaAtivo ? (emergencia ? "EMERGÊNCIA" : "NORMAL") : "PAUSADO");
      Serial.println("────────────────────────");
    }
  }
}

void publicarStatus(const char* status) {
  StaticJsonDocument<150> doc;
  doc["dispositivo"] = "smart-charger-001";
  doc["status"] = status;
  doc["timestamp_ms"] = millis();
  doc["versao_firmware"] = "2.0.0"; // Versão com sensores reais
  
  String payload;
  serializeJson(doc, payload);
  
  if (mqttClient.connected()) {
    mqttClient.publish(topic_status, payload.c_str());
    Serial.print("📢 STATUS: ");
    Serial.println(status);
  }
}