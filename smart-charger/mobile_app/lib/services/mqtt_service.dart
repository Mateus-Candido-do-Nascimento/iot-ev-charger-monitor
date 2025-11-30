import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// Serviço MQTT para conexão com HiveMQ Cloud
/// Gerencia conexão, subscrições e publicação de mensagens
class MqttService {
  late MqttServerClient client;
  
  // Callbacks para notificar a UI sobre novos dados
  final StreamController<Map<String, dynamic>> _dataController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _alertsController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _statusController = StreamController.broadcast();
  final StreamController<bool> _connectionController = StreamController.broadcast();
  
  // Streams públicos para a UI escutar
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;
  Stream<Map<String, dynamic>> get alertsStream => _alertsController.stream;
  Stream<Map<String, dynamic>> get statusStream => _statusController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  
  // ===========================================================
  // 📡 CONFIGURAÇÃO MQTT - Mesmas credenciais do ESP32
  // ===========================================================
  static const String mqttServer = '76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud';
  static const int mqttPort = 8883;
  static const String mqttUser = 'mateus';
  static const String mqttPassword = 'Mateus6615';
  
  // Tópicos MQTT
  static const String topicData = 'smart-charger/001/data';
  static const String topicAlertas = 'smart-charger/001/alertas';
  static const String topicStatus = 'smart-charger/001/status';
  static const String topicControle = 'smart-charger/001/controle';
  
  /// Conecta ao broker MQTT
  Future<bool> connect() async {
    try {
      // Cria cliente MQTT com TLS
      client = MqttServerClient.withPort(mqttServer, '', mqttPort);
      client.secure = true;
      client.logging(on: false);
      
      // Configura credenciais
      client.keepAlivePeriod = 20;
      client.onConnected = _onConnected;
      client.onDisconnected = _onDisconnected;
      client.onAutoReconnect = _onAutoReconnect;
      
      // Configura autenticação
      final connMessage = MqttConnectMessage()
          .withClientIdentifier('flutter_app_${DateTime.now().millisecondsSinceEpoch}')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce)
          .authenticateAs(mqttUser, mqttPassword);
      
      client.connectionMessage = connMessage;
      
      print('🔌 Conectando ao HiveMQ Cloud...');
      
      // Tenta conectar
      await client.connect();
      
      // Se chegou aqui, está conectado
      _isConnected = client.connectionStatus?.state == MqttConnectionState.connected;
      
      if (_isConnected) {
        print('✅ Conectado ao HiveMQ!');
        _connectionController.add(true);
        
        // Subscreve aos tópicos
        _subscribeToTopics();
        
        // Configura callback para receber mensagens
        client.updates?.listen(_onMessageReceived);
      } else {
        print('❌ Falha ao conectar MQTT');
        _connectionController.add(false);
      }
      
      return _isConnected;
    } catch (e) {
      print('❌ Erro ao conectar MQTT: $e');
      _connectionController.add(false);
      return false;
    }
  }
  
  /// Callback quando conecta
  void _onConnected() {
    print('✅ MQTT: Conectado!');
    _isConnected = true;
    _connectionController.add(true);
  }
  
  /// Callback quando desconecta
  void _onDisconnected() {
    print('⚠️ MQTT: Desconectado!');
    _isConnected = false;
    _connectionController.add(false);
  }
  
  /// Callback de reconexão automática
  void _onAutoReconnect() {
    print('🔄 MQTT: Tentando reconectar...');
  }
  
  /// Subscreve aos tópicos MQTT
  void _subscribeToTopics() {
    try {
      client.subscribe(topicData, MqttQos.atLeastOnce);
      client.subscribe(topicAlertas, MqttQos.atLeastOnce);
      client.subscribe(topicStatus, MqttQos.atLeastOnce);
      
      print('📡 Inscrito nos tópicos:');
      print('  - $topicData');
      print('  - $topicAlertas');
      print('  - $topicStatus');
    } catch (e) {
      print('❌ Erro ao subscrever tópicos: $e');
    }
  }
  
  /// Processa mensagens recebidas do broker
  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage>>? messages) {
    if (messages == null) return;
    
    final recMess = messages[0].payload as MqttPublishMessage;
    final topic = messages[0].topic;
    final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      
      // Distribui mensagem para o stream apropriado baseado no tópico
      if (topic == topicData) {
        _dataController.add(data);
      } else if (topic == topicAlertas) {
        _alertsController.add(data);
      } else if (topic == topicStatus) {
        _statusController.add(data);
      }
    } catch (e) {
      print('❌ Erro ao processar mensagem: $e');
      print('Payload: $payload');
    }
  }
  
  /// Publica comando no tópico de controle
  Future<void> publishCommand(String command) async {
    if (!_isConnected) {
      print('⚠️ Não conectado ao MQTT. Comando não enviado.');
      return;
    }
    
    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(command);
      
      client.publishMessage(
        topicControle,
        MqttQos.atLeastOnce,
        builder.payload!,
      );
      
      print('📤 Comando enviado: $command');
    } catch (e) {
      print('❌ Erro ao publicar comando: $e');
    }
  }
  
  /// Envia comando para reiniciar o sistema
  Future<void> reiniciarSistema() => publishCommand('reiniciar');
  
  /// Envia comando para parar o sistema
  Future<void> pararSistema() => publishCommand('parar');
  
  /// Desconecta do broker
  void disconnect() {
    if (_isConnected) {
      client.disconnect();
      _isConnected = false;
      _connectionController.add(false);
    }
  }
  
  /// Limpa recursos
  void dispose() {
    disconnect();
    _dataController.close();
    _alertsController.close();
    _statusController.close();
    _connectionController.close();
  }
}

