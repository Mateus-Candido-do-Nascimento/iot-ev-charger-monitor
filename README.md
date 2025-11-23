# 🔋 Smart Charger - Monitor de Carregador de Veículo Elétrico

Sistema IoT completo para monitoramento e controle de carregadores de veículos elétricos em tempo real.

## 📋 Sobre o Projeto

Este projeto consiste em:

- **Firmware ESP32** - Coleta dados de sensores (tensão, corrente, temperatura) e publica via MQTT
- **App Mobile Flutter** - Interface mobile para monitorar e controlar o carregador em tempo real
- **Broker MQTT** - Comunicação em tempo real entre firmware e app

## 🏗️ Estrutura do Projeto

```
iot-ev-charger-monitor/
├── smart-charger/
│   ├── firmware/          # Código Arduino/ESP32
│   │   └── smart_charger.ino
│   └── mobile_app/        # Aplicativo Flutter
│       ├── lib/
│       │   └── main.dart
│       └── pubspec.yaml
├── docs/                   # 📚 Documentação completa
│   ├── README.md
│   ├── 01-instalacao-flutter.md
│   ├── 02-comandos-flutter.md
│   ├── 03-dispositivos-emuladores.md
│   ├── 04-estrutura-projeto.md
│   └── 05-desenvolvimento.md
└── README.md
```

## 🚀 Início Rápido

### Para o App Mobile (Flutter)

1. **Instale o Flutter:**
   - Siga o guia completo: [`docs/01-instalacao-flutter.md`](docs/01-instalacao-flutter.md)

2. **Configure um dispositivo:**
   - Veja: [`docs/03-dispositivos-emuladores.md`](docs/03-dispositivos-emuladores.md)

3. **Execute o app:**
   ```bash
   cd smart-charger/mobile_app
   flutter pub get
   flutter run
   ```

   **Ou gere um APK para instalar no celular:**
   ```bash
   flutter build apk
   # O APK estará em: build/app/outputs/flutter-apk/app-release.apk
   ```
   Veja: [`docs/14-gerar-apk-instalar.md`](docs/14-gerar-apk-instalar.md)

### Para o Firmware (ESP32)

1. Abra o arquivo `smart-charger/firmware/smart_charger.ino` no Arduino IDE
2. Configure suas credenciais WiFi e MQTT
3. Faça upload para o ESP32

## 📚 Documentação

Toda a documentação está na pasta [`docs/`](docs/):

### 📖 Guias Principais
- **[README](docs/README.md)** - Índice geral da documentação
- **[Instalação do Flutter](docs/01-instalacao-flutter.md)** - Guia completo de instalação
- **[Comandos Úteis](docs/02-comandos-flutter.md)** - Referência de comandos Flutter
- **[Estrutura do Projeto](docs/04-estrutura-projeto.md)** - Organização do código
- **[Guia de Desenvolvimento](docs/05-desenvolvimento.md)** - Como desenvolver funcionalidades
- **[Explicação do main.dart](docs/07-explicacao-main-dart.md)** - Como o código funciona

### 📱 Dispositivos e Testes
- **[Dispositivos e Emuladores](docs/03-dispositivos-emuladores.md)** - Configuração de dispositivos
- **[Configurar Celular Físico](docs/08-configurar-celular-fisico.md)** - Conectar celular Android
- **[Emulador Android Studio](docs/09-emulador-android-studio.md)** - Criar e usar emulador
- **[Gerar APK e Instalar](docs/14-gerar-apk-instalar.md)** - Gerar APK para instalar no celular ⭐

### 🔧 Troubleshooting
- **[Troubleshooting](docs/06-troubleshooting.md)** - Solução de problemas comuns
- **[Erro: Emulador Não Inicia](docs/10-erro-emulador-startup.md)** - Solução para erros do emulador
- **[Solução Rápida: pub get Travando](docs/SOLUCAO-RAPIDA-pub-get-travando.md)** - Resolver problema de dependências
- **[Solução Rápida: Erro Emulador](docs/SOLUCAO-RAPIDA-emulador-erro.md)** - Resolver erro do emulador rapidamente

## 🛠️ Tecnologias

- **Flutter** - Framework mobile multiplataforma
- **Dart** - Linguagem de programação
- **MQTT** - Protocolo de comunicação IoT
- **ESP32** - Microcontrolador
- **Arduino** - Plataforma de desenvolvimento

## 📱 Funcionalidades

### Atuais
- ✅ Conexão MQTT em tempo real
- ✅ Monitoramento de tensão, corrente e temperatura
- ✅ Interface visual com cards de dados
- ✅ Status de conexão

### Planejadas
- 🔄 Parsing real de JSON dos dados
- 🔄 Histórico de dados com gráficos
- 🔄 Notificações de alertas
- 🔄 Controle remoto (ligar/desligar)
- 🔄 Suporte a múltiplos carregadores

## 📝 Comandos Úteis

```bash
# Verificar instalação
flutter doctor

# Instalar dependências
flutter pub get

# Executar o app
flutter run

# Ver dispositivos disponíveis
flutter devices

# Analisar código
flutter analyze
```

Para mais comandos, veja: [`docs/02-comandos-flutter.md`](docs/02-comandos-flutter.md)

## 🔧 Requisitos

### Para o App Mobile
- Flutter SDK (última versão estável)
- Android Studio ou VS Code
- Android SDK
- Dispositivo Android ou emulador

### Para o Firmware
- Arduino IDE
- ESP32 Development Board
- Sensores: SCT-013, ZMPT101B, DHT22

## 📖 Aprendizado

Este projeto foi criado para ser educativo. A documentação em `docs/` explica:
- Como instalar e configurar tudo do zero
- Comandos úteis e quando usá-los
- Estrutura e organização do código
- Como desenvolver novas funcionalidades
- Boas práticas de desenvolvimento

## 🤝 Contribuindo

1. Leia a documentação em `docs/`
2. Siga as convenções de código
3. Teste suas mudanças
4. Documente funcionalidades novas

## 📄 Licença

Este projeto é para fins educacionais.

## 🔗 Links Úteis

- [Documentação Flutter](https://docs.flutter.dev/)
- [Pub.dev (Pacotes)](https://pub.dev/)
- [Arduino ESP32](https://docs.espressif.com/projects/arduino-esp32/en/latest/)

---

**Desenvolvido com ❤️ para aprendizado e prática de IoT e desenvolvimento mobile**


