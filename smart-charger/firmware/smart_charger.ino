// ===========================================================
// SMART CHARGER ESP32 - FIRMWARE COMPLETO E CORRIGIDO
// MQTT COM TLS + HIVEMQ CLOUD + SENSORES REAIS
// ===========================================================

#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "EmonLib.h"
#include <DHT.h>

// ===========================================================
// 🔐 CERTIFICADO CA HIVEMQ CLOUD (ATUALIZADO)
// ===========================================================
const char* hive_ca_cert = \
"-----BEGIN CERTIFICATE-----\n"
"MIIFazCCA1OgAwIBAgISA0Sy57wiVdc+GqORdzdrIW6vMA0GCSqGSIb3DQEBCwUA\n"
"MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MR8wHQYDVQQL\n"
"ExZ3d3cubGV0c2VuY3J5cHQub3JnMB4XDTIyMTAxMzA3MDE1OFoXDTMyMTAxMDA3\n"
"MDE1OFowSjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUxldCdzIEVuY3J5cHQxHzAd\n"
"BgNVBAsTFnd3dy5sZXRzZW5jcnlwdC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC\n"
"DwAwggIKAoICAQC7aVFvBBusZT6FJi1dV0t1Ik5+pUvNbK/CtYQgQki71R+xVQ1q\n"
"LJmLVWv4N3N3xaQa58aeGeq/QAdzTZziEtGlUZEM6I4vGU+mLjxJvLCYOtJk9gDC\n"
"2EePXuE8kdGf1yGvT0RVldPjmPalm6u1MDTIEjkBX/4Jh0GCSqGSIb3DQEBCwUAA4IBAQAFMDTw3\n"
"G+jw/adJzi10BGSAdoo6gWQBaIj++ImQxGc1dQc5sKXc5teLoI0lp4rWuIwoMvV7\n"
"QhqWiKgHdwNwp0UrEGouGZWlznImPi0tLxe3LjVJN8dkUBaRdOyqK8BPVKx/aRXA\n"
"dSd5quN4dStEUAkknvDq1/xJ6mMEG1fVQAyrE3N8ign5pY88MtXgFp0cNTJrC0zP\n"
"QWGWpZJYG1ChcxrFAxo0xO+ogzAm8h1sxGg==\n"
"-----END CERTIFICATE-----\n";


// ===========================================================
// 📶 CONFIG Wi-Fi
// ===========================================================
const char* ssid     = "MCN";
const char* password = "12345678";

// ===========================================================
// ☁️ CONFIG MQTT REAL
// ===========================================================
const char* mqtt_server   = "76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud";
const int   mqtt_port     = 8883;
const char* mqtt_user     = "mateus";
const char* mqtt_password = "Mateus6615";

// Tópicos
const char* topic_data     = "smart-charger/001/data";
const char* topic_alertas  = "smart-charger/001/alertas";
const char* topic_status   = "smart-charger/001/status";
const char* topic_controle = "smart-charger/001/controle";

// ===========================================================
// 🧪 CONFIGURAÇÃO DOS SENSORES REAIS
// ===========================================================
#define PINO_SCT013   35
#define PINO_ZMPT101B 34
#define PINO_DHT22    15

EnergyMonitor emon1;
DHT dht(PINO_DHT22, DHT22);

const float CALIBRACAO_SCT013     = 30.0;
const float CALIBRACAO_ZMPT101B   = 0.00488;
const float OFFSET_TENSAO         = 0.0;

// Limites
const float CORRENTE_MAXIMA     = 15.0;
const float CORRENTE_ALERTA     = 12.0;
const float TEMPERATURA_MAXIMA  = 70.0;
const float TEMPERATURA_ALERTA  = 60.0;
const float TENSAO_MINIMA       = 200.0;
const float TENSAO_MAXIMA       = 250.0;

// ===========================================================
// 🔌 OBJETOS DE REDE
// ===========================================================
WiFiClientSecure espClient;
PubSubClient mqttClient(espClient);

bool sistemaAtivo = true;
bool emergencia = false;

unsigned long ultimoEnvio = 0;
const unsigned long intervaloEnvio = 10000;

// ===========================================================
// 🔧 SETUP
// ===========================================================
void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println("\nSMART CHARGER (FIRMWARE REAL) 🔌");

  espClient.setCACert(hive_ca_cert);

  inicializarSensores();
  conectarWiFi();
  conectarMQTT();
}

// ===========================================================
// 🔄 LOOP
// ===========================================================
void loop() {
  verificarConexoes();
  mqttClient.loop();

  if (sistemaAtivo && millis() - ultimoEnvio > intervaloEnvio) {
    publicarDadosReais();
    ultimoEnvio = millis();
  }
}

// ===========================================================
// 🔧 FUNÇÕES DOS SENSORES
// ===========================================================
float lerCorrenteReal() {
  double i = emon1.calcIrms(1480);
  return i < 0.1 ? 0.0 : i;
}

float lerTemperaturaReal() {
  float t = dht.readTemperature();
  return isnan(t) ? -99.9 : t;
}

float lerTensaoReal() {
  int leitura = analogRead(PINO_ZMPT101B);
  return (leitura * CALIBRACAO_ZMPT101B) + OFFSET_TENSAO;
}

void inicializarSensores() {
  emon1.current(PINO_SCT013, CALIBRACAO_SCT013);
  dht.begin();

  Serial.println("Sensores iniciados!");
}

// ===========================================================
// 📡 CONEXÕES: Wi-Fi & MQTT
// ===========================================================
void conectarWiFi() {
  Serial.print("\nConectando WiFi: ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  int tentativas = 0;
  while (WiFi.status() != WL_CONNECTED && tentativas < 40) {
    delay(500);
    Serial.print(".");
    tentativas++;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nWiFi conectado!");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("\n❌ Falha ao conectar WiFi");
  }
}

void conectarMQTT() {
  Serial.println("\n🔌 Conectando ao HiveMQ...");

  mqttClient.setServer(mqtt_server, mqtt_port);
  mqttClient.setCallback(mqttCallback);

  if (mqttClient.connect("ESP32_SMART", mqtt_user, mqtt_password)) {
    Serial.println("✅ MQTT conectado!");
    mqttClient.subscribe(topic_controle);
  } else {
    Serial.print("❌ Falha MQTT código: ");
    Serial.println(mqttClient.state());
  }
}

void verificarConexoes() {
  if (WiFi.status() != WL_CONNECTED)
    conectarWiFi();

  if (!mqttClient.connected())
    conectarMQTT();
}

// ===========================================================
// 📩 RECEBIMENTO MQTT
// ===========================================================
void mqttCallback(char* topic, byte* payload, unsigned int length) {
  String msg = "";
  for (int i = 0; i < length; i++)
    msg += (char)payload[i];

  Serial.print("\n📨 Comando recebido: ");
  Serial.println(msg);

  if (msg == "reiniciar") {
    sistemaAtivo = true;
    emergencia = false;
    publicarStatus("sistema_reativado");
  }

  if (msg == "parar") {
    sistemaAtivo = false;
    publicarStatus("sistema_pausado");
  }
}

// ===========================================================
// 🚨 SISTEMA DE ALERTAS
// ===========================================================
void publicarAlerta(String tipo, String titulo, String texto) {
  StaticJsonDocument<250> doc;

  doc["tipo"] = tipo;
  doc["titulo"] = titulo;
  doc["mensagem"] = texto;
  doc["timestamp"] = millis();

  String msg;
  serializeJson(doc, msg);

  mqttClient.publish(topic_alertas, msg.c_str());

  Serial.println("\n🚨 ALERTA: " + titulo);
}

// ===========================================================
// 📤 PUBLICAÇÃO DOS DADOS
// ===========================================================
void publicarDadosReais() {
  float tensao = lerTensaoReal();
  float corrente = lerCorrenteReal();
  float temperatura = lerTemperaturaReal();
  float potencia = tensao * corrente;

  // Verifica segurança
  if (corrente > CORRENTE_MAXIMA) {
    sistemaAtivo = false;
    emergencia = true;
    publicarAlerta("emergencia", "Sobrecorrente", String(corrente));
  }

  StaticJsonDocument<300> doc;

  doc["tensao_V"] = tensao;
  doc["corrente_A"] = corrente;
  doc["temperatura_C"] = temperatura;
  doc["potencia_W"] = potencia;
  doc["status"] = sistemaAtivo ? "normal" : "pausado";
  doc["emergencia"] = emergencia;

  String msg;
  serializeJson(doc, msg);

  mqttClient.publish(topic_data, msg.c_str());

  Serial.println("\n📤 DADOS ENVIADOS:");
  Serial.println(msg);
}

// ===========================================================
// 📢 STATUS
// ===========================================================
void publicarStatus(const char* st) {
  StaticJsonDocument<150> doc;
  doc["status"] = st;
  doc["timestamp"] = millis();

  String msg;
  serializeJson(doc, msg);

  mqttClient.publish(topic_status, msg.c_str());
}
