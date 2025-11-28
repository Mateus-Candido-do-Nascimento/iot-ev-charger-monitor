# 📱 Como Usar o Emulador Android no Android Studio

Este guia te ensina a criar e usar um emulador Android no Android Studio para testar o app Flutter.

---

## ✅ Pré-requisitos

- Android Studio instalado
- Flutter instalado
- Pelo menos 4GB de RAM disponível (recomendado 8GB)

---

## 🎯 Passo 1: Abrir o Android Studio

1. **Abra o Android Studio**
2. Se for a primeira vez, siga o assistente de configuração inicial
3. Aguarde o Android Studio baixar componentes necessários (pode demorar)

---

## 📱 Passo 2: Abrir o Device Manager (Gerenciador de Dispositivos)

### Opção 1: Pelo Menu

1. **Tools** → **Device Manager**
   - Ou: **More Actions** → **Virtual Device Manager**

### Opção 2: Pelo Ícone

1. Procure o ícone de **dispositivo/telefone** na barra de ferramentas superior
2. Clique nele

### Opção 3: Pelo Menu de Configuração

1. **Configure** → **AVD Manager**

---

## 🆕 Passo 3: Criar um Novo Dispositivo Virtual (AVD)

### 3.1 Clicar em "Create Device"

1. No **Device Manager**, clique no botão **"Create Device"** ou **"+"**

### 3.2 Escolher um Dispositivo

**Recomendações:**
- **Pixel 5** - Boa performance, tela média
- **Pixel 6** - Mais moderno
- **Pixel 7** - Mais recente

**Evite:**
- Dispositivos muito antigos (podem ser lentos)
- Tablets (a menos que você queira testar em tablet)

**Clique em "Next"**

---

## 📦 Passo 4: Escolher a Imagem do Sistema (System Image)

### 4.1 Escolher uma Versão do Android

**Recomendações:**
- **API 33 (Android 13)** - Estável e moderna
- **API 34 (Android 14)** - Mais recente
- **API 31 (Android 12)** - Mais leve, se seu PC for fraco

### 4.2 Baixar a Imagem (se necessário)

1. Se a imagem não estiver baixada, você verá um botão **"Download"**
2. Clique em **"Download"**
3. Aguarde o download (pode demorar vários minutos)
4. Aceite os termos de licença quando solicitado

### 4.3 Selecionar e Avançar

1. Selecione a imagem desejada (com ✓ ao lado)
2. Clique em **"Next"**

---

## ⚙️ Passo 5: Configurar o AVD (Android Virtual Device)

### 5.1 Nome do AVD

1. **AVD Name:** Dê um nome descritivo
   - Exemplo: `Pixel_5_API_33`
   - Exemplo: `Android_13_Emulator`

### 5.2 Configurações Avançadas (Show Advanced Settings)

**Clique em "Show Advanced Settings"** para ver mais opções:

#### Memória RAM
- **RAM:** Pelo menos **2048 MB** (2GB)
- **Recomendado:** 4096 MB (4GB) ou mais
- **Máximo:** Não exagere (deixe RAM para o sistema)

#### Gráficos
- **Graphics:** Escolha **"Hardware - GLES 2.0"**
  - Mais rápido e melhor performance
  - Se não funcionar, tente "Automatic"

#### CPU
- **Multi-core CPU:** 2 ou 4 cores
  - Mais cores = mais rápido, mas usa mais recursos

#### Outras Configurações
- **Internal Storage:** 2048 MB (padrão está OK)
- **SD Card:** Opcional (pode deixar vazio)

### 5.3 Finalizar

1. Revise as configurações
2. Clique em **"Finish"**

---

## ▶️ Passo 6: Iniciar o Emulador

### 6.1 Iniciar

1. No **Device Manager**, você verá o emulador que criou
2. Clique no botão **▶️ (Play)** ao lado do emulador
3. Aguarde o emulador iniciar (pode demorar 1-2 minutos na primeira vez)

**Dica:** A primeira inicialização é sempre mais lenta!

### 6.2 Aguardar Inicialização

Você verá:
- Tela preta inicial
- Logo do Android
- Tela inicial do Android
- **Pronto quando aparecer a tela inicial do Android!**

---

## ✅ Passo 7: Verificar se o Flutter Reconhece

### 7.1 Verificar Dispositivos

Abra o terminal e execute:

```bash
flutter devices
```

**Você deve ver algo como:**
```
2 connected devices:

sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 13 (API 33)
Chrome (web)                • chrome       • web-javascript • Google Chrome
```

**O emulador aparece com o nome "sdk gphone..." ou similar!**

---

## 🚀 Passo 8: Executar o App

### 8.1 Executar no Emulador

```bash
cd smart-charger/mobile_app
flutter run
```

O Flutter vai:
1. Detectar o emulador automaticamente
2. Compilar o app
3. Instalar no emulador
4. Executar o app

**Se houver múltiplos dispositivos, o Flutter vai perguntar qual usar.**

### 8.2 Executar em Dispositivo Específico

Se você tiver múltiplos dispositivos:

```bash
flutter run -d emulator-5554
```

(Substitua `emulator-5554` pelo ID do seu emulador)

---

## 🎮 Usando o Emulador

### Controles Básicos

- **Voltar:** Botão voltar na barra lateral
- **Home:** Botão home na barra lateral
- **Menu:** Botão menu (3 linhas) na barra lateral
- **Rotacionar:** Ctrl + F11 (Windows) ou Cmd + F11 (Mac)
- **Zoom:** Ctrl + Mouse Wheel

### Fechar o Emulador

- Clique no **X** na janela do emulador
- Ou: **Device Manager** → Clique em **⏹️ (Stop)**

**Dica:** Deixe o emulador aberto durante o desenvolvimento - não precisa fechar toda vez!

---

## ⚡ Melhorar Performance do Emulador

### 1. Habilitar Aceleração de Hardware

**Windows:**
- Instale **Intel HAXM** ou **Hyper-V**
- Android Studio geralmente instala automaticamente

**Verificar:**
```bash
flutter doctor
```

Deve mostrar que a aceleração está ativada.

### 2. Configurações do Emulador

**No emulador em execução:**

1. Clique nos **3 pontos** (⋯) na barra lateral
2. **Settings** → **Advanced**
3. Ative:
   - **OpenGL ES renderer:** Desktop native OpenGL
   - **GPU acceleration:** On

### 3. Configurações do Android no Emulador

**No emulador:**

1. **Settings** → **System** → **Advanced** → **Developer options**
2. Ative:
   - **Force GPU rendering**
   - (Opcional) Desative animações para mais velocidade

### 4. Fechar Programas Desnecessários

- Feche programas pesados (navegadores com muitas abas, etc.)
- Isso libera RAM e CPU para o emulador

---

## 🐛 Problemas Comuns

### Problema: Emulador Muito Lento

**Soluções:**

1. **Reduzir RAM do emulador:**
   - Device Manager → Editar (lápis) → Reduzir RAM para 2GB

2. **Usar API mais antiga:**
   - API 31 (Android 12) é mais leve que API 33

3. **Fechar outros programas:**
   - Libere RAM e CPU

4. **Usar dispositivo físico:**
   - Às vezes é mais rápido que emulador

### Problema: Emulador Não Inicia

**Soluções:**

1. **Verificar se HAXM está instalado:**
   ```bash
   flutter doctor
   ```

2. **Verificar se Virtualization está ativada no BIOS:**
   - Reinicie o PC
   - Entre no BIOS (geralmente F2, F10, ou Del)
   - Ative "Virtualization Technology" ou "VT-x"

3. **Tentar outro tipo de gráficos:**
   - Device Manager → Editar → Graphics: "Automatic" ou "Software"

### Problema: Emulador Não Aparece no `flutter devices`

**Soluções:**

1. **Certifique-se que o emulador está rodando:**
   - Você deve ver a janela do emulador aberta

2. **Reiniciar o emulador:**
   - Feche e abra novamente

3. **Verificar com ADB:**
   ```bash
   adb devices
   ```
   Deve mostrar o emulador

4. **Reiniciar ADB:**
   ```bash
   adb kill-server
   adb start-server
   adb devices
   ```

### Problema: "HAXM is not installed"

**Solução:**

1. **Instalar HAXM:**
   - Android Studio → Tools → SDK Manager
   - Aba "SDK Tools"
   - Marque "Intel x86 Emulator Accelerator (HAXM installer)"
   - Clique "Apply"

2. **Ou baixar manualmente:**
   - https://github.com/intel/haxm/releases

---

## 💡 Dicas e Boas Práticas

### Manter o Emulador Aberto

- **Não feche o emulador** toda vez que terminar de testar
- Deixe aberto durante o desenvolvimento
- Facilita testar mudanças rapidamente

### Criar Múltiplos Emuladores

Crie emuladores com diferentes:
- **Tamanhos de tela** (testar responsividade)
- **Versões do Android** (testar compatibilidade)
- **Configurações** (testar em dispositivos mais fracos)

### Snapshots (Instantâneas)

**Criar snapshot:**
- Device Manager → Emulador → Menu (3 pontos) → "Snapshot"
- Salva o estado atual do emulador
- Próxima vez, inicia instantaneamente!

**Usar snapshot:**
- Ao iniciar o emulador, escolha "Quick Boot" (usa snapshot)

---

## 📋 Checklist Rápido

- [ ] Android Studio instalado
- [ ] Device Manager aberto
- [ ] Emulador criado
- [ ] Imagem do sistema baixada
- [ ] Emulador iniciado (janela aberta)
- [ ] `flutter devices` mostra o emulador
- [ ] App executando no emulador

---

## 🎯 Próximos Passos

Agora que o emulador está funcionando:

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

- Documentação Android Studio: https://developer.android.com/studio/run/emulator
- Guia Flutter: https://docs.flutter.dev/get-started/install/windows#set-up-an-android-emulator

---

## 🆚 Emulador vs Dispositivo Físico

### Emulador - Vantagens
- ✅ Não precisa de cabo
- ✅ Fácil de testar em diferentes versões do Android
- ✅ Pode criar múltiplos dispositivos
- ✅ Snapshots para iniciar rápido

### Emulador - Desvantagens
- ❌ Pode ser lento (depende do PC)
- ❌ Usa bastante RAM
- ❌ Performance pode ser diferente do dispositivo real

### Dispositivo Físico - Vantagens
- ✅ Performance real
- ✅ Testa comportamento real do usuário
- ✅ Geralmente mais rápido que emulador

### Dispositivo Físico - Desvantagens
- ❌ Precisa de cabo USB
- ❌ Precisa configurar depuração USB
- ❌ Só testa em um dispositivo por vez

**Recomendação:** Use emulador para desenvolvimento diário, dispositivo físico para testes finais.

---

**Agora você pode testar o app no emulador! 🚀**



