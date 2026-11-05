param(
    [string]$CaminhoConfig = "$PSScriptRoot\config.json"
)

Write-Host ""
Write-Host "=== Mapeamento de Pasta de Rede ===" -ForegroundColor Cyan

if (-not (Test-Path $CaminhoConfig)) {
    Write-Host "[ERRO] Arquivo nao encontrado: $CaminhoConfig" -ForegroundColor Red
    return
}

try {
    $config = Get-Content $CaminhoConfig -Raw -Encoding UTF8 | ConvertFrom-Json
}
catch {
    Write-Host "[ERRO] JSON invalido: $_" -ForegroundColor Red
    return
}

$servidor     = $config.servidor
$pasta        = $config.pasta
$letraUnidade = $config.letraUnidade

if (-not $servidor -or -not $pasta -or -not $letraUnidade) {
    Write-Host "[ERRO] JSON incompleto. Verifique servidor, pasta e letraUnidade." -ForegroundColor Red
    return
}

if ($servidor -notmatch '^172\.29\.') {
    Write-Host "[AVISO] O servidor $servidor nao esta na faixa 172.29.x.x" -ForegroundColor Yellow
}

$caminhoUNC = "\\$servidor\$pasta"

Write-Host "[INFO] Servidor: $servidor" -ForegroundColor Yellow
Write-Host "[INFO] Pasta:    $pasta" -ForegroundColor Yellow
Write-Host "[INFO] Caminho:  $caminhoUNC" -ForegroundColor Yellow
Write-Host "[INFO] Unidade:  ${letraUnidade}:" -ForegroundColor Yellow

$temCredencial = (cmdkey /list | Select-String ([regex]::Escape($servidor)))
if (-not $temCredencial) {
    Write-Host ""
    Write-Host "[AVISO] Nenhuma credencial salva para $servidor." -ForegroundColor Yellow
    Write-Host "        Crie a credencial no Gerenciador de Credenciais do Windows" -ForegroundColor Yellow
    Write-Host "        (Painel de Controle > Gerenciador de Credenciais > Credenciais do Windows)" -ForegroundColor Yellow
    Write-Host "        Tipo: Windows, Endereco de rede: $servidor" -ForegroundColor Yellow
    return
}

$mapeamentoAtual = net use "${letraUnidade}:" 2>$null
if ($mapeamentoAtual -and $mapeamentoAtual -notmatch [regex]::Escape($caminhoUNC)) {
    Write-Host ""
    Write-Host "[AVISO] ${letraUnidade}: ja esta mapeado para outro caminho:" -ForegroundColor Yellow
    Write-Host $mapeamentoAtual -ForegroundColor DarkYellow
    $confirma = Read-Host "Deseja substituir? (S/N)"
    if ($confirma -notmatch '^[SsYy]') {
        Write-Host "Operacao cancelada pelo usuario." -ForegroundColor Red
        return
    }
}

Write-Host ""
Write-Host "[INFO] Removendo mapeamento antigo de ${letraUnidade}: ..." -ForegroundColor Yellow
net use "${letraUnidade}:" /delete /y 2>$null | Out-Null

Write-Host "[INFO] Mapeando ${letraUnidade}: para $caminhoUNC ..." -ForegroundColor Yellow
net use "${letraUnidade}:" $caminhoUNC /persistent:yes | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERRO] Falha ao mapear $caminhoUNC" -ForegroundColor Red
    return
}

Write-Host ""
Write-Host "[OK] Mapeamento concluido com sucesso!" -ForegroundColor Green
Write-Host "     ${letraUnidade}: = $caminhoUNC" -ForegroundColor Green