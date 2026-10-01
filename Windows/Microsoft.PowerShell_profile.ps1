# ALIAS
Set-Alias -Name keysHelp -Value Get-PSReadLineKeyHandler

oh-my-posh init pwsh --config 'jandedobbeleer' | Invoke-Expression;
Import-Module Terminal-Icons
Import-Module PSReadLine

Clear-Host