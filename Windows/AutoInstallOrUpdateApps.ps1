$appsNames = @(
    "Mozilla.Firefox",
    "Bitwarden",
    "Fluent Search",
    "Google Chrome",
    "7-Zip",
    "Discord",
    "Notion",
    "Oh My Posh",
    "Vscode",
    "Opencode",
    "Git.Git",
    "Mozilla.Thunderbird",
    "Microsoft.NuGet",
    "Steam"
)

$appsIds = @(
)

foreach ($app in $appsNames) {
    Write-Host "`n--- Processando: $app ---" -ForegroundColor Cyan
    
    # Verifica se o aplicativo já está instalado pelo nome
    $installed = winget list $app 2>$null

    if ($installed) {
        Write-Host "Aplicativo '$app' detectado. Tentando atualizar..." -ForegroundColor Yellow
        winget upgrade $app --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "Aplicativo '$app' não encontrado. Instalando..." -ForegroundColor Green
        winget install $app --accept-package-agreements --accept-source-agreements
    }
}

Write-Host "`n`nTodos os apps foram instalados ou atualizados!`n`n" -ForegroundColor Magenta

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

