import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

void main() {
  runApp(const SmartChargerApp());
}

class SmartChargerApp extends StatelessWidget {
  const SmartChargerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Charger',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dados que vamos receber do MQTT
  String status = 'Conectando...';
  double voltage = 0.0;
  double current = 0.0;
  double temperature = 0.0;
  double power = 0.0;
  
  // Cliente MQTT
  MqttServerClient? client;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToMqtt();
  }

  @override
  void dispose() {
    client?.disconnect();
    super.dispose();
  }

  // Conectar ao HiveMQ
  void _connectToMqtt() async {
    client = MqttServerClient.withPort(
      '76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      8883,
    );
    
    client!.secure = true;
    client!.port = 8883;
    final context = SecurityContext.defaultContext;
    client!.securityContext = context;
    client!.setProtocolV311();
    client!.keepAlivePeriod = 60;
    client!.onConnected = _onConnected;
    client!.onDisconnected = _onDisconnected;
  
    
    // Credenciais
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(client!.clientIdentifier!)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    
    client!.connectionMessage = connMessage;
    
    final status = await client!.connect('mateus', 'Mateus6615');

    if (status?.state == MqttConnectionState.connected) {
      print('Conectado com sucesso!');
    } else {
      print('Falha na conexão: ${status?.state}');
      client!.disconnect();
      return;
}

      
      // Aguardar um pouco para a conexão estabelecer
      await Future.delayed(const Duration(seconds: 2);
      
      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        print('✅ Conectado ao MQTT!');
        setState(() {
          isConnected = true;
          status = 'Conectado';
        });
        
        // Se inscrever no tópico
        client!.subscribe('smart-charger/001/data', MqttQos.atMostOnce);
        client!.subscribe('smart-charger/001/alertas', MqttQos.atMostOnce);
        
        // Ouvir mensagens
        client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          if (c != null) {
            final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
            final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
            _processMessage(message);
          }
        });
      }
    } catch (e) {
      print('❌ Erro MQTT: $e');
      setState(() {
        status = 'Erro na conexão: $e';
        isConnected = false;
      });
    }
  }

  void _onConnected() {
    print('✅ MQTT Conectado!');
  }

  void _onDisconnected() {
    print('❌ MQTT Desconectado!');
    setState(() {
      isConnected = false;
      status = 'Desconectado';
    });
  }

  // Processar mensagens recebidas
  void _processMessage(String message) {
    print('📨 Mensagem recebida: $message');
    
    try {
      final json = jsonDecode(message);
      
      setState(() {
        voltage = (json['tensao_V'] as num?)?.toDouble() ?? 0.0;
        current = (json['corrente_A'] as num?)?.toDouble() ?? 0.0;
        temperature = (json['temperatura_C'] as num?)?.toDouble() ?? 0.0;
        power = (json['potencia_W'] as num?)?.toDouble() ?? (voltage * current);
        status = json['status'] ?? 'Recebendo dados';
      });
    } catch (e) {
      print('❌ Erro ao processar JSON: $e');
      // Se não for JSON válido, mantém os dados anteriores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔋 Smart Charger'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Card(
              color: isConnected ? Colors.green.shade50 : Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      isConnected ? Icons.check_circle : Icons.error,
                      color: isConnected ? Colors.green : Colors.orange,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        status,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isConnected ? Colors.green.shade900 : Colors.orange.shade900,
                        ),
                      ),
                    ),
                    if (!isConnected)
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _connectToMqtt,
                        tooltip: 'Reconectar',
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Dados
            const Text(
              '📊 Dados em Tempo Real',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 10),
            
            Expanded(
              child: ListView(
                children: [
                  DataCard(
                    icon: Icons.bolt,
                    title: 'Tensão',
                    value: '${voltage.toStringAsFixed(1)} V',
                    color: Colors.blue,
                  ),
                  
                  DataCard(
                    icon: Icons.power,
                    title: 'Corrente', 
                    value: '${current.toStringAsFixed(2)} A',
                    color: Colors.orange,
                  ),
                  
                  DataCard(
                    icon: Icons.thermostat,
                    title: 'Temperatura',
                    value: '${temperature.toStringAsFixed(1)} °C',
                    color: Colors.red,
                  ),
                  
                  DataCard(
                    icon: Icons.flash_on,
                    title: 'Potência',
                    value: '${power.toStringAsFixed(1)} W',
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para mostrar cada dado
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
