# 📱 Guia de Instalação do Flutter - Do Zero ao Primeiro App

Este guia vai te ajudar a instalar tudo que você precisa para desenvolver aplicativos mobile com Flutter no Windows.

## 🎯 O que vamos instalar?

1. **Flutter SDK** - O framework de desenvolvimento
2. **Android Studio** - IDE e ferramentas Android
3. **Android SDK** - Kit de desenvolvimento Android
4. **Git** - Controle de versão (se ainda não tiver)

---

## 📥 Passo 1: Instalar o Flutter SDK

### 1.1 Baixar o Flutter

1. Acesse: https://docs.flutter.dev/get-started/install/windows
2. Baixe o arquivo ZIP do Flutter SDK (versão estável mais recente)
3. Extraia o arquivo para um local permanente, por exemplo:
   - `C:\src\flutter` (recomendado)
   - **NÃO** extraia em pastas que precisam de permissões especiais (como `C:\Program Files\`)

### 1.2 Adicionar Flutter às Variáveis de Ambiente

O Flutter precisa estar no PATH do sistema para funcionar de qualquer lugar.

**Windows 10/11:**
1. Pressione `Win + R`, digite `sysdm.cpl` e pressione Enter
2. Vá na aba **"Avançado"**
3. Clique em **"Variáveis de Ambiente"**
4. Em **"Variáveis do sistema"**, encontre a variável `Path`
5. Clique em **"Editar"**
6. Clique em **"Novo"**
7. Adicione o caminho completo do Flutter, por exemplo: `C:\src\flutter\bin`
8. Clique em **"OK"** em todas as janelas

**Verificar instalação:**
```bash
flutter --version
```

Se aparecer a versão do Flutter, está funcionando! ✅

---

## 📱 Passo 2: Instalar o Android Studio

### 2.1 Download e Instalação

1. Acesse: https://developer.android.com/studio
2. Baixe o Android Studio para Windows
3. Execute o instalador e siga as instruções
4. Durante a instalação, certifique-se de marcar:
   - ✅ Android SDK
   - ✅ Android SDK Platform
   - ✅ Android Virtual Device (AVD)

### 2.2 Configuração Inicial do Android Studio

1. Abra o Android Studio pela primeira vez
2. Siga o assistente de configuração inicial
3. Ele vai baixar automaticamente:
   - Android SDK
   - Android SDK Platform-Tools
   - Android Emulator

**Importante:** Anote onde o Android SDK foi instalado (geralmente `C:\Users\SeuUsuario\AppData\Local\Android\Sdk`)

---

## 🔧 Passo 3: Configurar Variáveis de Ambiente do Android

### 3.1 Adicionar ANDROID_HOME

1. Abra as **Variáveis de Ambiente** (mesmo processo do Passo 1.2)
2. Em **"Variáveis do sistema"**, clique em **"Novo"**
3. Nome da variável: `ANDROID_HOME`
4. Valor da variável: Caminho do Android SDK (ex: `C:\Users\SeuUsuario\AppData\Local\Android\Sdk`)
5. Clique em **"OK"**

### 3.2 Adicionar Android ao PATH

1. Edite a variável `Path` (mesmo processo do Passo 1.2)
2. Adicione estas duas entradas:
   - `%ANDROID_HOME%\platform-tools`
   - `%ANDROID_HOME%\tools`

**Verificar instalação:**
```bash
adb version
```

Se aparecer a versão do ADB, está funcionando! ✅

---

## ✅ Passo 4: Verificar Instalação com Flutter Doctor

O Flutter tem uma ferramenta que verifica se tudo está configurado corretamente:

```bash
flutter doctor
```

Este comando vai mostrar o que está OK ✅ e o que precisa ser corrigido ❌.

### O que você deve ver (idealmente):

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio
[✓] VS Code (opcional, mas útil)
[✓] Connected device
[✓] Network resources
```

### Problemas comuns e soluções:

**❌ Android licenses not accepted:**
```bash
flutter doctor --android-licenses
```
Aceite todas as licenças digitando `y` quando solicitado.

**❌ Android SDK not found:**
- Verifique se o `ANDROID_HOME` está configurado corretamente
- No Android Studio: File → Settings → Appearance & Behavior → System Settings → Android SDK
- Copie o caminho do "Android SDK Location"

**❌ No devices found:**
- Você precisa criar um emulador Android ou conectar um dispositivo físico
- Veja o guia de dispositivos em `docs/03-dispositivos-emuladores.md`

---

## 🎨 Passo 5: Instalar Extensões Úteis (Opcional mas Recomendado)

### VS Code (Editor de Código Leve)

1. Instale o VS Code: https://code.visualstudio.com/
2. Abra o VS Code
3. Vá em Extensions (Ctrl+Shift+X)
4. Instale:
   - **Flutter** (por Dart Code)
   - **Dart** (por Dart Code)

### Android Studio Plugins

1. Abra o Android Studio
2. File → Settings → Plugins
3. Procure e instale:
   - **Flutter** (já vem com Dart)

---

## 🚀 Passo 6: Testar a Instalação

Vamos criar um app de teste para verificar se tudo funciona:

```bash
# Navegar até a pasta do projeto
cd "C:\Users\mateus\OneDrive - Instituto Presbiteriano Mackenzie\iot\iot-ev-charger-monitor\smart-charger\mobile_app"

# Verificar se o projeto está OK
flutter pub get

# Verificar dispositivos disponíveis
flutter devices

# Executar o app (substitua 'device_name' pelo nome do seu dispositivo)
flutter run
```

---

## 📚 Próximos Passos

Agora que você tem tudo instalado, consulte:

- `docs/02-comandos-flutter.md` - Comandos úteis do Flutter
- `docs/03-dispositivos-emuladores.md` - Como configurar emuladores
- `docs/04-estrutura-projeto.md` - Entendendo a estrutura do projeto
- `docs/05-desenvolvimento.md` - Guia de desenvolvimento

---

## ❓ Problemas?

### Flutter não é reconhecido como comando
- Verifique se o Flutter está no PATH
- Feche e reabra o terminal
- Reinicie o computador se necessário

### Android Studio não encontra o SDK
- Verifique o caminho em: File → Settings → Android SDK
- Certifique-se que `ANDROID_HOME` aponta para o mesmo caminho

### Erro de permissões
- Execute o terminal como Administrador
- Verifique se o Flutter não está em pasta protegida

---

## 📝 Notas Importantes

- **Não mova** a pasta do Flutter após instalar (pode quebrar o PATH)
- **Mantenha** o Flutter atualizado: `flutter upgrade`
- **Sempre** execute `flutter pub get` após clonar um projeto
- O primeiro `flutter run` pode demorar (está compilando tudo)


