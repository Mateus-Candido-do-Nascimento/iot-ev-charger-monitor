# 🔧 Erro: Emulador Android Não Inicia (Código -1073741701)

Este guia ajuda a resolver o erro quando o emulador não consegue iniciar.

---

## 🔍 O Problema

**Erro:** `The android emulator exited with code -1073741701 during startup`

**Causas comuns:**
- Problema com aceleração de hardware (HAXM/Hyper-V)
- Drivers gráficos desatualizados
- Conflito com outras virtualizações
- Configurações incorretas do emulador

---

## ✅ Soluções (Tente nesta ordem)

### Solução 1: Verificar Aceleração de Hardware

#### 1.1 Verificar com Flutter Doctor

```bash
flutter doctor -v
```

Procure por:
- `Android toolchain` - deve estar ✅
- Se houver avisos sobre HAXM ou Hyper-V, anote

#### 1.2 Verificar se Virtualization está Ativada

**No Windows:**

1. Pressione `Win + R`
2. Digite: `msinfo32` e pressione Enter
3. Procure por **"Virtualização habilitada no firmware"**
4. Deve estar como **"Sim"**

**Se estiver "Não":**
- Reinicie o PC
- Entre no BIOS (geralmente F2, F10, ou Del durante a inicialização)
- Procure por "Virtualization Technology" ou "VT-x" ou "AMD-V"
- Ative e salve
- Reinicie

---

### Solução 2: Instalar/Atualizar HAXM

#### 2.1 Pelo Android Studio

1. **Abra o Android Studio**
2. **Tools** → **SDK Manager**
3. Aba **"SDK Tools"**
4. Marque:
   - ✅ **Intel x86 Emulator Accelerator (HAXM installer)**
   - ✅ **Android Emulator**
5. Clique **"Apply"** e aguarde a instalação

#### 2.2 Manualmente

1. Baixe o HAXM: https://github.com/intel/haxm/releases
2. Execute o instalador
3. Reinicie o computador

---

### Solução 3: Configurar Emulador para Software Graphics

Se a aceleração de hardware não funcionar, use gráficos por software:

#### 3.1 Pelo Android Studio

1. **Tools** → **Device Manager**
2. Clique no **ícone de lápis** (Edit) ao lado do emulador
3. Clique em **"Show Advanced Settings"**
4. Em **"Graphics"**, mude para:
   - **"Software - GLES 2.0"** ou
   - **"Automatic"**
5. Clique em **"Finish"**

#### 3.2 Pelo Terminal (Linha de Comando)

Edite o arquivo de configuração do emulador:

**Localização:**
```
C:\Users\SeuUsuario\.android\avd\Medium_Phone_API_36.1.avd\config.ini
```

**Edite a linha:**
```
hw.gpu.enabled = yes
hw.gpu.mode = swiftshader_indirect
```

**Ou:**
```
hw.gpu.enabled = no
```

---

### Solução 4: Atualizar Drivers Gráficos

#### 4.1 Intel Graphics

1. Baixe: https://www.intel.com/content/www/us/en/download-center/home.html
2. Instale os drivers mais recentes
3. Reinicie

#### 4.2 NVIDIA

1. Baixe: https://www.nvidia.com/Download/index.aspx
2. Instale os drivers mais recentes
3. Reinicie

#### 4.3 AMD

1. Baixe: https://www.amd.com/en/support
2. Instale os drivers mais recentes
3. Reinicie

---

### Solução 5: Desativar Hyper-V (se estiver ativo)

**Se você tem Windows Pro/Enterprise:**

1. Abra PowerShell como **Administrador**
2. Execute:
```powershell
bcdedit /set hypervisorlaunchtype off
```
3. **Reinicie o computador**

**Para reativar depois (se necessário):**
```powershell
bcdedit /set hypervisorlaunchtype auto
```

**Atenção:** Isso pode afetar outras virtualizações (Docker, WSL2, etc.)

---

### Solução 6: Criar Novo Emulador com Configurações Diferentes

#### 6.1 Criar Emulador Mais Simples

1. **Android Studio** → **Device Manager**
2. **Create Device**
3. Escolha um dispositivo mais simples (ex: Pixel 3a)
4. Escolha API mais antiga (ex: API 31 - Android 12)
5. **Show Advanced Settings:**
   - **RAM:** 2048 MB (2GB)
   - **Graphics:** Software - GLES 2.0
   - **Multi-core CPU:** 2
6. **Finish**

#### 6.2 Testar o Novo Emulador

```bash
flutter emulators --launch Nome_Do_Novo_Emulador
```

---

### Solução 7: Limpar e Recriar Emulador

#### 7.1 Deletar Emulador Atual

1. **Android Studio** → **Device Manager**
2. Clique no **ícone de lixeira** ao lado do emulador
3. Confirme a exclusão

#### 7.2 Criar Novo

Siga os passos da Solução 6.

---

### Solução 8: Verificar Espaço em Disco

O emulador precisa de espaço:

1. Verifique se há pelo menos **10GB livres**
2. Limpe espaço se necessário

---

### Solução 9: Executar como Administrador

1. Feche o Android Studio
2. Clique com botão direito no **Android Studio**
3. **"Executar como administrador"**
4. Tente iniciar o emulador novamente

---

## 🔍 Diagnóstico Detalhado

### Verificar Logs do Emulador

O emulador gera logs que podem ajudar:

**Localização dos logs:**
```
C:\Users\SeuUsuario\.android\avd\Medium_Phone_API_36.1.avd\
```

Procure por arquivos `.log` e verifique erros.

### Executar Emulador com Verbose

```bash
emulator -avd Medium_Phone_API_36.1 -verbose
```

Isso mostra mais detalhes sobre o que está acontecendo.

---

## 💡 Solução Rápida (Mais Comum)

**A maioria dos problemas é resolvida com:**

1. **Atualizar drivers gráficos**
2. **Mudar Graphics para "Software"**
3. **Criar novo emulador mais simples**

**Tente esta sequência:**

```bash
# 1. Verificar status
flutter doctor -v

# 2. Criar novo emulador simples pelo Android Studio
# (Device Manager → Create Device → Pixel 3a → API 31 → Graphics: Software)

# 3. Tentar iniciar
flutter emulators --launch Nome_Do_Novo_Emulador
```

---

## 🆘 Se Nada Funcionar

### Opção 1: Usar Dispositivo Físico

É mais fácil e geralmente funciona melhor:

1. Siga o guia: `docs/08-configurar-celular-fisico.md`
2. Conecte seu celular via USB
3. Execute: `flutter run`

### Opção 2: Usar Emulador Online

Serviços como:
- **BrowserStack** (pago)
- **Sauce Labs** (pago)
- **Genymotion** (tem versão gratuita)

### Opção 3: Reinstalar Android Studio

Como último recurso:

1. Desinstale Android Studio completamente
2. Delete a pasta: `C:\Users\SeuUsuario\.android`
3. Reinstale Android Studio
4. Configure tudo novamente

---

## 📋 Checklist de Troubleshooting

- [ ] Virtualization ativada no BIOS?
- [ ] HAXM instalado e atualizado?
- [ ] Drivers gráficos atualizados?
- [ ] Emulador configurado com Graphics: Software?
- [ ] Espaço em disco suficiente?
- [ ] Tentou criar novo emulador?
- [ ] Executou como administrador?
- [ ] Verificou logs de erro?

---

## 🔗 Recursos Adicionais

- Documentação Android Emulator: https://developer.android.com/studio/run/emulator
- Troubleshooting HAXM: https://github.com/intel/haxm/wiki/Installation-Instructions-on-Windows
- Flutter Troubleshooting: https://docs.flutter.dev/get-started/install/windows#troubleshooting

---

## 💬 Erros Relacionados

### Erro: "HAXM is not installed"
→ Veja Solução 2

### Erro: "Graphics initialization failed"
→ Veja Solução 3 e 4

### Erro: "VT-x is not available"
→ Veja Solução 1 (ativar virtualization no BIOS)

### Emulador inicia mas fica preto
→ Aguarde mais tempo (pode demorar 2-3 minutos)
→ Ou veja Solução 3 (mudar graphics)

---

**Tente as soluções na ordem apresentada. A maioria dos problemas é resolvida nas primeiras 3 soluções!** 🚀

