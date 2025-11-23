# 📱 Dispositivos e Emuladores - Como Testar seu App

Este guia explica como configurar e usar dispositivos físicos e emuladores para testar seu app Flutter.

---

## 🎯 Opções para Testar

Você tem 3 opções principais:

1. **Emulador Android** (recomendado para começar)
2. **Dispositivo Android físico** (melhor para testes reais)
3. **Navegador Web** (rápido, mas limitado)

---

## 📱 Opção 1: Emulador Android (Recomendado)

### Criar um Emulador no Android Studio

1. **Abrir o Android Studio**
2. **Abrir o AVD Manager:**
   - Clique no ícone de dispositivo no canto superior direito
   - Ou: Tools → Device Manager
   - Ou: Configure → AVD Manager

3. **Criar um novo dispositivo virtual:**
   - Clique em **"Create Device"**
   - Escolha um dispositivo (recomendado: **Pixel 5** ou **Pixel 6**)
   - Clique em **"Next"**

4. **Escolher a imagem do sistema:**
   - Recomendado: **API 33 (Android 13)** ou **API 34 (Android 14)**
   - Se não tiver baixado, clique em **"Download"** ao lado da versão
   - Clique em **"Next"**

5. **Configurar o AVD:**
   - Nome: dê um nome descritivo (ex: "Pixel_5_API_33")
   - Verifique as configurações:
     - RAM: pelo menos 2GB (recomendado 4GB)
     - Graphics: **Hardware - GLES 2.0** (mais rápido)
   - Clique em **"Finish"**

6. **Iniciar o emulador:**
   - Clique no botão ▶️ (Play) ao lado do emulador criado
   - Aguarde o emulador iniciar (pode demorar na primeira vez)

### Verificar se o emulador está disponível

Abra o terminal e execute:
```bash
flutter devices
```

Você deve ver algo como:
```
sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64 • Android 13 (API 33)
```

### Executar o app no emulador

```bash
flutter run
```

O Flutter vai detectar automaticamente o emulador e instalar o app.

---

## 📲 Opção 2: Dispositivo Android Físico

### Habilitar Modo Desenvolvedor

1. **No seu celular Android:**
   - Vá em **Configurações** → **Sobre o telefone**
   - Encontre **"Número da versão"** ou **"Versão do Android"**
   - Toque **7 vezes** no número da versão
   - Você verá a mensagem "Agora você é um desenvolvedor!"

### Habilitar Depuração USB

1. **Volte para Configurações**
2. Procure por **"Opções do desenvolvedor"** ou **"Opções de desenvolvedor"**
3. Ative **"Depuração USB"**
4. (Opcional) Ative **"Instalar via USB"** se disponível

### Conectar o dispositivo

1. **Conecte o celular ao computador via USB**
2. **No celular:** Aceite a permissão de depuração USB (aparece um popup)
3. Marque **"Sempre permitir deste computador"** se quiser

### Verificar conexão

```bash
adb devices
```

Você deve ver algo como:
```
List of devices attached
ABC123XYZ    device
```

Se aparecer "unauthorized", aceite a permissão no celular novamente.

### Executar o app

```bash
flutter devices
flutter run
```

---

## 🌐 Opção 3: Navegador Web (Para testes rápidos)

### Habilitar suporte web no Flutter

```bash
flutter config --enable-web
```

### Executar no navegador

```bash
flutter run -d chrome
```

**Limitações:**
- Alguns recursos mobile não funcionam
- Performance pode ser diferente
- Útil apenas para testes de UI básicos

---

## 🔧 Comandos Úteis

### Listar dispositivos disponíveis
```bash
flutter devices
```

### Executar em dispositivo específico
```bash
flutter run -d <device_id>
```

Exemplo:
```bash
flutter run -d emulator-5554
flutter run -d chrome
```

### Verificar dispositivos via ADB
```bash
adb devices
```

### Reiniciar servidor ADB (se dispositivo não aparecer)
```bash
adb kill-server
adb start-server
```

### Instalar APK diretamente
```bash
adb install caminho/para/app.apk
```

---

## ⚙️ Configurações Recomendadas do Emulador

### Para melhor performance:

1. **No Android Studio → AVD Manager:**
   - Edite o emulador (ícone de lápis)
   - **Show Advanced Settings**
   - Aumente a **RAM** para 4GB ou mais (se seu PC permitir)
   - **Graphics:** Hardware - GLES 2.0
   - **Multi-core CPU:** 2 ou 4 cores

2. **No emulador em execução:**
   - Settings → System → Advanced → Developer options
   - Ative **"Force GPU rendering"**
   - Desative animações (opcional, para mais velocidade)

### Para testar diferentes tamanhos de tela:

Crie múltiplos emuladores com diferentes dispositivos:
- **Pixel 5** - Tela média (6")
- **Pixel 7 Pro** - Tela grande (6.7")
- **Pixel 3a** - Tela pequena (5.6")

---

## 🐛 Problemas Comuns

### Emulador não aparece no `flutter devices`

**Solução:**
1. Certifique-se que o emulador está rodando
2. Verifique com `adb devices`
3. Reinicie o emulador
4. Execute `flutter doctor` para verificar problemas

### Dispositivo físico não aparece

**Solução:**
1. Verifique se a depuração USB está ativada
2. Tente outro cabo USB
3. Verifique se os drivers USB estão instalados
4. Execute `adb kill-server && adb start-server`
5. Aceite a permissão de depuração no celular

### Emulador muito lento

**Solução:**
1. Aumente a RAM do emulador
2. Use Hardware Acceleration (HAXM no Windows)
3. Feche outros programas pesados
4. Considere usar um dispositivo físico

### Erro "No devices found"

**Solução:**
```bash
flutter doctor
```
Verifique se há problemas reportados e corrija.

---

## 💡 Dicas

- **Para desenvolvimento diário:** Use um emulador (mais rápido para iniciar)
- **Para testes finais:** Use dispositivo físico (comportamento real)
- **Mantenha o emulador aberto:** Não precisa fechar toda vez
- **Use múltiplos dispositivos:** Teste em diferentes tamanhos de tela
- **Hot Reload funciona em ambos:** Emulador e dispositivo físico

---

## 📚 Próximos Passos

Agora que você tem um dispositivo configurado, consulte:

- `docs/04-estrutura-projeto.md` - Entender a estrutura do código
- `docs/05-desenvolvimento.md` - Começar a desenvolver
- `docs/02-comandos-flutter.md` - Comandos úteis


