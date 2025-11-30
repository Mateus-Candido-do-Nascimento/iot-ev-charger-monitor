# 🔌 Integração 100% entre ESP32 e App Flutter via MQTT

## ✅ Resposta: SIM, é totalmente possível!

Com o código que você tem no `smart_charger.ino` conectado ao HiveMQ Cloud, **você consegue criar um app Flutter 100% integrado** que se conecta ao mesmo broker MQTT e funciona como um APK Android.

---

## 📡 Como Funciona a Integração

### 1. **Arquitetura da Comunicação**

```
ESP32 (Firmware)          HiveMQ Cloud          App Flutter
     |                          |                      |
     |---- PUBLISH (dados) ---->|                      |
     |                          |<--- SUBSCRIBE -------|
     |                          |                      |
     |<--- SUBSCRIBE -----------|---- PUBLISH (cmd) ---|
```

### 2. **Tópicos MQTT Utilizados**

#### **ESP32 → Flutter** (ESP32 publica, Flutter recebe):
- `smart-charger/001/data` - Dados dos sensores em tempo real
  - Tensão (V)
  - Corrente (A)
  - Temperatura (°C)
  - Potência (W)
  - Status do sistema
  - Estado de emergência

- `smart-charger/001/alertas` - Alertas e notificações
  - Tipo de alerta
  - Título
  - Mensagem
  - Timestamp

- `smart-charger/001/status` - Status geral do sistema
  - Estado atual
  - Timestamp

#### **Flutter → ESP32** (Flutter publica, ESP32 recebe):
- `smart-charger/001/controle` - Comandos de controle
  - `"reiniciar"` - Reinicia o sistema
  - `"parar"` - Pausa o sistema

---

## 🎯 Funcionalidades do App Flutter

### ✅ O que o app pode fazer:

1. **Monitoramento em Tempo Real**
   - Recebe dados dos sensores a cada 10 segundos
   - Exibe tensão, corrente, temperatura e potência
   - Atualização automática via MQTT

2. **Indicadores de Status**
   - Status de conexão MQTT (conectado/desconectado)
   - Status do sistema (normal/pausado/emergência)
   - Alertas visuais para emergências

3. **Histórico de Alertas**
   - Lista de todos os alertas recebidos
   - Notificações para alertas críticos
   - Badge com contador de alertas

4. **Controle Remoto**
   - Botão para reiniciar o sistema
   - Botão para parar/pausar o sistema
   - Feedback visual após enviar comandos

5. **Interface Moderna**
   - Cards visuais com dados dos sensores
   - Cores indicativas (verde=normal, laranja=alerta, vermelho=emergência)
   - Design responsivo e intuitivo

---

## 🔧 Componentes Criados

### 1. **MqttService** (`lib/services/mqtt_service.dart`)
- Gerencia conexão com HiveMQ Cloud
- Subscreve aos tópicos de dados
- Publica comandos de controle
- Streams para notificar a UI sobre novos dados
- Reconexão automática

### 2. **ChargerData Model** (`lib/models/charger_data.dart`)
- Modelo de dados estruturado
- Parsing de JSON recebido do MQTT
- Helpers para verificar status (normal, pausado, emergência)

### 3. **DashboardPage** (`lib/pages/dashboard_page.dart`)
- Interface principal do app
- Cards de dados dos sensores
- Indicadores de status
- Botões de controle
- Integração com MQTT via Streams

### 4. **AlertsPage** (`lib/alerts_page.dart`)
- Lista de alertas recebidos
- Filtros por tipo de alerta
- Histórico completo

---

## 📱 Como Gerar o APK

### Passo 1: Instalar Dependências
```bash
cd smart-charger/mobile_app
flutter pub get
```

### Passo 2: Testar no Emulador ou Dispositivo
```bash
flutter run
```

### Passo 3: Gerar APK
```bash
flutter build apk --release
```

O APK será gerado em:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Passo 4: Instalar no Celular
- Transfira o APK para o celular Android
- Habilite "Fontes desconhecidas" nas configurações
- Instale o APK normalmente

---

## 🔐 Segurança e Credenciais

⚠️ **IMPORTANTE**: As credenciais MQTT estão hardcoded no código para facilitar o desenvolvimento. Para produção, considere:

1. **Variáveis de Ambiente**: Use `flutter_dotenv` para armazenar credenciais
2. **Autenticação de Usuário**: Implemente login no app
3. **Criptografia**: O HiveMQ já usa TLS (porta 8883), garantindo comunicação segura

---

## 📊 Fluxo de Dados

### Exemplo: Recebendo Dados

1. **ESP32** lê sensores e publica:
```json
{
  "tensao_V": 220.5,
  "corrente_A": 5.2,
  "temperatura_C": 35.0,
  "potencia_W": 1146.6,
  "status": "normal",
  "emergencia": false
}
```

2. **HiveMQ Cloud** recebe e distribui para todos os subscribers

3. **App Flutter** recebe via MQTT Service e atualiza a UI automaticamente

### Exemplo: Enviando Comando

1. **Usuário** clica no botão "Reiniciar" no app Flutter

2. **App Flutter** publica `"reiniciar"` no tópico `smart-charger/001/controle`

3. **HiveMQ Cloud** distribui para o ESP32

4. **ESP32** recebe o comando e executa a ação (reinicia sistema)

---

## 🚀 Vantagens desta Arquitetura

✅ **Tempo Real**: Dados chegam instantaneamente via MQTT  
✅ **Escalável**: Pode ter múltiplos apps conectados ao mesmo broker  
✅ **Confiável**: HiveMQ Cloud garante alta disponibilidade  
✅ **Seguro**: Comunicação criptografada com TLS  
✅ **Offline Ready**: O app pode trabalhar com dados em cache  
✅ **Multiplataforma**: Flutter funciona em Android, iOS e Web  

---

## 📝 Próximos Passos (Melhorias Futuras)

- [ ] Gráficos de histórico com `fl_chart`
- [ ] Notificações push para alertas críticos
- [ ] Suporte a múltiplos carregadores
- [ ] Dashboard web
- [ ] Armazenamento local de dados
- [ ] Exportação de relatórios
- [ ] Modo offline com sincronização

---

## 🆘 Troubleshooting

### App não conecta ao MQTT
- Verifique se as credenciais estão corretas no `mqtt_service.dart`
- Verifique a conexão com internet no dispositivo
- Veja os logs no console para mais detalhes

### Dados não aparecem
- Confirme que o ESP32 está publicando dados
- Verifique se está inscrito no tópico correto
- Veja os logs do broker no HiveMQ Cloud

### Comandos não funcionam
- Verifique se o ESP32 está inscrito no tópico `smart-charger/001/controle`
- Confirme que o formato do comando está correto

---

**🎉 Pronto! Agora você tem um app Flutter 100% integrado com seu broker MQTT!**

