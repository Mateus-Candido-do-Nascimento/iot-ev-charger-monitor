import 'dart:async';
import 'package:flutter/material.dart';
import '../services/mqtt_service.dart';
import '../models/charger_data.dart';
import '../alerts_page.dart';

class DashboardPage extends StatefulWidget {
  final MqttService mqttService;

  const DashboardPage({super.key, required this.mqttService});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ChargerData? _currentData;
  bool _isConnected = false;
  List<Map<String, dynamic>> _alerts = [];
  StreamSubscription? _dataSubscription;
  StreamSubscription? _alertsSubscription;
  StreamSubscription? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _connectAndListen();
  }

  Future<void> _connectAndListen() async {
    // Escuta mudanças de conexão
    _connectionSubscription = widget.mqttService.connectionStream.listen((connected) {
      if (mounted) {
        setState(() {
          _isConnected = connected;
        });
      }
      
      if (connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Conectado ao broker MQTT!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Desconectado do broker. Tentando reconectar...'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });

    // Escuta dados dos sensores
    _dataSubscription = widget.mqttService.dataStream.listen((jsonData) {
      if (mounted) {
        setState(() {
          _currentData = ChargerData.fromJson(jsonData);
        });
      }
    });

    // Escuta alertas
    _alertsSubscription = widget.mqttService.alertsStream.listen((jsonData) {
      if (mounted) {
        setState(() {
          _alerts.insert(0, {
            'severidade': jsonData['tipo'] ?? 'info',
            'titulo': jsonData['titulo'] ?? 'Alerta',
            'mensagem': jsonData['mensagem'] ?? '',
          });
          
          // Mantém apenas os últimos 50 alertas
          if (_alerts.length > 50) {
            _alerts = _alerts.take(50).toList();
          }
        });

        // Mostra notificação para alertas importantes
        if (jsonData['tipo'] == 'emergencia') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🚨 ${jsonData['titulo'] ?? 'Emergência'}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    });

    // Conecta ao broker
    await widget.mqttService.connect();
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _alertsSubscription?.cancel();
    _connectionSubscription?.cancel();
    widget.mqttService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔋 Smart Charger Monitor'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          // Indicador de conexão
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Icon(
                _isConnected ? Icons.wifi : Icons.wifi_off,
                color: _isConnected ? Colors.greenAccent : Colors.red,
              ),
            ),
          ),
          // Botão de alertas
          if (_alerts.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlertsPage(alerts: _alerts),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_alerts.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildControlButtons(),
    );
  }

  Widget _buildBody() {
    if (!_isConnected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Conectando ao broker MQTT...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => widget.mqttService.connect(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_currentData == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Aguardando dados do carregador...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildDataGrid(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final data = _currentData!;
    final statusColor = data.isEmergency
        ? Colors.red
        : data.isPaused
            ? Colors.orange
            : Colors.green;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status do Sistema',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (data.emergencia) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '⚠️ Sistema em estado de emergência!',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataGrid() {
    final data = _currentData!;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildDataCard(
          '⚡ Tensão',
          '${data.tensaoV.toStringAsFixed(1)} V',
          Icons.flash_on,
          Colors.blue,
        ),
        _buildDataCard(
          '🔌 Corrente',
          '${data.correnteA.toStringAsFixed(2)} A',
          Icons.power,
          Colors.orange,
        ),
        _buildDataCard(
          '🌡️ Temperatura',
          '${data.temperaturaC.toStringAsFixed(1)} °C',
          Icons.thermostat,
          Colors.red,
        ),
        _buildDataCard(
          '💡 Potência',
          '${data.potenciaW.toStringAsFixed(0)} W',
          Icons.bolt,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildDataCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildControlButtons() {
    if (!_isConnected || _currentData == null) return null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'reiniciar',
          onPressed: () {
            widget.mqttService.reiniciarSistema();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('📤 Comando de reiniciar enviado!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: 'parar',
          onPressed: () {
            widget.mqttService.pararSistema();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('📤 Comando de parar enviado!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.stop, color: Colors.white),
        ),
      ],
    );
  }
}

