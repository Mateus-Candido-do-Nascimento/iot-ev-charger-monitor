import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

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
        primarySwatch: Colors.blue,
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
  
  // Cliente MQTT
  late MqttServerClient client;

  @override
  void initState() {
    super.initState();
    _connectToMqtt();
  }

  // Conectar ao HiveMQ
  void _connectToMqtt() async {
    client = MqttServerClient('76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud', '');
    client.port = 8883;
    client.secure = true;
    client.logging(on: false);
    
    // Credenciais (use suas credenciais reais)
    client.keepAlivePeriod = 60;
    
    try {
      await client.connect('mateus', 'Mateus6615');
      print('✅ Conectado ao MQTT!');
      
      // Se inscrever no tópico
      client.subscribe('smart-charger/001/data', MqttQos.atMostOnce);
      
      // Ouvir mensagens
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        if (c != null) {
          final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
          final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          _processMessage(message);
        }
      });
      
    } catch (e) {
      print('❌ Erro MQTT: $e');
      setState(() {
        status = 'Erro na conexão';
      });
    }
  }

  // Processar mensagens recebidas
  void _processMessage(String message) {
    print('📨 Mensagem recebida: $message');
    
    // Simular dados (depois vamos parsear JSON real)
    setState(() {
      voltage = 218.5;
      current = 8.2;
      temperature = 32.5;
      status = 'Conectado - Recebendo dados';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔋 Smart Charger'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      status.contains('Conectado') ? Icons.check_circle : Icons.error,
                      color: status.contains('Conectado') ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: status.contains('Conectado') ? Colors.green : Colors.orange,
                      ),
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
            
            DataCard(
              icon: Icons.bolt,
              title: 'Tensão',
              value: '$voltage V',
              color: Colors.blue,
            ),
            
            DataCard(
              icon: Icons.power,
              title: 'Corrente', 
              value: '$current A',
              color: Colors.orange,
            ),
            
            DataCard(
              icon: Icons.thermostat,
              title: 'Temperatura',
              value: '$temperature °C',
              color: Colors.red,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}