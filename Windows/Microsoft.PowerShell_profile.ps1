# ALIAS
Set-Alias -Name keysHelp -Value Get-PSReadLineKeyHandler
Set-Alias -Name Documents -Value "cd 'C:\Users\Admin\Documents\'"

oh-my-posh init pwsh --config 'jandedobbeleer' | Invoke-Expression;
Import-Module Terminal-Icons
Import-Module PSReadLine

Clear-Host