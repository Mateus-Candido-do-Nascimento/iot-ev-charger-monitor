# 📖 Explicação Passo a Passo do main.dart

Este documento explica linha por linha como o código do Smart Charger funciona, especialmente a conexão MQTT.

---

## 📋 Estrutura Geral do Arquivo

O arquivo `main.dart` está organizado em 4 partes principais:

1. **Imports** - Bibliotecas necessárias
2. **SmartChargerApp** - Widget raiz do aplicativo
3. **DashboardScreen** - Tela principal com conexão MQTT
4. **DataCard** - Widget reutilizável para exibir dados

---

## 1️⃣ Imports (Linhas 1-4)

```dart
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
```

**O que faz:**
- `flutter/material.dart` - Widgets básicos do Flutter (botões, textos, etc.)
- `mqtt_client/mqtt_client.dart` - Tipos e classes do MQTT
- `mqtt_client/mqtt_server_client.dart` - Cliente MQTT para servidores
- `dart:convert` - Funções para converter JSON (jsonDecode, jsonEncode)

**Por que precisa:**
- Sem esses imports, não podemos usar widgets Flutter nem conectar ao MQTT

---

## 2️⃣ Função main() (Linhas 6-8)

```dart
void main() {
  runApp(const SmartChargerApp());
}
```

**O que faz:**
- `main()` é o ponto de entrada do app (primeira função executada)
- `runApp()` inicia o aplicativo Flutter
- `SmartChargerApp()` é o widget raiz (tudo começa aqui)

**Fluxo:**
```
main() → runApp() → SmartChargerApp → DashboardScreen
```

---

## 3️⃣ SmartChargerApp (Linhas 10-25)

```dart
class SmartChargerApp extends StatelessWidget {
  const SmartChargerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Charger',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
```

**O que faz:**
- Define o tema do app (cores verdes)
- Define qual tela aparece primeiro (`DashboardScreen`)
- Configura o título do app

**Por que StatelessWidget:**
- Não precisa mudar de estado (é estático)
- Apenas configura o app inicial

---

## 4️⃣ DashboardScreen - A Tela Principal

### 4.1 Variáveis de Estado (Linhas 33-42)

```dart
String status = 'Conectando...';
double voltage = 0.0;
double current = 0.0;
double temperature = 0.0;
double power = 0.0;

MqttServerClient? client;
bool isConnected = false;
```

**O que faz:**
- Armazena os dados que vão aparecer na tela
- `client` é o objeto que gerencia a conexão MQTT
- `isConnected` indica se está conectado ou não

**Por que StatefulWidget:**
- Precisa mudar esses valores quando recebe dados do MQTT
- `setState()` atualiza a tela quando os dados mudam

---

### 4.2 initState() - Inicialização (Linhas 48-51)

```dart
@override
void initState() {
  super.initState();
  _connectToMqtt();
}
```

**O que faz:**
- Executado UMA VEZ quando a tela é criada
- Chama `_connectToMqtt()` para conectar ao broker

**Quando acontece:**
- Quando você abre o app pela primeira vez
- Quando volta para esta tela

---

### 4.3 dispose() - Limpeza (Linhas 53-57)

```dart
@override
void dispose() {
  client?.disconnect();
  super.dispose();
}
```

**O que faz:**
- Desconecta do MQTT quando a tela é fechada
- Libera recursos (evita vazamento de memória)

**Quando acontece:**
- Quando você fecha o app
- Quando navega para outra tela (se houver)

---

## 5️⃣ Conexão MQTT - A Parte Mais Importante

### 5.1 Criando o Cliente (Linhas 60-66)

```dart
client = MqttServerClient.withPort(
  '76231e3f3c29478fb36525c03a0507ba.s1.eu.hivemq.cloud',
  'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
  8883,
);
```

**O que faz:**
- Cria um cliente MQTT
- **Parâmetro 1:** Endereço do broker (HiveMQ Cloud)
- **Parâmetro 2:** ID único do cliente (cada app precisa de um ID diferente)
- **Parâmetro 3:** Porta (8883 = porta segura SSL/TLS)

**Por que ID único:**
- Se dois apps usarem o mesmo ID, um vai desconectar o outro
- Usamos timestamp para garantir que seja único

---

### 5.2 Configurações do Cliente (Linhas 68-72)

```dart
client!.logging(on: false);
client!.secure = true;
client!.keepAlivePeriod = 60;
client!.onConnected = _onConnected;
client!.onDisconnected = _onDisconnected;
```

**O que cada linha faz:**

- `logging(on: false)` - Desativa logs (menos poluição no console)
- `secure = true` - Usa conexão segura (SSL/TLS)
- `keepAlivePeriod = 60` - Envia "ping" a cada 60 segundos (mantém conexão viva)
- `onConnected` - Função chamada quando conecta
- `onDisconnected` - Função chamada quando desconecta

**Por que keepAlive:**
- Alguns roteadores fecham conexões inativas
- O "ping" mantém a conexão aberta

---

### 5.3 Mensagem de Conexão (Linhas 74-77)

```dart
final connMessage = MqttConnectMessage()
    .withClientIdentifier(client!.clientIdentifier!)
    .startClean()
    .withWillQos(MqttQos.atLeastOnce);
```

**O que faz:**
- Cria a mensagem que será enviada ao broker
- `withClientIdentifier` - Define o ID do cliente
- `startClean` - Começa "limpo" (sem mensagens antigas)
- `withWillQos` - Qualidade de serviço (garante entrega)

**Por que startClean:**
- Se o app desconectar e reconectar, não quer mensagens antigas

---

### 5.4 Conectando (Linhas 79-81)

```dart
client!.connectionMessage = connMessage;
client!.connect('mateus', 'Mateus6615');
await Future.delayed(const Duration(seconds: 2));
```

**O que faz:**
- Define a mensagem de conexão
- Tenta conectar com usuário e senha
- Aguarda 2 segundos para a conexão estabelecer

**Por que await:**
- A conexão é assíncrona (não acontece instantaneamente)
- Aguardamos um pouco antes de verificar se conectou

---

### 5.5 Verificando Conexão (Linhas 83-88)

```dart
if (client!.connectionStatus!.state == MqttConnectionState.connected) {
  print('✅ Conectado ao MQTT!');
  setState(() {
    isConnected = true;
    status = 'Conectado';
  });
```

**O que faz:**
- Verifica se realmente conectou
- Atualiza o estado da tela (`setState`)
- Muda o status para "Conectado"

**Por que setState:**
- Atualiza a interface (muda a cor, o texto, etc.)

---

### 5.6 Inscrevendo em Tópicos (Linhas 90-91)

```dart
client!.subscribe('smart-charger/001/data', MqttQos.atMostOnce);
client!.subscribe('smart-charger/001/alertas', MqttQos.atMostOnce);
```

**O que faz:**
- Diz ao broker: "Quero receber mensagens destes tópicos"
- `smart-charger/001/data` - Dados do carregador
- `smart-charger/001/alertas` - Alertas e notificações

**O que é um tópico:**
- É como um "canal" de comunicação
- O ESP32 publica neste canal
- O app escuta neste canal

**Por que Qos.atMostOnce:**
- Não precisa garantir entrega (dados em tempo real)
- Mais rápido e eficiente

---

### 5.7 Ouvindo Mensagens (Linhas 93-99)

```dart
client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
  if (c != null) {
    final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
    final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    _processMessage(message);
  }
});
```

**O que faz:**
- Cria um "listener" (ouvinte) de mensagens
- Quando chega uma mensagem, executa o código dentro
- Converte a mensagem de bytes para string
- Chama `_processMessage()` para processar

**Fluxo:**
```
ESP32 publica → Broker recebe → App recebe → _processMessage() → Atualiza tela
```

**Por que listen:**
- É um stream (fluxo contínuo)
- Pode receber várias mensagens
- Cada mensagem dispara o código

---

## 6️⃣ Processando Mensagens

### 6.1 _processMessage() (Linhas 118-135)

```dart
void _processMessage(String message) {
  print('📨 Mensagem recebida: $message');
  
  try {
    final json = jsonDecode(message);
    
    setState(() {
      voltage = (json['tensao_V'] as num?)?.toDouble() ?? 0.0;
      current = (json['corrente_A'] as num?)?.toDouble() ?? 0.0;
      temperature = (json['temperatura_C'] as num?)?.toDouble() ?? 0.0;
      power = (json['potencia_W'] as num?)?.toDouble() ?? (voltage * current);
      status = json['status'] ?? 'Recebendo dados';
    });
  } catch (e) {
    print('❌ Erro ao processar JSON: $e');
  }
}
```

**O que faz:**
1. Recebe a mensagem (string JSON)
2. Converte de string para objeto JSON (`jsonDecode`)
3. Extrai os valores (tensão, corrente, etc.)
4. Atualiza a tela com `setState()`

**Exemplo de mensagem recebida:**
```json
{
  "tensao_V": 218.5,
  "corrente_A": 8.2,
  "temperatura_C": 32.5,
  "potencia_W": 1791.7,
  "status": "carregando"
}
```

**Por que try/catch:**
- Se a mensagem não for JSON válido, não quebra o app
- Apenas mostra erro no console

**Por que `?? 0.0`:**
- Se o valor não existir no JSON, usa 0.0
- Evita erros de null

---

## 7️⃣ Interface (build method)

### 7.1 Estrutura da Tela (Linhas 145-160)

```dart
return Scaffold(
  appBar: AppBar(...),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        // Card de status
        // Título "Dados em Tempo Real"
        // Lista de cards com dados
      ],
    ),
  ),
);
```

**O que faz:**
- `Scaffold` - Estrutura básica da tela (AppBar + Body)
- `Padding` - Espaçamento nas bordas
- `Column` - Organiza widgets verticalmente

---

### 7.2 Card de Status (Linhas 162-185)

```dart
Card(
  color: isConnected ? Colors.green.shade50 : Colors.orange.shade50,
  child: Padding(
    child: Row(
      children: [
        Icon(isConnected ? Icons.check_circle : Icons.error),
        Text(status),
        if (!isConnected) IconButton(icon: Icons.refresh, ...),
      ],
    ),
  ),
)
```

**O que faz:**
- Mostra se está conectado ou não
- Muda de cor conforme o status
- Botão de reconexão se desconectado

**Por que condicional:**
- `isConnected ? verde : laranja` - Muda cor dinamicamente
- `if (!isConnected)` - Só mostra botão se desconectado

---

### 7.3 DataCard - Widget Reutilizável

```dart
DataCard(
  icon: Icons.bolt,
  title: 'Tensão',
  value: '${voltage.toStringAsFixed(1)} V',
  color: Colors.blue,
)
```

**O que faz:**
- Cria um card bonito para cada dado
- Recebe: ícone, título, valor, cor
- Formata o número (`toStringAsFixed(1)`) - 1 casa decimal

**Por que widget separado:**
- Pode usar várias vezes (DRY - Don't Repeat Yourself)
- Fácil de manter e modificar

---

## 🔄 Fluxo Completo do App

```
1. App inicia
   ↓
2. main() → runApp() → SmartChargerApp
   ↓
3. DashboardScreen é criada
   ↓
4. initState() → _connectToMqtt()
   ↓
5. Cliente MQTT criado e configurado
   ↓
6. Conecta ao broker HiveMQ
   ↓
7. Se conecta com sucesso:
   - Inscreve nos tópicos
   - Cria listener de mensagens
   ↓
8. ESP32 publica dados
   ↓
9. Broker recebe e repassa
   ↓
10. App recebe mensagem
   ↓
11. _processMessage() processa JSON
   ↓
12. setState() atualiza a tela
   ↓
13. Usuário vê dados atualizados
```

---

## 💡 Conceitos Importantes

### StatefulWidget vs StatelessWidget

- **StatelessWidget:** Não muda (ex: SmartChargerApp)
- **StatefulWidget:** Pode mudar (ex: DashboardScreen)

### setState()

- Atualiza a tela quando dados mudam
- Sem `setState()`, a tela não atualiza mesmo que os dados mudem

### Async/Await

- Operações que demoram (rede, arquivos)
- `await` espera a operação terminar
- `async` permite usar `await`

### Stream/Listen

- Fluxo contínuo de dados
- `listen()` executa código a cada nova mensagem
- Perfeito para dados em tempo real

---

## 🔧 Como Modificar

### Adicionar Novo Dado

1. Adicione variável no estado:
```dart
double novoDado = 0.0;
```

2. Atualize em `_processMessage()`:
```dart
novoDado = (json['novo_dado'] as num?)?.toDouble() ?? 0.0;
```

3. Adicione card na tela:
```dart
DataCard(
  icon: Icons.novo_icone,
  title: 'Novo Dado',
  value: '${novoDado.toStringAsFixed(1)}',
  color: Colors.cyan,
)
```

### Mudar Broker MQTT

Altere a linha 61:
```dart
client = MqttServerClient.withPort(
  'novo-endereco.com',  // ← Mude aqui
  'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
  8883,
);
```

### Adicionar Novo Tópico

Adicione após linha 91:
```dart
client!.subscribe('smart-charger/001/novo-topico', MqttQos.atMostOnce);
```

---

## 📚 Próximos Passos

Agora que você entende o código:

1. **Experimente modificar** - Mude cores, adicione dados
2. **Adicione funcionalidades** - Veja `docs/05-desenvolvimento.md`
3. **Melhore o tratamento de erros** - Adicione mais verificações
4. **Adicione gráficos** - Mostre histórico de dados

---

**Dúvidas? Consulte a documentação ou pergunte!** 🚀

