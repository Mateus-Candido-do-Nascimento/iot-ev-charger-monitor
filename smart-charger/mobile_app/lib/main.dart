import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/mqtt_service.dart';
import 'models/charger_data.dart';
import 'pages/dashboard_page.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Bloqueia rotação para manter em modo retrato
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const SmartChargerApp());
}

class SmartChargerApp extends StatelessWidget {
  const SmartChargerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Charger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => DashboardPage(
              mqttService: MqttService(),
            ),
      },
    );
  }
}
