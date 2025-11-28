# 🔧 Troubleshooting - Solução de Problemas

Este guia ajuda a resolver problemas comuns durante o desenvolvimento.

---

## ❌ Problema: `flutter pub get` Travando

### Sintomas
- O comando `flutter pub get` fica rodando sem terminar
- Não mostra nenhuma saída ou progresso
- Precisa cancelar manualmente (Ctrl+C)

### Possíveis Causas e Soluções

#### 1. Problema de Conexão com pub.dev

**Solução:**
```bash
# Limpar cache do pub
flutter pub cache clean

# Tentar novamente
flutter pub get
```

**Se ainda não funcionar:**
```bash
# Verificar conectividade
ping pub.dev

# Tentar com timeout maior
flutter pub get --verbose
```

#### 2. Firewall/Antivírus Bloqueando

**Solução:**
- Adicione o Flutter e Dart às exceções do firewall
- Desative temporariamente o antivírus para testar
- Verifique se o Windows Defender não está bloqueando

#### 3. Proxy ou VPN

**Se estiver usando proxy/VPN:**
```bash
# Configurar proxy (se necessário)
set HTTP_PROXY=http://proxy:porta
set HTTPS_PROXY=http://proxy:porta

# Ou desative temporariamente a VPN
```

#### 4. Cache Corrompido

**Solução completa:**
```bash
# 1. Limpar cache do Flutter
flutter clean

# 2. Limpar cache do pub
flutter pub cache clean

# 3. Deletar pubspec.lock (cuidado: vai atualizar todas as dependências)
del pubspec.lock

# 4. Tentar novamente
flutter pub get
```

#### 5. Dependências com Problemas

**Verificar dependências:**
```bash
# Ver quais dependências estão desatualizadas
flutter pub outdated

# Tentar atualizar uma por vez
flutter pub upgrade nome_do_pacote
```

---

## ❌ Problema: Flutter Não Reconhecido

### Sintomas
```
'flutter' não é reconhecido como comando interno ou externo
```

### Solução

1. **Verificar se Flutter está no PATH:**
   ```bash
   echo $env:PATH
   ```
   Deve conter o caminho do Flutter (ex: `C:\src\flutter\bin`)

2. **Adicionar ao PATH:**
   - Veja: `docs/01-instalacao-flutter.md` - Passo 1.2

3. **Reabrir o terminal:**
   - Feche e abra um novo terminal
   - Ou reinicie o computador

---

## ❌ Problema: Android SDK Não Encontrado

### Sintomas
```
Android SDK not found
```

### Solução

1. **Verificar ANDROID_HOME:**
   ```bash
   echo $env:ANDROID_HOME
   ```

2. **Configurar ANDROID_HOME:**
   - Veja: `docs/01-instalacao-flutter.md` - Passo 3

3. **Verificar no Android Studio:**
   - File → Settings → Android SDK
   - Copie o caminho do "Android SDK Location"

---

## ❌ Problema: Dispositivo Não Aparece

### Sintomas
```
No devices found
```

### Solução

1. **Verificar com ADB:**
   ```bash
   adb devices
   ```

2. **Reiniciar servidor ADB:**
   ```bash
   adb kill-server
   adb start-server
   adb devices
   ```

3. **Para emulador:**
   - Certifique-se que o emulador está rodando
   - Veja: `docs/03-dispositivos-emuladores.md`

4. **Para dispositivo físico:**
   - Ative "Depuração USB"
   - Aceite a permissão no celular
   - Veja: `docs/03-dispositivos-emuladores.md`

---

## ❌ Problema: Erro de Compilação

### Sintomas
```
Error: Could not resolve the package
```

### Solução

1. **Verificar pubspec.yaml:**
   - Certifique-se que a dependência está listada
   - Verifique a sintaxe (espaços, indentação)

2. **Limpar e reinstalar:**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Verificar versão do Dart:**
   ```bash
   dart --version
   ```
   Deve ser compatível com as dependências

---

## ❌ Problema: App Não Compila

### Sintomas
```
Gradle build failed
```

### Solução

1. **Limpar build:**
   ```bash
   flutter clean
   cd android
   gradlew clean
   cd ..
   flutter pub get
   ```

2. **Verificar versão do Gradle:**
   - Abra `android/build.gradle`
   - Verifique se a versão é compatível

3. **Atualizar dependências Android:**
   - Abra Android Studio
   - Tools → SDK Manager
   - Instale atualizações pendentes

---

## ❌ Problema: Hot Reload Não Funciona

### Sintomas
- Pressiona `r` mas nada acontece
- App não atualiza

### Solução

1. **Usar Hot Restart (R):**
   - Pressione `R` (maiúsculo) em vez de `r`

2. **Reiniciar o app:**
   ```bash
   # Parar o app (q)
   # Executar novamente
   flutter run
   ```

3. **Verificar se há erros:**
   - Olhe o console para mensagens de erro
   - Execute `flutter analyze`

---

## ❌ Problema: Erro de Permissões

### Sintomas
```
Permission denied
```

### Solução

1. **Executar como Administrador:**
   - Clique com botão direito no terminal
   - "Executar como administrador"

2. **Verificar permissões da pasta:**
   - Certifique-se que tem permissão de escrita
   - Não use pastas protegidas (como Program Files)

---

## 🔍 Comandos de Diagnóstico

### Verificar Status Completo
```bash
flutter doctor -v
```

### Verificar Conectividade
```bash
ping pub.dev
ping google.com
```

### Verificar Variáveis de Ambiente
```bash
# PowerShell
echo $env:FLUTTER_ROOT
echo $env:ANDROID_HOME
echo $env:PATH

# CMD
echo %FLUTTER_ROOT%
echo %ANDROID_HOME%
echo %PATH%
```

### Verificar Cache
```bash
flutter pub cache list
flutter pub cache repair
```

---

## 📝 Logs e Debug

### Executar com Verbose
```bash
flutter pub get --verbose
flutter run --verbose
```

### Ver Logs do Android
```bash
adb logcat
```

### Limpar Tudo e Começar de Novo
```bash
# CUIDADO: Isso vai limpar tudo
flutter clean
del pubspec.lock
flutter pub cache clean
flutter pub get
```

---

## 🆘 Quando Nada Funciona

1. **Verificar documentação oficial:**
   - https://docs.flutter.dev/get-started/install/windows#troubleshooting

2. **Procurar no Stack Overflow:**
   - Cole o erro completo
   - Inclua saída do `flutter doctor -v`

3. **Verificar issues no GitHub:**
   - https://github.com/flutter/flutter/issues

4. **Reinstalar Flutter:**
   - Delete a pasta do Flutter
   - Baixe novamente
   - Reconfigure o PATH

---

## 💡 Dicas Gerais

- **Sempre execute `flutter doctor`** quando tiver problemas
- **Mantenha o Flutter atualizado:** `flutter upgrade`
- **Limpe o cache regularmente:** `flutter clean`
- **Leia as mensagens de erro:** Elas geralmente dizem o que fazer
- **Use `--verbose`** para ver mais detalhes

---

## 📚 Referências

- Documentação Flutter: https://docs.flutter.dev/
- Troubleshooting oficial: https://docs.flutter.dev/get-started/install/windows#troubleshooting
- Stack Overflow Flutter: https://stackoverflow.com/questions/tagged/flutter



