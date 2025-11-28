import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  final List<Map<String, dynamic>> alerts;

  const AlertsPage({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("⚠️ Alertas"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: alerts.isEmpty
          ? const Center(
              child: Text(
                "Nenhum alerta recebido ainda.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, i) {
                final item = alerts[i];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      item["severidade"] == "emergencia"
                          ? Icons.error
                          : Icons.warning_amber,
                      color: item["severidade"] == "emergencia"
                          ? Colors.red
                          : Colors.orange,
                      size: 32,
                    ),
                    title: Text(item["titulo"]),
                    subtitle: Text(item["mensagem"]),
                  ),
                );
              },
            ),
    );
  }
}
