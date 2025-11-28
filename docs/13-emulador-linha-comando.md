# 💻 Gerenciar Emulador pela Linha de Comando

Se você não encontra o Device Manager no Android Studio, use a linha de comando!

---

## 📋 Comandos Úteis

### Ver Emuladores Disponíveis

```bash
flutter emulators
```

Mostra todos os emuladores criados.

---

### Criar Novo Emulador

```bash
flutter emulators --create
```

Isso vai criar um emulador padrão automaticamente.

**Ou criar com nome específico:**

```bash
flutter emulators --create --name MeuEmulador
```

---

### Iniciar Emulador

```bash
flutter emulators --launch Nome_Do_Emulador
```

**Exemplo:**
```bash
flutter emulators --launch Medium_Phone_API_36.1
```

---

### Editar Emulador (via arquivo de configuração)

O emulador é salvo em um arquivo de configuração. Você pode editá-lo manualmente:

**Localização:**
```
C:\Users\mateus\.android\avd\Medium_Phone_API_36.1.avd\config.ini
```

**Edite o arquivo e mude:**
```
hw.gpu.enabled = yes
hw.gpu.mode = swiftshader_indirect
```

**Para usar software graphics, mude para:**
```
hw.gpu.enabled = no
```

Ou:
```
hw.gpu.mode = off
```

---

## 🛠️ Solução Rápida: Editar Config do Emulador

Vamos editar o arquivo de configuração diretamente:

### Passo 1: Encontrar o Arquivo

O arquivo está em:
```
C:\Users\mateus\.android\avd\Medium_Phone_API_36.1.avd\config.ini
```

### Passo 2: Editar o Arquivo

1. Abra o arquivo `config.ini` com um editor de texto (Notepad, VS Code, etc.)
2. Procure pela linha que começa com `hw.gpu.mode=`
3. Mude para:
   ```
   hw.gpu.mode=off
   ```
   Ou:
   ```
   hw.gpu.enabled=no
   ```
4. Salve o arquivo

### Passo 3: Tentar Iniciar Novamente

```bash
flutter emulators --launch Medium_Phone_API_36.1
```

---

## 🆕 Criar Novo Emulador Simples

Se editar não funcionar, vamos criar um novo:

### Opção 1: Pelo Flutter (Automático)

```bash
flutter emulators --create --name EmuladorSimples
```

### Opção 2: Pelo AVD Manager (Linha de Comando)

```bash
# Listar imagens disponíveis
sdkmanager --list | findstr "system-images"

# Criar AVD (exemplo)
avdmanager create avd -n EmuladorSimples -k "system-images;android-31;google_apis;x86_64"
```

---

## 📱 Alternativa Mais Fácil: Usar Celular Físico

Se o emulador continuar dando problema:

1. **Conecte seu celular via USB**
2. **Ative depuração USB** (veja `docs/08-configurar-celular-fisico.md`)
3. **Execute:**
   ```bash
   flutter run
   ```

**Geralmente é mais rápido e confiável que emulador!**

---

## 🔍 Verificar se Emulador Está Rodando

```bash
adb devices
```

Deve mostrar algo como:
```
List of devices attached
emulator-5554    device
```

---

## ✅ Próximos Passos

1. **Tente editar o config.ini** (mudar graphics para off)
2. **Se não funcionar, crie novo emulador**
3. **Se ainda não funcionar, use celular físico**

---

**Vamos tentar editar o arquivo de configuração primeiro!** 🚀



