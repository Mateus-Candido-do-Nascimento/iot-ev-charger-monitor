# ⚡ Solução Rápida: Emulador Não Inicia (Erro -1073741701)

## 🔍 O Problema

O emulador não inicia e mostra o erro: `exited with code -1073741701`

## ✅ Solução Rápida (Tente nesta ordem)

### Solução 1: Mudar Graphics para Software (MAIS COMUM)

**Pelo Android Studio:**

1. Abra **Android Studio**
2. **Tools** → **Device Manager**
3. Clique no **ícone de lápis** (Edit) ao lado do emulador `Medium_Phone_API_36.1`
4. Clique em **"Show Advanced Settings"**
5. Em **"Graphics"**, mude para: **"Software - GLES 2.0"**
6. Clique em **"Finish"**
7. Tente iniciar novamente:
   ```bash
   flutter emulators --launch Medium_Phone_API_36.1
   ```

**Isso resolve 80% dos casos!**

---

### Solução 2: Criar Novo Emulador Mais Simples

**Pelo Android Studio:**

1. **Tools** → **Device Manager**
2. **Create Device**
3. Escolha: **Pixel 3a** (mais leve)
4. Escolha: **API 31 (Android 12)** (mais estável)
5. **Show Advanced Settings:**
   - **RAM:** 2048 MB
   - **Graphics:** Software - GLES 2.0
   - **Multi-core CPU:** 2
6. **Finish**
7. Inicie o novo emulador:
   ```bash
   flutter emulators --launch Nome_Do_Novo_Emulador
   ```

---

### Solução 3: Verificar Virtualization no BIOS

**Se as soluções acima não funcionarem:**

1. **Reinicie o PC**
2. Durante a inicialização, pressione:
   - **F2**, **F10**, **F12**, ou **Del** (depende do PC)
3. No BIOS, procure por:
   - **"Virtualization Technology"**
   - **"VT-x"** (Intel)
   - **"AMD-V"** (AMD)
4. **Ative** (Enabled)
5. **Salve e saia** (Save & Exit)
6. Tente iniciar o emulador novamente

---

### Solução 4: Atualizar Drivers Gráficos

**Intel:**
- https://www.intel.com/content/www/us/en/download-center/home.html

**NVIDIA:**
- https://www.nvidia.com/Download/index.aspx

**AMD:**
- https://www.amd.com/en/support

Depois de atualizar, **reinicie o PC**.

---

### Solução 5: Instalar HAXM

**Pelo Android Studio:**

1. **Tools** → **SDK Manager**
2. Aba **"SDK Tools"**
3. Marque: **Intel x86 Emulator Accelerator (HAXM installer)**
4. Clique **"Apply"**
5. Aguarde instalação
6. **Reinicie o PC**

---

## 🎯 Solução Mais Rápida (Recomendada)

**Tente esta sequência:**

1. **Mudar Graphics para Software** (Solução 1) ← Tente primeiro!
2. Se não funcionar: **Criar novo emulador simples** (Solução 2)
3. Se ainda não funcionar: **Verificar BIOS** (Solução 3)

---

## 📱 Alternativa: Usar Celular Físico

Se o emulador continuar dando problema, use seu celular:

1. Siga: `docs/08-configurar-celular-fisico.md`
2. Conecte via USB
3. Execute: `flutter run`

**Geralmente é mais rápido e confiável!**

---

## 📚 Documentação Completa

Para mais detalhes, veja: `docs/10-erro-emulador-startup.md`

---

**Tente a Solução 1 primeiro - geralmente resolve!** 🚀

