# 💻 Guia de Desenvolvimento - Smart Charger App

Este guia explica como desenvolver e melhorar o aplicativo mobile do Smart Charger.

---

## 🎯 Objetivo do App

O app mobile permite:
- **Monitorar em tempo real** os dados do carregador (tensão, corrente, temperatura)
- **Receber alertas** quando há problemas
- **Controlar o carregador** remotamente (ligar/desligar)

---

## 🏗️ Arquitetura Atual

### Componentes Principais

1. **Conexão MQTT**
   - Conecta ao broker HiveMQ Cloud
   - Subscreve ao tópico `smart-charger/001/data`
   - Recebe dados em tempo real

2. **Dashboard Screen**
   - Mostra status da conexão
   - Exibe dados do carregador
   - Atualiza automaticamente

3. **Data Cards**
   - Widgets reutilizáveis para exibir dados
   - Cada card mostra: ícone, título, valor

---

## 🔌 Entendendo a Conexão MQTT

### Como Funciona

```
Firmware ESP32 → Publica JSON → HiveMQ → App Flutter recebe
```

### Formato dos Dados

O firmware publica JSON no formato:
```json
{
  "dispositivo": "smart-charger-001",
  "tensao_V": 218.5,
  "corrente_A": 8.2,
  "potencia_W": 1791.7,
  "temperatura_C": 32.5,
  "timestamp_ms": 1234567890,
  "status": "carregando",
  "emergencia": false
}
```

### Tópicos MQTT

- **`smart-charger/001/data`** - Dados do carregador (recebemos)
- **`smart-charger/001/status`** - Status do sistema (recebemos)
- **`smart-charger/001/alertas`** - Alertas e notificações (recebemos)
- **`smart-charger/001/controle`** - Comandos de controle (enviamos)

---

## 🛠️ Melhorias e Funcionalidades a Implementar

### 1. Parsing Real de JSON

**Problema atual:** Os dados estão hardcoded (valores fixos).

**Solução:**
```dart
import 'dart:convert';

void _processMessage(String message) {
  try {
    final json = jsonDecode(message);
    setState(() {
      voltage = (json['tensao_V'] as num).toDouble();
      current = (json['corrente_A'] as num).toDouble();
      temperature = (json['temperatura_C'] as num).toDouble();
      status = json['status'] ?? 'Desconhecido';
    });
  } catch (e) {
    print('Erro ao processar JSON: $e');
  }
}
```

### 2. Tratamento de Erros

**Adicionar:**
- Verificação de conexão
- Reconexão automática
- Mensagens de erro amigáveis

### 3. Histórico de Dados

**Implementar:**
- Armazenar dados localmente (SharedPreferences ou SQLite)
- Gráficos de histórico
- Exportar dados

### 4. Notificações

**Adicionar:**
- Notificações push para alertas
- Notificações quando temperatura/corrente alta
- Notificações de emergência

### 5. Controle Remoto

**Implementar:**
- Botão para ligar/desligar carregador
- Enviar comandos via MQTT
- Feedback visual do estado

### 6. Múltiplos Carregadores

**Melhorar:**
- Lista de carregadores
- Seleção de carregador ativo
- Dados de múltiplos dispositivos

---

## 📱 Criando Novas Telas

### Estrutura Básica de uma Tela

```dart
import 'package:flutter/material.dart';

class MinhaNovaTela extends StatefulWidget {
  const MinhaNovaTela({super.key});

  @override
  State<MinhaNovaTela> createState() => _MinhaNovaTelaState();
}

class _MinhaNovaTelaState extends State<MinhaNovaTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Tela'),
      ),
      body: const Center(
        child: Text('Conteúdo da tela'),
      ),
    );
  }
}
```

### Navegação Entre Telas

```dart
// Navegar para outra tela
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const MinhaNovaTela()),
);

// Voltar
Navigator.pop(context);
```

---

## 🎨 Melhorando a UI

### Temas e Cores

**Definir tema personalizado:**
```dart
ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.green[700],
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
)
```

### Animações

**Adicionar animações suaves:**
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  // propriedades que mudam
)
```

### Ícones e Imagens

- Use ícones do Material: `Icons.bolt`
- Adicione imagens em `assets/images/`
- Configure no `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

---

## 🔐 Gerenciamento de Estado

### Para Projetos Pequenos

Use `setState()` (como está agora) - OK para começar.

### Para Projetos Maiores

Considere usar:
- **Provider** - Gerenciamento de estado simples
- **Riverpod** - Evolução do Provider
- **Bloc** - Padrão mais complexo, mas poderoso

**Exemplo com Provider:**
```dart
// Instalar: flutter pub add provider
import 'package:provider/provider.dart';

// Criar um modelo
class ChargerData extends ChangeNotifier {
  double voltage = 0.0;
  
  void updateVoltage(double v) {
    voltage = v;
    notifyListeners();
  }
}

// Usar no app
ChangeNotifierProvider(
  create: (_) => ChargerData(),
  child: MeuApp(),
)
```

---

## 📊 Adicionar Gráficos

### Pacote Recomendado: `fl_chart`

```bash
flutter pub add fl_chart
```

**Exemplo de uso:**
```dart
import 'package:fl_chart/fl_chart.dart';

LineChart(
  LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 3),
          FlSpot(1, 1),
          FlSpot(2, 4),
        ],
      ),
    ],
  ),
)
```

---

## 🔔 Adificar Notificações

### Pacote: `flutter_local_notifications`

```bash
flutter pub add flutter_local_notifications
```

**Configurar:**
1. Adicionar permissões no `AndroidManifest.xml`
2. Inicializar o plugin
3. Mostrar notificações quando receber alertas

---

## 💾 Armazenamento Local

### SharedPreferences (Dados Simples)

```bash
flutter pub add shared_preferences
```

**Uso:**
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setDouble('ultima_tensao', 218.5);
final tensao = prefs.getDouble('ultima_tensao');
```

### SQLite (Dados Complexos)

```bash
flutter pub add sqflite
```

Útil para histórico de dados com muitas entradas.

---

## 🧪 Testes

### Teste Unitário

```dart
// test/services/mqtt_service_test.dart
void main() {
  test('Processa mensagem JSON corretamente', () {
    // Teste aqui
  });
}
```

### Teste de Widget

```dart
// test/widgets/data_card_test.dart
void main() {
  testWidgets('DataCard mostra dados corretos', (tester) async {
    await tester.pumpWidget(
      DataCard(
        icon: Icons.bolt,
        title: 'Tensão',
        value: '220V',
        color: Colors.blue,
      ),
    );
    
    expect(find.text('Tensão'), findsOneWidget);
    expect(find.text('220V'), findsOneWidget);
  });
}
```

---

## 🚀 Workflow de Desenvolvimento

### 1. Planejar a Funcionalidade
- O que precisa fazer?
- Quais telas/widgets?
- Quais dependências?

### 2. Implementar
- Criar/editar arquivos
- Usar hot reload para testar
- Verificar erros com `flutter analyze`

### 3. Testar
- Testar em emulador
- Testar em dispositivo físico
- Verificar diferentes cenários

### 4. Refatorar
- Melhorar código
- Adicionar comentários
- Organizar estrutura

### 5. Commit
- Fazer commit das mudanças
- Escrever mensagem descritiva

---

## 📝 Boas Práticas

### Código Limpo
- Nomes descritivos
- Funções pequenas e focadas
- Comentários quando necessário

### Organização
- Separar em pastas (`screens/`, `widgets/`, `services/`)
- Um arquivo por classe/widget
- Agrupar código relacionado

### Performance
- Evitar rebuilds desnecessários
- Usar `const` quando possível
- Lazy loading para listas grandes

### Segurança
- Não commitar credenciais
- Validar dados recebidos
- Tratar erros adequadamente

---

## 🐛 Debugging

### Print Statements
```dart
print('Valor da tensão: $voltage');
```

### Debugger
- Coloque breakpoints no código
- Use `debugger()` para pausar

### Flutter Inspector
- No VS Code/Android Studio
- Inspeciona a árvore de widgets
- Verifica propriedades em tempo real

---

## 📚 Próximos Passos

1. **Implementar parsing real de JSON**
2. **Adicionar tratamento de erros**
3. **Melhorar a UI com animações**
4. **Adicionar gráficos de histórico**
5. **Implementar notificações**
6. **Adicionar controle remoto**

---

## 🔗 Recursos Úteis

- **Flutter Cookbook:** https://docs.flutter.dev/cookbook
- **Widget Catalog:** https://docs.flutter.dev/ui/widgets
- **Pub.dev:** https://pub.dev (pacotes)
- **Flutter Community:** https://flutter.dev/community

---

## 💡 Dicas Finais

- **Comece simples:** Implemente uma funcionalidade por vez
- **Teste frequentemente:** Use hot reload
- **Leia a documentação:** Flutter tem ótima documentação
- **Pergunte:** Stack Overflow, Discord Flutter, etc.
- **Pratique:** Quanto mais código você escreve, melhor fica


