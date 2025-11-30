# Script de Limpeza Completa do Flutter
# Execute este script como Administrador se necessário

Write-Host "🧹 Iniciando limpeza completa do Flutter..." -ForegroundColor Yellow

# 1. Limpar cache do pub
Write-Host "`n1️⃣ Limpando cache do pub..." -ForegroundColor Cyan
try {
    flutter pub cache clean
    Write-Host "✅ Cache do pub limpo!" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Erro ao limpar cache do pub: $_" -ForegroundColor Yellow
}

# 2. Limpar pasta .pub-cache manualmente
Write-Host "`n2️⃣ Limpando pasta .pub-cache..." -ForegroundColor Cyan
$pubCachePath = "$env:USERPROFILE\.pub-cache"
if (Test-Path $pubCachePath) {
    try {
        Remove-Item -Recurse -Force $pubCachePath -ErrorAction SilentlyContinue
        Write-Host "✅ Pasta .pub-cache removida!" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Não foi possível remover .pub-cache: $_" -ForegroundColor Yellow
        Write-Host "   Tente fechar todas as janelas do Flutter/VS Code e executar novamente." -ForegroundColor Yellow
    }
} else {
    Write-Host "ℹ️ Pasta .pub-cache não encontrada." -ForegroundColor Gray
}

# 3. Limpar projeto Flutter
Write-Host "`n3️⃣ Limpando projeto Flutter..." -ForegroundColor Cyan
if (Test-Path "pubspec.yaml") {
    try {
        flutter clean
        Write-Host "✅ Projeto limpo!" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Erro ao executar flutter clean: $_" -ForegroundColor Yellow
    }
    
    # Remover pastas e arquivos manuais
    Write-Host "`n4️⃣ Removendo arquivos temporários..." -ForegroundColor Cyan
    
    $itemsToRemove = @(
        ".dart_tool",
        "build",
        "pubspec.lock"
    )
    
    foreach ($item in $itemsToRemove) {
        if (Test-Path $item) {
            try {
                Remove-Item -Recurse -Force $item -ErrorAction SilentlyContinue
                Write-Host "   ✅ Removido: $item" -ForegroundColor Green
            } catch {
                Write-Host "   ⚠️ Não foi possível remover: $item" -ForegroundColor Yellow
            }
        }
    }
} else {
    Write-Host "⚠️ Não está no diretório do projeto Flutter!" -ForegroundColor Red
    Write-Host "   Execute este script dentro da pasta mobile_app" -ForegroundColor Yellow
}

# 5. Reinstalar dependências
Write-Host "`n5️⃣ Reinstalando dependências..." -ForegroundColor Cyan
try {
    flutter pub get
    Write-Host "✅ Dependências reinstaladas!" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro ao reinstalar dependências: $_" -ForegroundColor Red
}

Write-Host "`n✨ Limpeza concluída!" -ForegroundColor Green
Write-Host "`nSe ainda houver problemas, tente:" -ForegroundColor Yellow
Write-Host "  1. Fechar todas as janelas do VS Code/Android Studio" -ForegroundColor Gray
Write-Host "  2. Reiniciar o computador" -ForegroundColor Gray
Write-Host "  3. Executar o script novamente" -ForegroundColor Gray

