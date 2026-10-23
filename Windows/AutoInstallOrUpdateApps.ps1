$appsNames = @(
    "7zip.7zip",
    "Git.Git",
    "Vivaldi.Vivaldi",
    "Google.Chrome",
    "Google.GoogleDrive",
    "BlastApps.FluentSearch",
    "Bitwarden.Bitwarden",
    "Valve.Steam",
    "Notion.Notion",
    "JanDeDobbeleer.OhMyPosh",
    "Discord.Discord",
    "Mozilla.Thunderbird",
    "Microsoft.NuGet",
    "Microsoft.WSL",
    "cURL.cURL"
)

foreach ($app in $appsNames) {
    Write-Host "`n--- Processando: $app ---" -ForegroundColor Cyan
    
    # Verifica se o aplicativo já está instalado pelo nome
    winget list --id $app --exact --accept-source-agreements | Out-Null

    # Verifica o código de saída: 0 indica que o pacote foi encontrado
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Aplicativo '$app' detectado. Tentando atualizar..." -ForegroundColor Yellow
        winget upgrade --id $app --exact --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "Aplicativo '$app' não encontrado. Instalando..." -ForegroundColor Green
        winget install --id $app --exact --accept-package-agreements --accept-source-agreements
    }
}

Write-Host "`n`nTodos os apps foram instalados ou atualizados!`n`n" -ForegroundColor Magenta

if ([string]::IsNullOrEmpty($PROFILE)) {
    $profileFolder = if ($PSVersionTable.PSEdition -eq 'Core') {
        Join-Path $env:USERPROFILE 'Documents\PowerShell'
    } else {
        Join-Path $env:USERPROFILE 'Documents\WindowsPowerShell'
    }

    # Garante que a pasta exista antes de criar o arquivo
    if (-not (Test-Path $profileFolder)) {
        New-Item -Path $profileFolder -ItemType Directory -Force | Out-Null
    }

    $PROFILE = Join-Path $profileFolder 'Microsoft.PowerShell_profile.ps1'
}

if(!$PROFILE) { 
    New-Item -Path $PROFILE -Type File -Force
    Write-Host "Profile criado com sucesso! Não se esqueça de atualizar com notepad $PROFILE"
} else {
    Write-Host "Profile já criado! Não se esqueça de atualizar com notepad $PROFILE"
}

# Força a instalação apenas para o usuário atual, evitando bloqueios no sistema
Write-Host "`n`nInstalando Modules do Oh My Posh" -ForegroundColor Yellow
Install-Module PSReadLine -Force -Scope CurrentUser -AllowClobber
Install-Module -Name Terminal-Icons -Force -Scope CurrentUser -AllowClobber

Write-Host "`n`n*** Setup Completo!! ***`n`n" -ForegroundColor Green

Read-Host -Prompt "Pressione Enter para sair"