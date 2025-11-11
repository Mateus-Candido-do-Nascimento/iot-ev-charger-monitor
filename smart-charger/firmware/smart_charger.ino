// firmware/smart_charger.ino - PASSO 2: UNIDADES CORRETAS
#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>

// ==================== CONFIGURAÇÕES REAIS ====================
const char* ssid = "BRASILINO5G";
const char* password = "42081467";

// HiveMQ Cloud - CONFIGURAÇÕES REAIS
const char* mqtt_server = "76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_user = "mateus";
const char* mqtt_password = "Mateus6615";

// Variáveis
WiFiClient espClient;
PubSubClient mqttClient(espClient);

// Tópicos
const char* topic_data = "smart-charger/001/data";
const char* topic_status = "smart-charger/001/status";

// Controle de tempo
unsigned long ultimoEnvio = 0;
const unsigned long intervaloEnvio = 10000; // 10 segundos

// ==================== SETUP PRINCIPAL ====================
void setup() {
  Serial.begin(115200);
  delay(1000);
  
  Serial.println();
  Serial.println("🔋 SMART CHARGER - INICIANDO");
  Serial.println("==============================");
  
  conectarWiFi();
  conectarMQTT();
  
  // Publicar status inicial
  publicarStatus("sistema_iniciado");
}

// ==================== LOOP PRINCIPAL ====================
void loop() {
  verificarConexoes();
  
  // Publicar dados a cada 10 segundos
  if (millis() - ultimoEnvio >= intervaloEnvio) {
    publicarDadosTeste();
    ultimoEnvio = millis();
  }
  
  delay(1000);
}

// ==================== WiFi - CONEXÃO REAL ====================
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

// ==================== MQTT - CONEXÃO REAL ====================
void conectarMQTT() {
  Serial.println();
  Serial.println("🔌 CONECTANDO MQTT...");
  
  mqttClient.setServer(mqtt_server, mqtt_port);
  
  if (mqttClient.connect("ESP32_SmartCharger_001", mqtt_user, mqtt_password)) {
    Serial.println("✅ MQTT CONECTADO!");
  } else {
    Serial.print("❌ FALHA MQTT - Código: ");
    Serial.println(mqttClient.state());
  }
}

// ==================== VERIFICAR CONEXÕES ====================
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

// ==================== PUBLICAR DADOS DE TESTE ====================
void publicarDadosTeste() {
  // Simular dados de sensores (valores realistas)
  float tensao_V = 218.5 + (random(0, 20) - 10) / 10.0;  // 216-221V
  float corrente_A = 7.8 + (random(0, 40) - 20) / 10.0;  // 6-10A
  float temperatura_C = 28.5 + (random(0, 30) - 15) / 10.0; // 25-32°C
  float potencia_W = tensao_V * corrente_A;
  
  // Criar JSON com ArduinoJson - UNIDADES EXPLÍCITAS
  StaticJsonDocument<300> doc;
  doc["dispositivo"] = "smart-charger-001";
  
  // DADOS ELÉTRICOS COM UNIDADES
  doc["tensao_V"] = round(tensao_V * 10) / 10.0;
  doc["corrente_A"] = round(corrente_A * 10) / 10.0;
  doc["potencia_W"] = round(potencia_W * 10) / 10.0;
  
  // DADOS TÉRMICOS COM UNIDADES
  doc["temperatura_C"] = round(temperatura_C * 10) / 10.0;
  
  // METADADOS
  doc["timestamp_ms"] = millis();
  doc["status"] = "carregando";
  
  String payload;
  serializeJson(doc, payload);
  
  // Publicar no MQTT
  if (mqttClient.connected()) {
    if (mqttClient.publish(topic_data, payload.c_str())) {
      Serial.println("📤 DADOS PUBLICADOS:");
      Serial.println(payload);
      
      // Mostrar valores formatados no Serial
      Serial.println("📊 VALORES:");
      Serial.print("  ⚡ Tensão: "); Serial.print(tensao_V, 1); Serial.println(" V");
      Serial.print("  🔌 Corrente: "); Serial.print(corrente_A, 1); Serial.println(" A");
      Serial.print("  💡 Potência: "); Serial.print(potencia_W, 1); Serial.println(" W");
      Serial.print("  🌡️ Temperatura: "); Serial.print(temperatura_C, 1); Serial.println(" °C");
      Serial.println("────────────────────────");
    } else {
      Serial.println("❌ ERRO: Falha ao publicar dados");
    }
  }
}

// ==================== PUBLICAR STATUS DO SISTEMA ====================
void publicarStatus(const char* status) {
  StaticJsonDocument<150> doc;
  doc["dispositivo"] = "smart-charger-001";
  doc["status"] = status;
  doc["timestamp_ms"] = millis();
  doc["versao_firmware"] = "1.0.0";
  doc["unidades"] = "V_A_W_C";
  
  String payload;
  serializeJson(doc, payload);
  
  if (mqttClient.connected()) {
    mqttClient.publish(topic_status, payload.c_str());
    Serial.print("📢 STATUS: ");
    Serial.println(status);
  }
}