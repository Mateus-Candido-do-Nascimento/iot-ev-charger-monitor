# 📚 Documentação do Projeto - Smart Charger Mobile App

Bem-vindo à documentação do projeto Smart Charger! Esta pasta contém todos os guias e documentação útil para desenvolver o aplicativo mobile.

---

## 📖 Índice da Documentação

### 1. [Instalação do Flutter](01-instalacao-flutter.md)
Guia completo para instalar o Flutter, Android Studio, SDK e configurar o ambiente de desenvolvimento do zero.

**Quando usar:** Se você ainda não tem o Flutter instalado ou está configurando um novo computador.

---

### 2. [Comandos Úteis do Flutter](02-comandos-flutter.md)
Lista de comandos importantes do Flutter que você vai usar durante o desenvolvimento.

**Quando usar:** Referência rápida durante o desenvolvimento. Consulte sempre que precisar de um comando específico.

---

### 3. [Dispositivos e Emuladores](03-dispositivos-emuladores.md)
Como configurar e usar emuladores Android e dispositivos físicos para testar o app.

**Quando usar:** Quando precisar configurar um novo dispositivo ou emulador, ou quando o dispositivo não aparecer.

---

### 4. [Estrutura do Projeto](04-estrutura-projeto.md)
Explicação da estrutura de pastas e arquivos do projeto Flutter.

**Quando usar:** Para entender como o projeto está organizado e onde colocar novos arquivos.

---

### 5. [Guia de Desenvolvimento](05-desenvolvimento.md)
Guia completo sobre como desenvolver e melhorar o aplicativo, incluindo melhores práticas e exemplos.

**Quando usar:** Durante o desenvolvimento, para entender como implementar novas funcionalidades.

---

### 6. [Troubleshooting](06-troubleshooting.md)
Solução de problemas comuns durante o desenvolvimento.

**Quando usar:** Quando algo não está funcionando e você precisa resolver rapidamente.

---

### ⚡ [Solução Rápida: pub get Travando](SOLUCAO-RAPIDA-pub-get-travando.md)
Guia específico para resolver o problema de `flutter pub get` travando.

**Quando usar:** Se o comando `flutter pub get` não está funcionando.

---

### 7. [Explicação do main.dart](07-explicacao-main-dart.md)
Explicação passo a passo de como o código funciona, especialmente a conexão MQTT.

**Quando usar:** Para entender como o app funciona internamente.

---

### 8. [Configurar Celular Físico](08-configurar-celular-fisico.md)
Guia completo para conectar seu celular Android e testar o app.

**Quando usar:** Quando quiser testar o app no seu celular físico.

---

### 9. [Emulador Android Studio](09-emulador-android-studio.md)
Guia completo para criar e usar emulador Android no Android Studio.

**Quando usar:** Para testar o app sem precisar de um celular físico (RECOMENDADO para desenvolvimento).

---

### 10. [Erro: Emulador Não Inicia](10-erro-emulador-startup.md)
Solução completa para erros ao iniciar o emulador.

**Quando usar:** Se o emulador não está iniciando ou dá erro.

---

### ⚡ [Solução Rápida: Erro Emulador](SOLUCAO-RAPIDA-emulador-erro.md)
Solução rápida para o erro -1073741701 do emulador.

**Quando usar:** Se o emulador não inicia e você precisa resolver rápido.

---

### 11. [Passo a Passo: Device Manager](11-passo-a-passo-device-manager.md)
Guia visual passo a passo para configurar o emulador no Android Studio.

**Quando usar:** Para seguir um guia visual detalhado de configuração.

---

### 12. [Encontrar Device Manager](12-encontrar-device-manager.md)
Como encontrar o Device Manager no Android Studio se não aparecer no menu.

**Quando usar:** Se você não encontra o Device Manager no Android Studio.

---

### 13. [Emulador pela Linha de Comando](13-emulador-linha-comando.md)
Como gerenciar emuladores usando apenas a linha de comando.

**Quando usar:** Se preferir usar terminal em vez da interface gráfica.

---

### 14. [Gerar APK e Instalar](14-gerar-apk-instalar.md)
Como gerar um arquivo APK e instalar diretamente no celular (MAIS SIMPLES!).

**Quando usar:** Quando quiser instalar o app no celular sem precisar de emulador ou depuração USB.

---

## 🚀 Início Rápido

### Se você está começando do zero:

1. **Instale o Flutter:**
   - Siga o guia [01-instalacao-flutter.md](01-instalacao-flutter.md)
   - Execute `flutter doctor` para verificar

2. **Configure um dispositivo:**
   - Siga o guia [03-dispositivos-emuladores.md](03-dispositivos-emuladores.md)
   - Crie um emulador ou conecte um dispositivo físico

3. **Execute o projeto:**
   ```bash
   cd smart-charger/mobile_app
   flutter pub get
   flutter run
   ```

4. **Comece a desenvolver:**
   - Leia [04-estrutura-projeto.md](04-estrutura-projeto.md) para entender a estrutura
   - Consulte [05-desenvolvimento.md](05-desenvolvimento.md) para implementar funcionalidades

---

## 📝 Sobre Esta Documentação

Esta documentação foi criada para ser:
- **Didática:** Explica o "porquê", não apenas o "como"
- **Prática:** Foca em comandos e exemplos úteis
- **Progressiva:** Do básico ao avançado
- **Referência:** Fácil de consultar quando necessário

---

## 🔄 Atualizações

Esta documentação será atualizada conforme o projeto evolui. Sempre consulte a versão mais recente.

---

## ❓ Precisa de Ajuda?

1. **Consulte a documentação relevante** acima
2. **Verifique os erros** com `flutter doctor` e `flutter analyze`
3. **Consulte a documentação oficial:** https://docs.flutter.dev/
4. **Pergunte na comunidade:** Stack Overflow, Discord Flutter

---

## 📚 Recursos Adicionais

- **Documentação Oficial Flutter:** https://docs.flutter.dev/
- **Pub.dev (Pacotes):** https://pub.dev/
- **Flutter Cookbook:** https://docs.flutter.dev/cookbook
- **Flutter Widget Catalog:** https://docs.flutter.dev/ui/widgets

---

**Boa sorte no desenvolvimento! 🚀**


