// firmware/smart_charger.ino - CONEXÕES REAIS
#include <WiFi.h>
#include <PubSubClient.h>

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

// Tópico
const char* topic_data = "smart-charger/001/data";

// ==================== SETUP PRINCIPAL ====================
void setup() {
  Serial.begin(115200);
  delay(1000); // Dar tempo para Serial estabilizar
  
  Serial.println();
  Serial.println("🔋 SMART CHARGER - INICIANDO");
  Serial.println("==============================");
  
  conectarWiFi();      // ← Foco 1: Só WiFi
  conectarMQTT();      // ← Foco 2: Só MQTT
}

// ==================== LOOP PRINCIPAL ====================
void loop() {
  // Foco: Manter conexões estáveis
  verificarConexoes();
  delay(5000);
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
    
    // Timeout de 20 segundos
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
  Serial.print("📶 RSSI: ");
  Serial.print(WiFi.RSSI());
  Serial.println(" dBm");
}

// ==================== MQTT - CONEXÃO REAL ====================
void conectarMQTT() {
  Serial.println();
  Serial.println("🔌 CONECTANDO MQTT...");
  Serial.print("Broker: ");
  Serial.println(mqtt_server);
  Serial.print("Porta: ");
  Serial.println(mqtt_port);
  
  mqttClient.setServer(mqtt_server, mqtt_port);
  
  Serial.print("Autenticando...");
  
  if (mqttClient.connect("ESP32_SmartCharger_001", mqtt_user, mqtt_password)) {
    Serial.println("✅ MQTT CONECTADO!");
    Serial.println("📩 Pronto para publicar dados");
  } else {
    Serial.println("❌ FALHA MQTT");
    Serial.print("Código erro: ");
    Serial.println(mqttClient.state());
  }
}

// ==================== VERIFICAR CONEXÕES ====================
void verificarConexoes() {
  bool wifiOk = (WiFi.status() == WL_CONNECTED);
  bool mqttOk = mqttClient.connected();
  
  Serial.println();
  Serial.println("🔍 STATUS DAS CONEXÕES:");
  Serial.print("📡 WiFi: ");
  Serial.println(wifiOk ? "✅ CONECTADO" : "❌ DESCONECTADO");
  
  Serial.print("🔌 MQTT: ");
  Serial.println(mqttOk ? "✅ CONECTADO" : "❌ DESCONECTADO");
  
  // Reconectar se necessário
  if (!wifiOk) {
    Serial.println("🔄 Reconectando WiFi...");
    conectarWiFi();
  }
  
  if (wifiOk && !mqttOk) {
    Serial.println("🔄 Reconectando MQTT...");
    conectarMQTT();
  }
  
  // Se tudo ok, mostrar info
  if (wifiOk && mqttOk) {
    Serial.print("📶 Força sinal: ");
    Serial.print(WiFi.RSSI());
    Serial.println(" dBm");
  }
}