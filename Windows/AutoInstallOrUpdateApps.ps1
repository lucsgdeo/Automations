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
        winget upgrade --id $app --exact --accept-package-agreements --accept-source-agreements --exclude Microsoft.WindowsTerminal
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

Write-Host "`n`nInstalando NerdFonts`n" -ForegroundColor Yellow
oh-my-posh font install meslo

Write-Host "`n`nIntalando Modules do Oh My Posh" -ForegroundColor Yellow
Install-Module PSReadLine -Force
Install-Module -Name Terminal-Icons -Force

Write-Host "`n`n1. Visite o site para terminar a configuração do Oh My Posh                 - https://ohmyposh.dev/docs/installation/fonts" -ForegroundColor Magenta
Write-Host "2. Este vídeo pode te ajudar a configurar o terminal e deixá-lo mais bonito - https://youtu.be/-G6GbXGo4wo?si=JScmnB0QGrFxQ7or `n`n" -ForegroundColor Magenta

Write-Host "Baixe os drivers mais atualizados da placa de vídeo: https://www.amd.com/pt/support/downloads/drivers.html/graphics/radeon-rx/radeon-rx-6000-series/amd-radeon-rx-6600-xt.html" -ForegroundColor Red

Write-Host "`n`n*** Setup Completo!! ***`n`n" -ForegroundColor Green

Read-Host -Prompt "Pressione Enter para sair"