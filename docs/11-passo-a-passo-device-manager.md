# 📱 Passo a Passo: Configurar Emulador no Android Studio

Guia visual passo a passo para configurar o emulador no Android Studio.

---

## 🎯 Passo 1: Abrir o Device Manager

### Opção A: Pelo Menu Superior

1. No **Android Studio**, clique em **"Tools"** (no menu superior)
2. Clique em **"Device Manager"**

### Opção B: Pelo Ícone na Barra Lateral

1. Procure o **ícone de dispositivo/telefone** na barra lateral direita
2. Clique nele

### Opção C: Pelo Menu de Configuração

1. Clique em **"More Actions"** (3 pontos) no canto superior direito
2. Clique em **"Virtual Device Manager"**

---

## 🔧 Passo 2: Editar o Emulador Existente

### 2.1 Encontrar o Emulador

No **Device Manager**, você verá:
- Lista de emuladores criados
- O emulador `Medium_Phone_API_36.1` deve estar listado

### 2.2 Editar Configurações

1. **Clique no ícone de lápis** (✏️) ao lado do emulador `Medium_Phone_API_36.1`
   - Ou clique com botão direito → **"Edit"**

2. Uma janela de configuração vai abrir

---

## ⚙️ Passo 3: Mudar Graphics para Software

### 3.1 Mostrar Configurações Avançadas

1. Na janela de edição, procure por **"Show Advanced Settings"**
2. **Clique** para expandir

### 3.2 Configurar Graphics

1. Procure pela opção **"Graphics"**
2. Atualmente deve estar como **"Hardware - GLES 2.0"** ou **"Automatic"**
3. **Mude para:** **"Software - GLES 2.0"**
   - Isso resolve a maioria dos problemas de inicialização

### 3.3 Outras Configurações Recomendadas

Enquanto está editando, verifique:

- **RAM:** Pelo menos 2048 MB (2GB)
  - Se estiver muito alto (8GB+), reduza para 4GB
- **Multi-core CPU:** 2 ou 4 cores
  - Mais cores = mais rápido, mas usa mais recursos

### 3.4 Salvar

1. Clique em **"Finish"** ou **"OK"**
2. As configurações serão salvas

---

## 🆕 Passo 4: Criar Novo Emulador (Alternativa)

Se editar não funcionar, crie um novo emulador mais simples:

### 4.1 Criar Dispositivo

1. No **Device Manager**, clique em **"Create Device"** ou **"+"**

### 4.2 Escolher Dispositivo

1. Escolha um dispositivo mais simples:
   - **Pixel 3a** (recomendado - mais leve)
   - **Pixel 4** (alternativa)
   - **Evite:** Dispositivos muito grandes ou tablets

2. Clique em **"Next"**

### 4.3 Escolher Imagem do Sistema

1. Escolha uma versão do Android:
   - **API 31 (Android 12)** - Recomendado (mais estável)
   - **API 33 (Android 13)** - Alternativa
   - **Evite:** API muito recentes (podem ser pesadas)

2. Se não tiver baixado, clique em **"Download"** e aguarde

3. Clique em **"Next"**

### 4.4 Configurar AVD

1. **AVD Name:** Dê um nome (ex: `Pixel_3a_API_31`)

2. **Clique em "Show Advanced Settings"**

3. Configure:
   - **RAM:** `2048` MB (2GB)
   - **Graphics:** `Software - GLES 2.0` ← **IMPORTANTE!**
   - **Multi-core CPU:** `2`

4. Clique em **"Finish"**

---

## ▶️ Passo 5: Iniciar o Emulador

### 5.1 Pelo Device Manager

1. No **Device Manager**, encontre o emulador
2. Clique no botão **▶️ (Play)** ao lado do emulador
3. Aguarde o emulador iniciar (pode demorar 1-2 minutos)

### 5.2 Pelo Terminal

```bash
flutter emulators --launch Medium_Phone_API_36.1
```

Ou se criou um novo:
```bash
flutter emulators --launch Nome_Do_Novo_Emulador
```

---

## ✅ Passo 6: Verificar se Funcionou

### 6.1 Verificar Dispositivos

```bash
flutter devices
```

**Você deve ver:**
```
sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64
```

### 6.2 Executar o App

```bash
flutter run
```

O app deve instalar e executar no emulador!

---

## 🐛 Se Ainda Não Funcionar

### Verificar Logs

1. No **Device Manager**, clique nos **3 pontos** (⋯) ao lado do emulador
2. Clique em **"View Details"** ou **"Show on Disk"**
3. Verifique arquivos de log para erros

### Tentar Outras Configurações

1. **Graphics:** Tente **"Automatic"** em vez de Software
2. **RAM:** Reduza para 1536 MB (1.5GB)
3. **API:** Use API mais antiga (API 30 ou 31)

### Usar Dispositivo Físico

Se o emulador continuar com problemas:
- Siga: `docs/08-configurar-celular-fisico.md`
- Geralmente é mais rápido e confiável

---

## 📋 Checklist

- [ ] Device Manager aberto
- [ ] Emulador encontrado ou criado
- [ ] Graphics configurado para "Software - GLES 2.0"
- [ ] RAM configurada (2-4GB)
- [ ] Configurações salvas
- [ ] Emulador iniciado
- [ ] `flutter devices` mostra o emulador
- [ ] App executando

---

## 💡 Dicas

- **Deixe o emulador aberto** durante o desenvolvimento
- **Primeira inicialização é sempre mais lenta**
- **Use snapshots** para iniciar mais rápido depois
- **Se possível, use dispositivo físico** - geralmente é mais rápido

---

**Agora você sabe como configurar o emulador! Tente mudar o Graphics para Software primeiro.** 🚀

