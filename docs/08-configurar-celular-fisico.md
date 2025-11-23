# 📱 Como Configurar seu Celular Android para Testar o App

Este guia te ajuda a conectar seu celular Android físico ao computador para testar o app.

---

## ✅ Pré-requisitos

- Celular Android (qualquer versão)
- Cabo USB (preferencialmente o original)
- Computador com Flutter instalado
- Drivers USB instalados (geralmente automático)

---

## 🔧 Passo 1: Habilitar Modo Desenvolvedor

### 1.1 Encontrar o Número da Versão

1. **Abra as Configurações** do seu celular
2. Vá em **"Sobre o telefone"** ou **"Sobre o dispositivo"**
3. Procure por **"Número da versão"** ou **"Versão do Android"**
4. **Toque 7 vezes** neste número

**Você verá uma mensagem:** "Agora você é um desenvolvedor!" ✅

---

## 🔓 Passo 2: Habilitar Depuração USB

### 2.1 Ativar Opções do Desenvolvedor

1. **Volte para Configurações**
2. Procure por **"Opções do desenvolvedor"** ou **"Opções de desenvolvedor"**
   - Pode estar em: Sistema → Opções do desenvolvedor
   - Ou: Configurações avançadas → Opções do desenvolvedor

### 2.2 Ativar Depuração USB

1. **Abra "Opções do desenvolvedor"**
2. **Ative "Depuração USB"** (toggle)
3. (Opcional) Ative **"Instalar via USB"** se disponível
4. (Opcional) Ative **"Permanecer ativo"** (mantém tela ligada quando conectado)

**Atenção:** Pode aparecer um aviso de segurança. Isso é normal!

---

## 🔌 Passo 3: Conectar o Celular

### 3.1 Conectar via USB

1. **Conecte o cabo USB** ao celular e ao computador
2. **No celular:** Aparecerá um popup perguntando se você confia neste computador
3. **Marque "Sempre permitir deste computador"** ✅
4. **Toque em "Permitir"** ou "OK"

### 3.2 Verificar Conexão

Abra o terminal e execute:

```bash
adb devices
```

**Você deve ver algo como:**
```
List of devices attached
ABC123XYZ    device
```

**Se aparecer "unauthorized":**
- Desconecte e reconecte o cabo
- Aceite a permissão no celular novamente
- Execute `adb devices` novamente

**Se aparecer "offline":**
- Execute: `adb kill-server`
- Execute: `adb start-server`
- Execute: `adb devices` novamente

---

## 📱 Passo 4: Verificar no Flutter

Execute:

```bash
flutter devices
```

**Você deve ver seu celular listado:**
```
2 connected devices:

sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64
Samsung Galaxy S21 (mobile) • ABC123XYZ    • android-arm64  • Android 13
```

---

## 🚀 Passo 5: Executar o App

### 5.1 Executar no Celular

```bash
flutter run
```

O Flutter vai perguntar qual dispositivo usar. Escolha o número do seu celular.

**Ou execute diretamente no seu dispositivo:**

```bash
flutter run -d ABC123XYZ
```

(Substitua `ABC123XYZ` pelo ID do seu dispositivo)

---

## ❌ Problemas Comuns

### Problema: "No devices found"

**Soluções:**

1. **Verificar se o celular está conectado:**
   ```bash
   adb devices
   ```

2. **Reiniciar servidor ADB:**
   ```bash
   adb kill-server
   adb start-server
   adb devices
   ```

3. **Verificar se a depuração USB está ativada:**
   - Configurações → Opções do desenvolvedor → Depuração USB

4. **Tentar outro cabo USB:**
   - Alguns cabos são apenas para carregar, não para dados

5. **Instalar drivers USB:**
   - Para Samsung: Samsung USB Driver
   - Para Xiaomi: Mi USB Driver
   - Para outros: Universal ADB Driver

---

### Problema: "unauthorized"

**Solução:**

1. **Desconecte o cabo**
2. **No celular:** Vá em Configurações → Opções do desenvolvedor
3. **Desative e reative "Depuração USB"**
4. **Reconecte o cabo**
5. **Aceite a permissão** quando aparecer o popup
6. **Marque "Sempre permitir deste computador"**

---

### Problema: Celular não aparece no `flutter devices`

**Soluções:**

1. **Verificar com ADB:**
   ```bash
   adb devices
   ```
   Se aparecer aqui, o problema é do Flutter.

2. **Verificar se o Flutter reconhece Android:**
   ```bash
   flutter doctor
   ```
   Deve mostrar Android toolchain como ✅

3. **Reiniciar o computador** (às vezes ajuda)

---

### Problema: "Installing APK failed"

**Soluções:**

1. **Desativar "Instalar via USB" e reativar:**
   - Configurações → Opções do desenvolvedor → Instalar via USB

2. **Verificar espaço no celular:**
   - O app precisa de espaço para instalar

3. **Desinstalar versão antiga:**
   - Se já instalou antes, desinstale manualmente

---

## 🔐 Segurança

### É Seguro?

- **Sim!** A depuração USB é segura
- Você está apenas testando seu próprio app
- Pode desativar depois se quiser

### Como Desativar Depois

1. **Configurações → Opções do desenvolvedor**
2. **Desative "Depuração USB"**
3. (Opcional) Desative "Opções do desenvolvedor" completamente

---

## 💡 Dicas

### Manter o Celular Conectado

- Deixe o cabo conectado durante o desenvolvimento
- Facilita testar mudanças rapidamente
- Hot reload funciona normalmente

### Usar WiFi (Avançado)

Você pode conectar via WiFi sem cabo:

```bash
# Conectar via USB primeiro
adb devices

# Conectar via WiFi (celular e PC na mesma rede)
adb tcpip 5555
adb connect IP_DO_CELULAR:5555

# Verificar
adb devices
```

**Para descobrir o IP do celular:**
- Configurações → Sobre o telefone → Status → Endereço IP

---

## 📋 Checklist Rápido

- [ ] Modo desenvolvedor ativado (7 toques no número da versão)
- [ ] Depuração USB ativada
- [ ] Celular conectado via USB
- [ ] Permissão de depuração aceita no celular
- [ ] `adb devices` mostra o dispositivo
- [ ] `flutter devices` mostra o dispositivo
- [ ] App executando no celular

---

## 🎯 Próximos Passos

Agora que seu celular está configurado:

1. **Execute o app:**
   ```bash
   flutter run
   ```

2. **Teste o app:**
   - Veja se conecta ao MQTT
   - Veja se recebe dados
   - Teste hot reload (pressione `r` no terminal)

3. **Desenvolva:**
   - Faça mudanças no código
   - Use hot reload para ver mudanças instantaneamente

---

## 📚 Referências

- Documentação Flutter: https://docs.flutter.dev/get-started/install/windows#android-setup
- Guia ADB: https://developer.android.com/studio/command-line/adb

---

**Agora você pode testar o app no seu celular! 🚀**

