# 🛠️ Comandos Úteis do Flutter

Este guia lista os comandos mais importantes do Flutter que você vai usar durante o desenvolvimento.

---

## 📋 Comandos de Verificação e Diagnóstico

### Verificar instalação e status
```bash
flutter doctor
```
Mostra o status da instalação do Flutter e dependências.

```bash
flutter doctor -v
```
Versão detalhada com mais informações.

### Verificar versão do Flutter
```bash
flutter --version
```
Mostra a versão do Flutter, Dart e outras informações.

### Atualizar o Flutter
```bash
flutter upgrade
```
Atualiza o Flutter para a versão mais recente.

---

## 📦 Comandos de Gerenciamento de Dependências

### Instalar dependências do projeto
```bash
flutter pub get
```
Baixa e instala todas as dependências listadas no `pubspec.yaml`.

**Quando usar:**
- Após clonar um projeto
- Após adicionar uma nova dependência no `pubspec.yaml`
- Quando alguém te pedir para "rodar pub get"

### Atualizar dependências
```bash
flutter pub upgrade
```
Atualiza todas as dependências para as versões mais recentes compatíveis.

### Verificar dependências desatualizadas
```bash
flutter pub outdated
```
Mostra quais dependências têm versões mais recentes disponíveis.

### Limpar cache de dependências
```bash
flutter pub cache clean
```
Remove o cache de pacotes baixados (útil em caso de problemas).

---

## 📱 Comandos de Dispositivos e Emuladores

### Listar dispositivos disponíveis
```bash
flutter devices
```
Mostra todos os dispositivos/emuladores conectados e prontos para uso.

**Exemplo de saída:**
```
2 connected devices:

sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 13 (API 33)
Chrome (web)                • chrome        • web-javascript • Google Chrome 120.0.6099.109
```

### Executar o app em um dispositivo específico
```bash
flutter run -d <device_id>
```
Exemplo: `flutter run -d emulator-5554`

### Executar em modo release (otimizado)
```bash
flutter run --release
```
Compila e executa em modo release (mais rápido, sem hot reload).

---

## 🏃 Comandos de Execução e Desenvolvimento

### Executar o app
```bash
flutter run
```
Compila e executa o app no dispositivo selecionado.

**Durante a execução, você pode:**
- `r` - Hot reload (recarrega mudanças rápidas)
- `R` - Hot restart (reinicia o app completamente)
- `q` - Sair/parar o app
- `h` - Ver ajuda com todos os comandos

### Executar em modo debug
```bash
flutter run --debug
```
Executa com informações de debug (padrão).

### Executar em modo profile
```bash
flutter run --profile
```
Executa em modo profile (para análise de performance).

---

## 🧹 Comandos de Limpeza

### Limpar build
```bash
flutter clean
```
Remove arquivos de build gerados. Use quando:
- O app não compila e você não sabe por quê
- Mudou configurações importantes
- Após atualizar o Flutter

**Depois de limpar, sempre execute:**
```bash
flutter pub get
```

### Limpar e reconstruir
```bash
flutter clean && flutter pub get
```
Limpa e reinstala dependências (comando combinado útil).

---

## 📦 Comandos de Build (Gerar APK/IPA)

### Gerar APK para Android (debug)
```bash
flutter build apk --debug
```
Gera um APK de debug (maior, com informações de debug).

### Gerar APK para Android (release)
```bash
flutter build apk --release
```
Gera um APK otimizado para produção.

**O APK será gerado em:**
`build/app/outputs/flutter-apk/app-release.apk`

### Gerar APK dividido por arquitetura
```bash
flutter build apk --split-per-abi
```
Gera APKs separados para cada arquitetura (arm64, armeabi-v7a, x86_64).
Útil para reduzir o tamanho do APK.

### Gerar App Bundle (para Google Play)
```bash
flutter build appbundle --release
```
Gera um AAB (Android App Bundle) para publicação na Google Play Store.

---

## 🔍 Comandos de Análise e Qualidade

### Analisar código
```bash
flutter analyze
```
Verifica o código em busca de problemas, erros e avisos.

### Formatar código
```bash
flutter format .
```
Formata todo o código Dart do projeto seguindo as convenções.

### Formatar e verificar
```bash
flutter format . && flutter analyze
```
Formata e analisa o código (comando combinado útil).

---

## 🧪 Comandos de Testes

### Executar testes
```bash
flutter test
```
Executa todos os testes unitários do projeto.

### Executar testes com cobertura
```bash
flutter test --coverage
```
Executa testes e gera relatório de cobertura de código.

---

## 📊 Comandos de Informações

### Informações sobre o projeto
```bash
flutter pub deps
```
Mostra a árvore de dependências do projeto.

### Informações sobre o dispositivo
```bash
flutter devices -v
```
Mostra informações detalhadas sobre os dispositivos conectados.

---

## 🎯 Comandos Específicos do Projeto

### Para este projeto (Smart Charger)

**Navegar até o projeto:**
```bash
cd "C:\Users\mateus\OneDrive - Instituto Presbiteriano Mackenzie\iot\iot-ev-charger-monitor\smart-charger\mobile_app"
```

**Instalar dependências:**
```bash
flutter pub get
```

**Executar o app:**
```bash
flutter run
```

**Verificar se há problemas:**
```bash
flutter doctor
flutter analyze
```

---

## 💡 Dicas e Atalhos

### Atalhos durante `flutter run`:
- **Hot Reload (r)**: Recarrega mudanças rápidas (mantém estado)
- **Hot Restart (R)**: Reinicia completamente o app
- **Quit (q)**: Para a execução
- **Help (h)**: Mostra todos os comandos disponíveis

### Workflow típico de desenvolvimento:
1. `flutter pub get` - Instalar/atualizar dependências
2. `flutter devices` - Verificar dispositivos
3. `flutter run` - Executar o app
4. Fazer alterações no código
5. Pressionar `r` para hot reload
6. Repetir passos 4-5

### Quando algo não funciona:
1. `flutter clean` - Limpar build
2. `flutter pub get` - Reinstalar dependências
3. `flutter doctor` - Verificar se há problemas
4. `flutter run` - Tentar novamente

---

## 📚 Recursos Adicionais

- Documentação oficial: https://docs.flutter.dev/
- Comandos CLI: https://docs.flutter.dev/reference/flutter-cli
- Troubleshooting: https://docs.flutter.dev/get-started/install/windows#troubleshooting




