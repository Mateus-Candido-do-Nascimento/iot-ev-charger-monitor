// main.dart - Smart Charger (versão completa com tema, splash e alertas)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

import 'splash_screen.dart';
import 'alerts_page.dart';

// Tema do app
enum AppTheme { light, dark }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartChargerApp());
}

class SmartChargerApp extends StatefulWidget {
  const SmartChargerApp({super.key});

  @override
  State<SmartChargerApp> createState() => _SmartChargerAppState();
}

class _SmartChargerAppState extends State<SmartChargerApp> {
  AppTheme currentTheme = AppTheme.light;

  void toggleTheme() {
    setState(() {
      currentTheme =
          currentTheme == AppTheme.light ? AppTheme.dark : AppTheme.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => DashboardScreen(
              onThemeChange: toggleTheme,
              theme: currentTheme,
            ),
      },
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================
class DashboardScreen extends StatefulWidget {
  final Function onThemeChange;
  final AppTheme theme;

  const DashboardScreen({
    super.key,
    required this.onThemeChange,
    required this.theme,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dados recebidos
  String status = 'Conectando...';
  double voltage = 0.0;
  double current = 0.0;
  double temperature = 0.0;
  double power = 0.0;

  // Histórico de alertas
  List<Map<String, dynamic>> alertList = [];

  // MQTT
  MqttServerClient? client;
  bool isConnected = false;

  final String broker = '76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud';
  final int port = 8883;
  final String username = 'mateus';
  final String password = 'Mateus6615';

  final String topicData = 'smart-charger/001/data';
  final String topicAlerts = 'smart-charger/001/alertas';

  @override
  void initState() {
    super.initState();
    _connectToMqtt();
  }

  @override
  void dispose() {
    try {
      client?.disconnect();
    } catch (_) {}
    super.dispose();
  }

  // ============================================================
  // CONEXÃO MQTT
  // ============================================================
  Future<void> _connectToMqtt() async {
    final clientId =
        'flutter_client_${DateTime.now().millisecondsSinceEpoch % 99999}';

    client = MqttServerClient.withPort(broker, clientId, port);
    client!.logging(on: false);

    // Configura TLS
    client!.secure = true;
    client!.setProtocolV311();
    client!.keepAlivePeriod = 60;

    try {
      SecurityContext ctx = SecurityContext.defaultContext;
      client!.securityContext = ctx;
    } catch (_) {}

    client!.onConnected = _onConnected;
    client!.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client!.connectionMessage = connMessage;

    try {
      final result = await client!.connect(username, password);

      if (result == null ||
          result.state != MqttConnectionState.connected) {
        setState(() {
          isConnected = false;
          status = "Falha MQ: ${result?.state}";
        });
        return;
      }

      setState(() {
        isConnected = true;
        status = "Conectado";
      });

      client!.subscribe(topicData, MqttQos.atMostOnce);
      client!.subscribe(topicAlerts, MqttQos.atMostOnce);

      client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        if (c == null || c.isEmpty) return;
        final recMess = c[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        _processMessage(payload);
      });

    } catch (e) {
      setState(() {
        isConnected = false;
        status = "MQTT erro: $e";
      });
    }
  }

  void _onConnected() {
    setState(() {
      isConnected = true;
      status = "Conectado";
    });
  }

  void _onDisconnected() {
    setState(() {
      isConnected = false;
      status = "Reconectando...";
    });
    Future.delayed(const Duration(seconds: 2), () {
      _connectToMqtt();
    });
  }

  // ============================================================
  // PROCESSAR MENSAGENS
  // ============================================================
  void _processMessage(String message) {
    try {
      final json = jsonDecode(message);

      // ALERTA
      if (json["severidade"] != null) {
        alertList.insert(0, json);
        return;
      }

      // Dados do carregador
      setState(() {
        voltage = (json['tensao_V'] as num?)?.toDouble() ?? voltage;
        current = (json['corrente_A'] as num?)?.toDouble() ?? current;
        temperature = (json['temperatura_C'] as num?)?.toDouble() ?? temperature;
        power = (json['potencia_W'] as num?)?.toDouble() ?? voltage * current;
        status = json['status'] ?? status;
      });
    } catch (e) {
      print("Mensagem inválida: $message");
    }
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🔋 Smart Charger"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(widget.theme == AppTheme.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () => widget.onThemeChange(),
          ),
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AlertsPage(alerts: alertList),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status card
            Card(
              color: isConnected ? Colors.green.shade50 : Colors.orange.shade50,
              child: ListTile(
                leading: Icon(
                  isConnected ? Icons.check_circle : Icons.error,
                  color: isConnected ? Colors.green : Colors.orange,
                  size: 32,
                ),
                title: Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isConnected
                        ? Colors.green.shade900
                        : Colors.orange.shade900,
                  ),
                ),
                trailing: !isConnected
                    ? IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _connectToMqtt,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "📊 Dados em tempo real",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: [
                  DataCard(
                      icon: Icons.bolt,
                      title: "Tensão",
                      value: "${voltage.toStringAsFixed(1)} V",
                      color: Colors.blue),
                  DataCard(
                      icon: Icons.power,
                      title: "Corrente",
                      value: "${current.toStringAsFixed(2)} A",
                      color: Colors.orange),
                  DataCard(
                      icon: Icons.thermostat,
                      title: "Temperatura",
                      value: "${temperature.toStringAsFixed(1)} °C",
                      color: Colors.red),
                  DataCard(
                      icon: Icons.flash_on,
                      title: "Potência",
                      value: "${power.toStringAsFixed(1)} W",
                      color: Colors.purple),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// CARD DE INFORMAÇÕES
class DataCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const DataCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 26,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
