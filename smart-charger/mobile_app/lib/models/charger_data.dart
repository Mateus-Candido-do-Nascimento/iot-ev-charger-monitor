/// Modelo de dados do carregador
/// Representa os dados recebidos do ESP32 via MQTT
class ChargerData {
  final double tensaoV;
  final double correnteA;
  final double temperaturaC;
  final double potenciaW;
  final String status;
  final bool emergencia;
  final DateTime timestamp;

  ChargerData({
    required this.tensaoV,
    required this.correnteA,
    required this.temperaturaC,
    required this.potenciaW,
    required this.status,
    required this.emergencia,
    required this.timestamp,
  });

  /// Cria ChargerData a partir de JSON recebido do MQTT
  factory ChargerData.fromJson(Map<String, dynamic> json) {
    return ChargerData(
      tensaoV: (json['tensao_V'] ?? 0.0).toDouble(),
      correnteA: (json['corrente_A'] ?? 0.0).toDouble(),
      temperaturaC: (json['temperatura_C'] ?? 0.0).toDouble(),
      potenciaW: (json['potencia_W'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'desconhecido',
      emergencia: json['emergencia'] ?? false,
      timestamp: DateTime.now(),
    );
  }

  /// Retorna true se o sistema está em estado normal
  bool get isNormal => status == 'normal' && !emergencia;

  /// Retorna true se está em emergência
  bool get isEmergency => emergencia;

  /// Retorna true se está pausado
  bool get isPaused => status == 'pausado';
}

/// Modelo de alerta do sistema
class ChargerAlert {
  final String tipo;
  final String titulo;
  final String mensagem;
  final DateTime timestamp;

  ChargerAlert({
    required this.tipo,
    required this.titulo,
    required this.mensagem,
    required this.timestamp,
  });

  factory ChargerAlert.fromJson(Map<String, dynamic> json) {
    return ChargerAlert(
      tipo: json['tipo'] ?? 'info',
      titulo: json['titulo'] ?? 'Alerta',
      mensagem: json['mensagem'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  bool get isEmergency => tipo == 'emergencia';
  bool get isWarning => tipo == 'alerta';
  bool get isInfo => tipo == 'info';
}

