import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

/// Serviço MQTT para conexão com diferentes brokers MQTT
/// Gerencia conexão, subscrições e publicação de mensagens
class MqttService {
  // Usa MqttBrowserClient para web e MqttServerClient para mobile
  dynamic client;
  
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
  // 📡 CONFIGURAÇÃO MQTT - ESCOLHA O BROKER QUE DESEJA USAR
  // ===========================================================
  // OPÇÃO 1: EMQX Público (RECOMENDADO PARA WEB - tem WebSocket confiável)
  // Não precisa de usuário/senha, funciona direto
  // Para WEB: usa porta 8083 (WebSocket)
  // Para MOBILE: usa porta 1883 (TCP)
  static const String mqttServer = 'broker.emqx.io';
  static const int mqttPortWeb = 8083;  // WebSocket para web (EMQX)
  static const int mqttPortMobile = 1883;  // TCP para mobile
  static const String mqttUser = '';  // Vazio para broker público
  static const String mqttPassword = '';  // Vazio para broker público
  static const bool useTLS = false;  // false = sem TLS (mais simples)
  
  // OPÇÃO 1B: Mosquitto Público (alternativa)
  // Descomente para usar Mosquitto em vez de EMQX
  // static const String mqttServer = 'test.mosquitto.org';
  // static const int mqttPortWeb = 8080;  // WebSocket (pode não funcionar)
  // static const int mqttPortMobile = 1883;  // TCP
  
  // OPÇÃO 2: HiveMQ Cloud (COM TLS - precisa de certificado)
  // Descomente as linhas abaixo e comente as de cima para usar HiveMQ
  // static const String mqttServer = '76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud';
  // static const int mqttPort = 8883;
  // static const String mqttUser = 'mateus';
  // static const String mqttPassword = 'Mateus6615';
  // static const bool useTLS = true;
  
  // OPÇÃO 3: EMQX Cloud (gratuito - https://www.emqx.com/en/cloud)
  // Crie uma conta gratuita e use suas credenciais
  // static const String mqttServer = 'broker.emqx.io';
  // static const int mqttPort = 1883;  // ou 8883 para TLS
  // static const String mqttUser = 'seu_usuario';
  // static const String mqttPassword = 'sua_senha';
  // static const bool useTLS = false;  // ou true para TLS
  
  // OPÇÃO 4: CloudMQTT (gratuito - https://www.cloudmqtt.com)
  // Crie uma conta gratuita e use suas credenciais
  // static const String mqttServer = 'seu_servidor.cloudmqtt.com';
  // static const int mqttPort = 1883;  // ou 8883 para TLS
  // static const String mqttUser = 'seu_usuario';
  // static const String mqttPassword = 'sua_senha';
  // static const bool useTLS = false;  // ou true para TLS
  
  // Tópicos MQTT
  static const String topicData = 'smart-charger/001/data';
  static const String topicAlertas = 'smart-charger/001/alertas';
  static const String topicStatus = 'smart-charger/001/status';
  static const String topicControle = 'smart-charger/001/controle';
  
  /// Conecta ao broker MQTT
  Future<bool> connect() async {
    try {
      // Detecta se está rodando no web
      final isWeb = kIsWeb;
      final port = isWeb ? mqttPortWeb : mqttPortMobile;
      final protocol = isWeb ? 'WebSocket' : 'TCP';
      
      print('🔌 Configurando conexão MQTT...');
      print('   Plataforma: ${isWeb ? "Web" : "Mobile"}');
      print('   Protocolo: $protocol');
      print('   Servidor: $mqttServer');
      print('   Porta: $port');
      print('   TLS: $useTLS');
      
      // Cria cliente MQTT baseado na plataforma
      if (isWeb) {
        // Para WEB: usa WebSocket
        // O MqttBrowserClient precisa da URL completa com protocolo e porta
        final wsProtocol = useTLS ? 'wss' : 'ws';
        // EMQX usa /mqtt como path para WebSocket
        final wsUrl = '$wsProtocol://$mqttServer:$port/mqtt';
        client = MqttBrowserClient(wsUrl, '');
        print('   URL WebSocket: $wsUrl');
      } else {
        // Para MOBILE: usa TCP
        client = MqttServerClient.withPort(mqttServer, '', port);
        if (useTLS) {
          client.secure = true;
        } else {
          client.secure = false;
        }
      }
      
      client.logging(on: true);  // Ativa logs para debug
      client.keepAlivePeriod = 20;
      client.onConnected = _onConnected;
      client.onDisconnected = _onDisconnected;
      client.onAutoReconnect = _onAutoReconnect;
      
      // Configura mensagem de conexão
      final connMessage = MqttConnectMessage()
          .withClientIdentifier('flutter_app_${DateTime.now().millisecondsSinceEpoch}')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);
      
      // Adiciona autenticação apenas se usuário e senha foram fornecidos
      if (mqttUser.isNotEmpty && mqttPassword.isNotEmpty) {
        connMessage.authenticateAs(mqttUser, mqttPassword);
        print('   Usuário: $mqttUser');
      } else {
        print('   Autenticação: Nenhuma (broker público)');
      }
      
      client.connectionMessage = connMessage;
      
      print('🔌 Conectando ao broker MQTT...');
      
      // Tenta conectar com timeout
      try {
        await client.connect().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Timeout ao conectar ao broker MQTT');
          },
        );
      } catch (e) {
        print('❌ Erro durante conexão: $e');
        rethrow;
      }
      
      // Verifica status da conexão
      _isConnected = client.connectionStatus?.state == MqttConnectionState.connected;
      
      if (_isConnected) {
        print('✅ Conectado ao broker MQTT!');
        _connectionController.add(true);
        
        // Subscreve aos tópicos
        _subscribeToTopics();
        
        // Configura callback para receber mensagens
        client.updates?.listen(_onMessageReceived);
      } else {
        final status = client.connectionStatus?.state;
        print('❌ Falha ao conectar MQTT. Status: $status');
        print('   Código de erro: ${client.connectionStatus?.returnCode}');
        _connectionController.add(false);
      }
      
      return _isConnected;
    } catch (e, stackTrace) {
      print('❌ Erro ao conectar MQTT: $e');
      print('   Stack trace: $stackTrace');
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

