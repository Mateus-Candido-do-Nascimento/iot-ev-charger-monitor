# 🔍 Como Encontrar o Device Manager no Android Studio

Se você não encontra o Device Manager, siga este guia.

---

## 🔎 Onde Procurar o Device Manager

### Opção 1: Menu Tools

1. No **Android Studio**, olhe o **menu superior**
2. Clique em **"Tools"**
3. Procure por:
   - **"Device Manager"** (versões mais recentes)
   - **"AVD Manager"** (versões antigas)
   - **"Virtual Device Manager"**

### Opção 2: Menu More Actions

1. No canto **superior direito**, procure por **"More Actions"** (ícone de 3 pontos ou 3 linhas)
2. Clique nele
3. Procure por **"Virtual Device Manager"** ou **"Device Manager"**

### Opção 3: Barra Lateral Direita

1. Olhe a **barra lateral direita** do Android Studio
2. Procure por um **ícone de dispositivo/telefone**
3. Pode estar junto com outros ícones (Project, Structure, etc.)

### Opção 4: Menu Configure

1. No canto **superior direito**, procure por **"Configure"** ou um ícone de engrenagem
2. Clique nele
3. Procure por **"AVD Manager"** ou **"Device Manager"**

---

## ❌ Se Não Aparecer Nenhuma Opção

### Problema: Android Studio Não Está Configurado

O Device Manager só aparece se o Android SDK estiver instalado.

### Solução: Instalar Android SDK

#### Passo 1: Abrir SDK Manager

1. **Tools** → **SDK Manager**
   - Ou: **File** → **Settings** → **Appearance & Behavior** → **System Settings** → **Android SDK**

#### Passo 2: Instalar Componentes

Na aba **"SDK Platforms"**:
- Marque pelo menos uma versão do Android (ex: **Android 13.0 (Tiramisu)**)
- Clique em **"Apply"** e aguarde

Na aba **"SDK Tools"**:
- Marque:
  - ✅ **Android SDK Build-Tools**
  - ✅ **Android Emulator**
  - ✅ **Android SDK Platform-Tools**
  - ✅ **Intel x86 Emulator Accelerator (HAXM installer)**
- Clique em **"Apply"** e aguarde

#### Passo 3: Verificar

Depois de instalar, o Device Manager deve aparecer.

---

## 🔧 Alternativa: Usar Linha de Comando

Se não conseguir encontrar no Android Studio, use o terminal:

### Listar Emuladores

```bash
flutter emulators
```

### Criar Emulador

```bash
flutter emulators --create --name MeuEmulador
```

### Iniciar Emulador

```bash
flutter emulators --launch MeuEmulador
```

---

## 📱 Alternativa: Usar Celular Físico

Se o Device Manager não aparecer ou der muito trabalho:

**Use seu celular físico:**
1. Siga: `docs/08-configurar-celular-fisico.md`
2. Conecte via USB
3. Execute: `flutter run`

**Geralmente é mais fácil e rápido!**

---

## 🆘 Verificar Versão do Android Studio

### Ver Qual Versão Você Tem

1. **Help** → **About**
2. Veja a versão do Android Studio

**Versões antigas** podem ter o nome diferente:
- **AVD Manager** (em vez de Device Manager)
- Pode estar em: **Tools** → **AVD Manager**

---

## ✅ Checklist

- [ ] Android Studio está totalmente instalado?
- [ ] Android SDK está instalado?
- [ ] Procurou em Tools → Device Manager?
- [ ] Procurou em More Actions?
- [ ] Procurou em Configure?
- [ ] Tentou usar linha de comando?
- [ ] Considerou usar celular físico?

---

## 💡 Dica

**Se nada funcionar:**
- Use o celular físico (mais fácil)
- Ou reinstale o Android Studio completamente

---

**Tente primeiro verificar se o Android SDK está instalado!** 🚀



