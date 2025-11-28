# ⚡ Solução Rápida: flutter pub get Travando

## 🔍 O Problema

O comando `flutter pub get` está travando e não completa a execução.

## ✅ Soluções (Tente nesta ordem)

### Solução 1: Limpar Cache e Tentar Novamente

Abra um **NOVO terminal** (PowerShell ou CMD) e execute:

```bash
# Navegar até a pasta do projeto


# Limpar cache do Flutter
flutter clean

# Limpar cache do pub
flutter pub cache clean

# Tentar instalar dependências
flutter pub get
```

### Solução 2: Verificar Conexão

O Flutter precisa baixar pacotes da internet. Verifique:

1. **Teste a conexão:**
   ```bash
   ping pub.dev
   ```

2. **Se estiver usando VPN/Proxy:**
   - Desative temporariamente
   - Ou configure o proxy no Flutter

### Solução 3: Executar como Administrador

1. Feche o terminal atual
2. Clique com botão direito no PowerShell/CMD
3. Selecione **"Executar como administrador"**
4. Execute os comandos novamente

### Solução 4: Verificar Firewall/Antivírus

1. **Windows Defender:**
   - Adicione exceção para Flutter
   - Ou desative temporariamente para testar

2. **Outros antivírus:**
   - Adicione Flutter às exceções

### Solução 5: Usar Modo Verbose

Para ver onde está travando:

```bash
flutter pub get --verbose
```

Isso vai mostrar mais detalhes sobre o que está acontecendo.

### Solução 6: Deletar pubspec.lock

**CUIDADO:** Isso vai atualizar todas as dependências.

```bash
# Deletar o arquivo de lock
del pubspec.lock

# Tentar novamente
flutter pub get
```

### Solução 7: Instalar Dependência Manualmente

Se apenas uma dependência está travando, você pode tentar:

```bash
# Verificar qual dependência está faltando
flutter pub get --verbose

# Se for mqtt_client, tente:
flutter pub add mqtt_client
```

## 📋 Checklist Rápido

- [ ] Flutter está instalado? (`flutter --version`)
- [ ] Está na pasta correta? (`cd smart-charger\mobile_app`)
- [ ] Internet está funcionando? (`ping google.com`)
- [ ] Firewall não está bloqueando?
- [ ] Executou como administrador?
- [ ] Limpou o cache? (`flutter clean`)

## 🆘 Se Nada Funcionar

1. **Reinicie o computador**
2. **Abra um terminal novo**
3. **Tente novamente:**

```bash
cd "C:\Users\mateus\OneDrive - Instituto Presbiteriano Mackenzie\iot\iot-ev-charger-monitor\smart-charger\mobile_app"
flutter clean
flutter pub get
```

## 📝 O Que Foi Corrigido

✅ Adicionei a dependência `mqtt_client` no `pubspec.yaml` que estava faltando.

Agora o `pubspec.yaml` tem:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  mqtt_client: ^9.10.0  # ← ADICIONADO
```

## 💡 Dica

Se o problema persistir, pode ser:
- **Problema de rede lenta** - Aguarde mais tempo (pode demorar vários minutos)
- **Proxy corporativo** - Configure as variáveis de ambiente HTTP_PROXY
- **Antivírus muito restritivo** - Adicione exceções

---

**Tente a Solução 1 primeiro - geralmente resolve!** 🚀


