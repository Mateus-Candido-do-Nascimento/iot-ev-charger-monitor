# 🔌 Brokers MQTT Alternativos - Solução para Problemas de Conexão

## 📋 Problema Identificado

Se você está tendo problemas para conectar ao HiveMQ Cloud ou gerar o APK, pode ser devido a:
- Problemas com certificados TLS/SSL
- Limitações do broker HiveMQ Cloud
- Configurações de rede no APK Android

## ✅ Solução: Usar Broker MQTT Alternativo

O código foi atualizado para suportar múltiplos brokers MQTT. Por padrão, está configurado para usar o **Mosquitto Público**, que é mais simples e funciona sem TLS.

---

## 🎯 Opções de Brokers Disponíveis

### 1. **Mosquitto Público** (RECOMENDADO PARA TESTES) ⭐

**Vantagens:**
- ✅ Gratuito e público
- ✅ Não precisa de cadastro
- ✅ Funciona sem TLS (mais simples)
- ✅ Funciona perfeitamente em APKs Android
- ✅ Sem limite de conexões para testes

**Configuração:**
- **Servidor:** `test.mosquitto.org`
- **Porta:** `1883` (sem TLS) ou `8883` (com TLS)
- **Usuário:** Vazio (não precisa)
- **Senha:** Vazio (não precisa)
- **TLS:** `false`

**Limitações:**
- ⚠️ Público - qualquer um pode ver suas mensagens (não use para dados sensíveis)
- ⚠️ Pode ter limitações de taxa em horários de pico
- ⚠️ Não é recomendado para produção

---

### 2. **HiveMQ Cloud** (Original)

**Vantagens:**
- ✅ Plano gratuito disponível
- ✅ Alta disponibilidade
- ✅ Suporte a TLS/SSL
- ✅ Dashboard para monitoramento

**Configuração:**
- **Servidor:** `seu-id.s1.eu.hivemq.cloud`
- **Porta:** `8883` (TLS obrigatório)
- **Usuário:** Seu usuário
- **Senha:** Sua senha
- **TLS:** `true`

**Como obter:**
1. Acesse https://www.hivemq.com/cloud/
2. Crie uma conta gratuita
3. Crie um cluster
4. Copie as credenciais

---

### 3. **EMQX Cloud** (Gratuito)

**Vantagens:**
- ✅ Plano gratuito (até 1000 conexões)
- ✅ Dashboard completo
- ✅ Suporte a TLS opcional
- ✅ Boa documentação

**Configuração:**
- **Servidor:** `broker.emqx.io` (público) ou seu servidor personalizado
- **Porta:** `1883` (sem TLS) ou `8883` (com TLS)
- **Usuário:** Seu usuário (se usar servidor personalizado)
- **Senha:** Sua senha (se usar servidor personalizado)
- **TLS:** `false` ou `true`

**Como obter:**
1. Acesse https://www.emqx.com/en/cloud
2. Crie uma conta gratuita
3. Crie uma instância
4. Copie as credenciais

---

### 4. **CloudMQTT** (Gratuito)

**Vantagens:**
- ✅ Plano gratuito (até 25 conexões)
- ✅ Fácil de configurar
- ✅ Suporte a TLS opcional

**Configuração:**
- **Servidor:** `seu-servidor.cloudmqtt.com`
- **Porta:** `1883` (sem TLS) ou `8883` (com TLS)
- **Usuário:** Seu usuário
- **Senha:** Sua senha
- **TLS:** `false` ou `true`

**Como obter:**
1. Acesse https://www.cloudmqtt.com
2. Crie uma conta gratuita
3. Crie uma instância
4. Copie as credenciais

---

## 🔧 Como Mudar o Broker no Código

### No App Flutter (`mqtt_service.dart`)

1. Abra o arquivo: `smart-charger/mobile_app/lib/services/mqtt_service.dart`

2. Localize a seção de configuração (linhas ~27-45)

3. **Para usar Mosquitto Público (padrão):**
```dart
static const String mqttServer = 'test.mosquitto.org';
static const int mqttPort = 1883;
static const String mqttUser = '';
static const String mqttPassword = '';
static const bool useTLS = false;
```

4. **Para usar HiveMQ Cloud:**
```dart
static const String mqttServer = '76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud';
static const int mqttPort = 8883;
static const String mqttUser = 'mateus';
static const String mqttPassword = 'Mateus6615';
static const bool useTLS = true;
```

5. **Para usar EMQX Cloud:**
```dart
static const String mqttServer = 'broker.emqx.io';
static const int mqttPort = 1883;
static const String mqttUser = 'seu_usuario';
static const String mqttPassword = 'sua_senha';
static const bool useTLS = false;
```

---

### No Firmware ESP32 (`smart_charger.ino`)

1. Abra o arquivo: `smart-charger/firmware/smart_charger.ino`

2. Localize a seção de configuração MQTT (linhas ~60-72)

3. **Para usar Mosquitto Público (padrão):**
```cpp
const char* mqtt_server   = "test.mosquitto.org";
const int   mqtt_port     = 1883;
const char* mqtt_user     = "";
const char* mqtt_password = "";
const bool  use_tls       = false;
```

4. **Para usar HiveMQ Cloud:**
```cpp
const char* mqtt_server   = "76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud";
const int   mqtt_port     = 8883;
const char* mqtt_user     = "mateus";
const char* mqtt_password = "Mateus6615";
const bool  use_tls       = true;
```

5. **Para usar EMQX Cloud:**
```cpp
const char* mqtt_server   = "broker.emqx.io";
const int   mqtt_port     = 1883;
const char* mqtt_user     = "seu_usuario";
const char* mqtt_password = "sua_senha";
const bool  use_tls       = false;
```

---

## 🚀 Testando a Conexão

### 1. Teste com Mosquitto Público (Mais Fácil)

**Passo 1:** Configure o app Flutter para usar Mosquitto
```dart
static const String mqttServer = 'test.mosquitto.org';
static const int mqttPort = 1883;
static const bool useTLS = false;
```

**Passo 2:** Configure o firmware ESP32 para usar Mosquitto
```cpp
const char* mqtt_server = "test.mosquitto.org";
const int   mqtt_port = 1883;
const bool  use_tls = false;
```

**Passo 3:** Compile e teste
- Faça upload do firmware no ESP32
- Execute o app Flutter
- Verifique os logs no Serial Monitor e no console do Flutter

**Passo 4:** Gere o APK
```bash
cd smart-charger/mobile_app
flutter build apk --release
```

---

### 2. Verificar se Está Funcionando

**No Serial Monitor do ESP32, você deve ver:**
```
🔌 Conectando ao broker MQTT: test.mosquitto.org
   Porta: 1883
   TLS: Não
   Sem autenticação (broker público)...
✅ MQTT conectado!
   Inscrito no tópico: smart-charger/001/controle
```

**No console do Flutter, você deve ver:**
```
🔌 Configurando conexão MQTT...
   Servidor: test.mosquitto.org
   Porta: 1883
   TLS: false
   Autenticação: Nenhuma (broker público)
🔌 Conectando ao broker MQTT...
✅ Conectado ao broker MQTT!
📡 Inscrito nos tópicos:
  - smart-charger/001/data
  - smart-charger/001/alertas
  - smart-charger/001/status
```

---

## 🐛 Solução de Problemas

### Problema: "Conectando ao broker MQTT..." mas nunca conecta

**Soluções:**
1. ✅ Verifique se está usando o mesmo broker no app e no firmware
2. ✅ Verifique se a porta está correta (1883 sem TLS, 8883 com TLS)
3. ✅ Verifique se `useTLS` está correto em ambos os códigos
4. ✅ Teste primeiro com Mosquitto Público (mais simples)
5. ✅ Verifique sua conexão com internet

### Problema: Erro de certificado TLS

**Soluções:**
1. ✅ Use um broker sem TLS primeiro (Mosquitto na porta 1883)
2. ✅ Se precisar de TLS, verifique se o certificado está correto no firmware
3. ✅ Tente usar EMQX ou CloudMQTT com TLS desabilitado

### Problema: APK não conecta ao MQTT

**Soluções:**
1. ✅ Use Mosquitto Público (test.mosquitto.org) - funciona melhor em APKs
2. ✅ Desabilite TLS (`useTLS = false`)
3. ✅ Verifique permissões de internet no AndroidManifest.xml
4. ✅ Teste primeiro no emulador antes de gerar o APK

---

## 📝 Checklist para Gerar APK Funcional

- [ ] App Flutter configurado com broker MQTT (preferencialmente Mosquitto)
- [ ] Firmware ESP32 configurado com o mesmo broker
- [ ] `useTLS = false` se usar Mosquitto público
- [ ] Testado no emulador/device antes de gerar APK
- [ ] Permissões de internet no AndroidManifest.xml
- [ ] APK gerado com `flutter build apk --release`
- [ ] APK instalado e testado no dispositivo físico

---

## 🎉 Próximos Passos

1. **Teste com Mosquitto Público primeiro** - é o mais simples
2. **Se funcionar, você pode migrar para um broker com autenticação** (EMQX, CloudMQTT)
3. **Para produção, considere usar um broker próprio** ou um serviço pago

---

## 📚 Recursos Adicionais

- **Mosquitto:** https://mosquitto.org/
- **EMQX Cloud:** https://www.emqx.com/en/cloud
- **CloudMQTT:** https://www.cloudmqtt.com
- **HiveMQ Cloud:** https://www.hivemq.com/cloud/

---

**💡 Dica:** Comece sempre com o Mosquitto Público para garantir que o código funciona. Depois migre para um broker com autenticação se necessário.

