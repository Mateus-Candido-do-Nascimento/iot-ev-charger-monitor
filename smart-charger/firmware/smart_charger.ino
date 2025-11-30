// ===========================================================
// SMART CHARGER ESP32 - FIRMWARE (SEM TRAVAS AUTOMÁTICAS)
// ===========================================================

#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "EmonLib.h"
#include <DHT.h>

// ===========================================================
// CONFIG: desativa travas automáticas se true (modo teste)
// ===========================================================
#define DISABLE_SAFETY true   // coloque false para reativar proteções automáticas

// ===========================================================
// 🔐 CERTIFICADO CA HIVEMQ CLOUD (ATUALIZADO) - mantido
// ===========================================================
const char* hive_ca_cert = R"EOF(
-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----
)EOF";

// ===========================================================
// 📶 CONFIG Wi-Fi
// ===========================================================
const char* ssid     = "Brasilino2G";
const char* password = "42081467";

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

// Limites (mantidos, mas não acionarão travas quando DISABLE_SAFETY true)
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

  Serial.println("\nSMART CHARGER (FIRMWARE) - TRAVAS DESATIVADAS (SE APLICÁVEL) 🔌");

  // configura CA para TLS
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
// 🚨 SISTEMA DE ALERTAS (mantido, mas você pode optar por não enviar)
// ===========================================================
void publicarAlerta(String tipo, String titulo, String texto) {
  // mesmo com alertas habilitados, não iremos travar o sistema quando DISABLE_SAFETY == true
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
// 📤 PUBLICAÇÃO DOS DADOS (SEM TRAVAS AUTOMÁTICAS)
// ===========================================================
void publicarDadosReais() {
  float tensao = lerTensaoReal();
  float corrente = lerCorrenteReal();
  float temperatura = lerTemperaturaReal();
  float potencia = tensao * corrente;

  // SE safety desativada, NÃO execute travas; apenas publique alerta informativo se quiser
  if (!DISABLE_SAFETY) {
    // comportamento original: colocar emergência e pausar se corrente exceder
    if (corrente > CORRENTE_MAXIMA) {
      if (!emergencia) {
        publicarAlerta("emergencia", "Sobrecorrente", String(corrente));
      }
      emergencia = true;
      sistemaAtivo = false;
      publicarStatus("pausado_emergencia");
    }
  } else {
    // modo sem travas: se corrente muito alta, apenas registre alerta (não bloqueia)
    if (corrente > CORRENTE_MAXIMA) {
      // opcional: publicar alerta informativo (não trava)
      publicarAlerta("info", "Corrente alta (modo sem trava)", String(corrente));
      // não altera emergencia nem sistemaAtivo
    }
  }

  StaticJsonDocument<300> doc;

  doc["tensao_V"] = tensao;
  doc["corrente_A"] = corrente;
  doc["temperatura_C"] = temperatura;
  doc["potencia_W"] = potencia;
  // status reflete apenas a variável sistemaAtivo, que agora NÃO é alterada automaticamente no modo sem trava
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
