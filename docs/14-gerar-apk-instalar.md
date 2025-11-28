# 📦 Como Gerar APK e Instalar no Celular

A forma mais simples: gerar um arquivo APK e instalar diretamente no celular!

---

## 🎯 Método 1: Gerar APK e Instalar Manualmente

### Passo 1: Gerar o APK

No terminal, execute:

```bash
cd smart-charger/mobile_app
flutter build apk
```

**Isso vai:**
- Compilar o app
- Gerar um arquivo APK
- Salvar em: `build/app/outputs/flutter-apk/app-release.apk`

**Tempo:** Pode demorar alguns minutos na primeira vez.

---

### Passo 2: Encontrar o APK

O APK estará em:
```
smart-charger/mobile_app/build/app/outputs/flutter-apk/app-release.apk
```

---

### Passo 3: Transferir para o Celular

**Opção A: Via USB**
1. Conecte o celular ao computador via USB
2. Copie o arquivo `app-release.apk` para o celular
3. Desconecte o USB

**Opção B: Via Email/WhatsApp**
1. Envie o arquivo `app-release.apk` para você mesmo por email ou WhatsApp
2. Baixe no celular

**Opção C: Via Google Drive/OneDrive**
1. Faça upload do APK para Google Drive ou OneDrive
2. Baixe no celular

---

### Passo 4: Instalar no Celular

1. **No celular**, abra o arquivo `app-release.apk`
2. Se aparecer aviso de "Fontes desconhecidas":
   - Vá em **Configurações** → **Segurança**
   - Ative **"Fontes desconhecidas"** ou **"Instalar apps de fontes desconhecidas"**
3. **Toque em "Instalar"**
4. Aguarde a instalação
5. **Toque em "Abrir"** ou encontre o app "Smart Charger" no menu

**Pronto! O app está instalado!** ✅

---

## 🚀 Método 2: Gerar APK Dividido (Menor)

Se o APK ficar muito grande, gere versões separadas por arquitetura:

```bash
flutter build apk --split-per-abi
```

Isso gera 3 APKs menores:
- `app-armeabi-v7a-release.apk` (para celulares mais antigos)
- `app-arm64-v8a-release.apk` (para celulares modernos - USE ESTE)
- `app-x86_64-release.apk` (para tablets/emuladores)

**Use o `app-arm64-v8a-release.apk` para a maioria dos celulares modernos.**

---

## 📱 Método 3: Instalar Diretamente via USB (Mais Rápido)

Se o celular estiver conectado via USB:

### Passo 1: Conectar Celular

1. Conecte o celular ao computador via USB
2. **No celular:** Aceite a permissão de depuração USB (se aparecer)

### Passo 2: Instalar Diretamente

```bash
# Gerar APK
flutter build apk

# Instalar diretamente no celular conectado
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Pronto! O app será instalado automaticamente no celular!**

---

## 🔧 Comandos Úteis

### Verificar se Celular Está Conectado

```bash
adb devices
```

Deve mostrar seu celular listado.

### Desinstalar Versão Antiga (se houver)

```bash
adb uninstall com.example.mobile_app
```

Ou pelo nome do pacote (verifique no `pubspec.yaml` - campo `name`).

### Instalar e Substituir

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

O `-r` substitui a versão antiga se já existir.

---

## ⚙️ Configurações do App

### Mudar Nome do App

Edite `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="Smart Charger"
    ...>
```

### Mudar Ícone do App

1. Coloque o ícone em: `android/app/src/main/res/mipmap-*/`
2. Ou use um gerador de ícones online

### Mudar Versão

Edite `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

O primeiro número é a versão do app, o segundo é o build number.

---

## 🐛 Problemas Comuns

### Problema: "APK não instala"

**Soluções:**
1. **Ative "Fontes desconhecidas"** nas configurações do celular
2. **Desinstale versão antiga** antes de instalar nova
3. **Verifique espaço** no celular

### Problema: "App não abre"

**Soluções:**
1. **Verifique permissões** - O app precisa de internet para MQTT
2. **Verifique se o celular tem internet**
3. **Veja logs:**
   ```bash
   adb logcat | findstr flutter
   ```

### Problema: "APK muito grande"

**Solução:**
```bash
flutter build apk --split-per-abi
```

Use apenas o APK da arquitetura do seu celular (geralmente `arm64-v8a`).

---

## 📋 Checklist Rápido

- [ ] App compilado (`flutter build apk`)
- [ ] APK encontrado em `build/app/outputs/flutter-apk/`
- [ ] APK transferido para celular
- [ ] "Fontes desconhecidas" ativado no celular
- [ ] APK instalado
- [ ] App aberto e funcionando

---

## 💡 Dicas

### Para Desenvolvimento

- Use `flutter run` para testar rapidamente
- Use `flutter build apk` quando quiser distribuir

### Para Produção

- Use `flutter build apk --release` (já é o padrão)
- Considere gerar App Bundle para Google Play:
  ```bash
  flutter build appbundle
  ```

### Compartilhar com Outros

- Envie o APK por WhatsApp, email, ou Google Drive
- Outros podem instalar sem precisar de Google Play

---

## 🎯 Resumo: O Mais Simples

**Para instalar no seu celular AGORA:**

```bash
# 1. Gerar APK
cd smart-charger/mobile_app
flutter build apk

# 2. O APK estará em:
# build/app/outputs/flutter-apk/app-release.apk

# 3. Copie para o celular e instale!
```

**Pronto! Muito mais simples que emulador!** 🚀

---

## 📚 Próximos Passos

Depois de instalar:
1. **Teste o app** no celular
2. **Veja se conecta ao MQTT**
3. **Verifique se recebe dados**
4. **Compartilhe com outros** se quiser

---

**Agora você pode instalar o app no celular sem precisar de emulador ou depuração USB!** ✅



