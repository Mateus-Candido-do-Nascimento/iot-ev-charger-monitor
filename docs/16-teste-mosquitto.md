# 🧪 Teste Rápido com Mosquitto

## ✅ Status Atual

O código já está configurado para usar o **Mosquitto Público** (`test.mosquitto.org`):
- ✅ App Flutter: Configurado
- ✅ Firmware ESP32: Configurado
- ✅ Sem TLS: Configurado
- ✅ Sem autenticação: Configurado

---

## 🚀 Como Testar Agora

### Opção 1: Usar Mosquitto Público (Mais Fácil)

**Já está configurado!** Basta:

1. **Fazer upload do firmware no ESP32:**
   - Abra o Arduino IDE
   - Conecte o ESP32
   - Faça upload do `smart_charger.ino`
   - Abra o Serial Monitor (115200 baud)

2. **Executar o app Flutter:**
   ```bash
   cd smart-charger/mobile_app
   flutter run
   ```

3. **Verificar os logs:**

   **No Serial Monitor do ESP32, você deve ver:**
   ```
   🔌 Conectando ao broker MQTT: test.mosquitto.org
      Porta: 1883
      TLS: Não
      Sem autenticação (broker público)...
   ✅ MQTT conectado!
      Inscrito no tópico: smart-charger/001/controle
   📤 DADOS ENVIADOS: {...}
   ```

   **No console do Flutter, você deve ver:**
   ```
   🔌 Configurando conexão MQTT...
      Servidor: test.mosquitto.org
      Porta: 1883
      TLS: false
   🔌 Conectando ao broker MQTT...
   ✅ Conectado ao broker MQTT!
   📡 Inscrito nos tópicos:
     - smart-charger/001/data
     - smart-charger/001/alertas
     - smart-charger/001/status
   ```

4. **Gerar o APK:**
   ```bash
   cd smart-charger/mobile_app
   flutter build apk --release
   ```

---

### Opção 2: Usar Mosquitto Local (Se você instalou)

Se você instalou o Mosquitto no seu computador e quer usar o broker local:

#### 1. Iniciar o Mosquitto localmente

**Windows:**
```powershell
# Se instalou via Chocolatey ou instalador
mosquitto -v
```

**Linux/Mac:**
```bash
mosquitto -v
```

#### 2. Configurar o IP do seu computador

Descubra o IP da sua máquina:

**Windows:**
```powershell
ipconfig
# Procure por "IPv4 Address" (ex: 192.168.1.100)
```

**Linux/Mac:**
```bash
ifconfig
# ou
ip addr show
# Procure por seu IP local (ex: 192.168.1.100)
```

#### 3. Atualizar o código

**No App Flutter** (`mqtt_service.dart`):
```dart
static const String mqttServer = '192.168.1.100';  // SEU IP AQUI
static const int mqttPort = 1883;
static const String mqttUser = '';
static const String mqttPassword = '';
static const bool useTLS = false;
```

**No Firmware ESP32** (`smart_charger.ino`):
```cpp
const char* mqtt_server   = "192.168.1.100";  // SEU IP AQUI
const int   mqtt_port     = 1883;
const char* mqtt_user     = "";
const char* mqtt_password = "";
const bool  use_tls       = false;
```

⚠️ **Importante:** O ESP32 e o celular precisam estar na mesma rede Wi-Fi que o computador!

---

## 🔍 Verificar se Está Funcionando

### Teste 1: Ver dados no app

1. Execute o app Flutter
2. Você deve ver os dados do carregador aparecendo na tela
3. Os valores devem atualizar a cada 10 segundos

### Teste 2: Verificar conexão MQTT

Use um cliente MQTT para verificar se as mensagens estão chegando:

**Opção A: MQTT Explorer (Windows/Mac/Linux)**
- Download: https://mqtt-explorer.com/
- Configure:
  - Host: `test.mosquitto.org` (ou seu IP local)
  - Port: `1883`
  - Sem autenticação
- Subscreva ao tópico: `smart-charger/001/data`

**Opção B: MQTT.fx (Windows/Mac/Linux)**
- Download: https://mqttfx.jensd.de/
- Configure da mesma forma

**Opção C: Via linha de comando (se tiver mosquitto instalado)**
```bash
mosquitto_sub -h test.mosquitto.org -t "smart-charger/001/data" -v
```

---

## 🐛 Problemas Comuns

### Problema: "Conectando ao broker MQTT..." mas nunca conecta

**Soluções:**
1. ✅ Verifique sua conexão com internet (se usar Mosquitto público)
2. ✅ Verifique se ESP32 e celular estão na mesma rede Wi-Fi (se usar Mosquitto local)
3. ✅ Verifique se o Mosquitto está rodando (se usar local)
4. ✅ Teste com o cliente MQTT primeiro para verificar se o broker está acessível

### Problema: Erro "Connection refused"

**Soluções:**
1. ✅ Verifique se a porta 1883 está aberta no firewall (se usar Mosquitto local)
2. ✅ Verifique se o IP está correto
3. ✅ Tente usar o Mosquitto público primeiro (`test.mosquitto.org`)

### Problema: APK não conecta

**Soluções:**
1. ✅ Verifique permissões de internet no AndroidManifest.xml
2. ✅ Teste primeiro no emulador/dispositivo conectado via USB
3. ✅ Verifique se o dispositivo tem internet (Wi-Fi ou dados móveis)

---

## 📱 Gerar APK para Testar

```bash
cd smart-charger/mobile_app
flutter clean
flutter pub get
flutter build apk --release
```

O APK estará em: `build/app/outputs/flutter-apk/app-release.apk`

---

## ✅ Checklist de Teste

- [ ] Firmware ESP32 carregado e conectado ao Wi-Fi
- [ ] Serial Monitor mostrando "✅ MQTT conectado!"
- [ ] App Flutter executando e mostrando "✅ Conectado ao broker MQTT!"
- [ ] Dados aparecendo na tela do app
- [ ] APK gerado com sucesso
- [ ] APK instalado no celular
- [ ] APK conecta ao MQTT no celular

---

## 🎉 Próximos Passos

1. **Se funcionar com Mosquitto público:** ✅ Perfeito! Você pode gerar o APK
2. **Se quiser mais segurança:** Configure um broker com autenticação (EMQX, CloudMQTT)
3. **Se quiser usar local:** Configure o Mosquitto local com autenticação

---

**💡 Dica:** Comece sempre testando no emulador/dispositivo conectado via USB antes de gerar o APK. Isso facilita o debug!

