# 📁 Estrutura do Projeto Mobile - Smart Charger

Este documento explica a estrutura do projeto Flutter e como tudo se organiza.

---

## 🗂️ Visão Geral da Estrutura

```
smart-charger/mobile_app/
├── android/          # Configurações específicas do Android
├── ios/              # Configurações específicas do iOS
├── lib/              # Código fonte principal (AQUI VOCÊ VAI TRABALHAR)
│   └── main.dart     # Arquivo principal do app
├── test/             # Testes unitários
├── pubspec.yaml      # Dependências e configurações do projeto
└── README.md         # Documentação básica
```

---

## 📄 Arquivos Importantes

### `pubspec.yaml` - O Coração do Projeto

Este arquivo define:
- **Nome do app**
- **Versão**
- **Dependências** (pacotes externos que o app usa)
- **Assets** (imagens, fontes, etc.)

**Exemplo do nosso projeto:**
```yaml
name: mobile_app
version: 1.0.0+1
dependencies:
  flutter:
    sdk: flutter
  mqtt_client: ^9.0.0  # Cliente MQTT para comunicação
```

**Quando adicionar uma dependência:**
1. Adicione no `pubspec.yaml`
2. Execute `flutter pub get`
3. Importe no código: `import 'package:nome_do_pacote/nome_do_pacote.dart';`

### `lib/main.dart` - Arquivo Principal

Este é o ponto de entrada do app. Tudo começa aqui.

**Estrutura típica:**
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());  // Inicia o app
}

class MeuApp extends StatelessWidget {
  // Define o tema e configurações gerais
}

class MinhaTela extends StatefulWidget {
  // Define uma tela do app
}
```

---

## 📂 Pasta `lib/` - Organização do Código

A pasta `lib/` é onde você vai escrever todo o código do app.

### Estrutura Recomendada (para projetos maiores):

```
lib/
├── main.dart                 # Ponto de entrada
├── models/                   # Modelos de dados
│   └── charger_data.dart
├── services/                 # Serviços (MQTT, API, etc.)
│   └── mqtt_service.dart
├── screens/                  # Telas do app
│   ├── dashboard_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Componentes reutilizáveis
│   └── data_card.dart
└── utils/                    # Utilitários
    └── constants.dart
```

### Estrutura Atual (projeto simples):

Por enquanto, tudo está no `main.dart`, o que é OK para começar. Conforme o projeto cresce, vamos organizar melhor.

---

## 🔧 Pastas de Plataforma

### `android/` - Configurações Android

**Arquivos importantes:**
- `android/app/build.gradle` - Configurações de build
- `android/app/src/main/AndroidManifest.xml` - Permissões e configurações do app
- `android/app/src/main/kotlin/` - Código nativo Android (se necessário)

**Quando mexer aqui:**
- Adicionar permissões (internet, localização, etc.)
- Configurar ícone do app
- Configurar nome do app
- Configurar versão

### `ios/` - Configurações iOS

Similar ao Android, mas para iOS. Só é necessário se você for publicar no iOS.

---

## 📦 Dependências do Projeto

### Dependências Atuais

**mqtt_client:**
- Usado para conectar ao broker MQTT (HiveMQ)
- Permite receber dados em tempo real do carregador

### Como Adicionar Novas Dependências

1. **Encontre o pacote no pub.dev:**
   - Acesse: https://pub.dev
   - Procure pelo pacote (ex: "http", "shared_preferences")

2. **Adicione no `pubspec.yaml`:**
   ```yaml
   dependencies:
     http: ^1.1.0
   ```

3. **Instale:**
   ```bash
   flutter pub get
   ```

4. **Use no código:**
   ```dart
   import 'package:http/http.dart' as http;
   ```

---

## 🎨 Estrutura do Código Atual

### `main.dart` - Análise Rápida

O arquivo atual tem:

1. **SmartChargerApp** - Widget raiz
   - Define o tema do app
   - Define a tela inicial

2. **DashboardScreen** - Tela principal
   - Conecta ao MQTT
   - Recebe dados do carregador
   - Mostra dados em tempo real

3. **DataCard** - Widget reutilizável
   - Mostra um dado (tensão, corrente, temperatura)
   - Pode ser usado várias vezes

### Fluxo de Dados

```
ESP32 (Firmware)
    ↓
    Publica dados via MQTT
    ↓
HiveMQ Cloud (Broker)
    ↓
    App Flutter se conecta
    ↓
DashboardScreen recebe dados
    ↓
    Atualiza a interface
```

---

## 🔄 Hot Reload e Hot Restart

### Hot Reload (r)
- Recarrega mudanças rápidas
- **Mantém o estado** da aplicação
- Útil para mudanças de UI

**Quando usar:**
- Mudanças visuais
- Ajustes de layout
- Mudanças simples de lógica

### Hot Restart (R)
- Reinicia o app completamente
- **Perde o estado**
- Útil para mudanças estruturais

**Quando usar:**
- Mudanças em `main()`
- Adicionar novas dependências
- Mudanças em inicializações

---

## 📝 Convenções de Código

### Nomenclatura

- **Classes:** PascalCase - `DashboardScreen`
- **Variáveis/Funções:** camelCase - `connectToMqtt()`
- **Constantes:** camelCase com `const` - `const maxVoltage = 250.0`
- **Arquivos:** snake_case - `dashboard_screen.dart`

### Organização de Widgets

```dart
class MeuWidget extends StatelessWidget {
  // 1. Propriedades (final)
  final String titulo;
  
  // 2. Construtor
  const MeuWidget({super.key, required this.titulo});
  
  // 3. Método build
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

---

## 🧪 Pasta `test/`

Aqui ficam os testes do app.

**Exemplo:**
```dart
// test/widget_test.dart
void main() {
  test('Widget test', () {
    // Testes aqui
  });
}
```

Execute testes com:
```bash
flutter test
```

---

## 📚 Próximos Passos

Agora que você entende a estrutura:

1. **Explore o código:** Abra `lib/main.dart` e leia
2. **Faça pequenas mudanças:** Teste o hot reload
3. **Adicione funcionalidades:** Veja `docs/05-desenvolvimento.md`
4. **Organize o código:** Conforme o projeto cresce, separe em pastas

---

## 💡 Dicas

- **Mantenha `main.dart` limpo:** Mova código para outras pastas quando crescer
- **Use widgets reutilizáveis:** Crie componentes que podem ser usados várias vezes
- **Documente funções complexas:** Adicione comentários explicativos
- **Siga as convenções:** Facilita a leitura e manutenção

---

## 🔗 Recursos

- Documentação Flutter: https://docs.flutter.dev/
- Pub.dev (pacotes): https://pub.dev/
- Flutter Widget Catalog: https://docs.flutter.dev/ui/widgets


