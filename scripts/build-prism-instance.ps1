# Cree le zip d'instance Prism Launcher a distribuer aux joueurs (build\pack_LBC-prism.zip)
# Le joueur l'importe une fois dans Prism ; ensuite chaque lancement met le pack a jour tout seul.
#   -Local : variante de test qui pointe vers "packwiz serve" (http://localhost:8080)
param(
    [switch]$Local,
    [string]$PackUrl = "https://raw.githubusercontent.com/Fidrall/pack_LBC/main/pack.toml"
)
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$tools = Join-Path (Split-Path $root -Parent) "tools"
$pack = Get-Content (Join-Path $root "pack.toml") -Raw
$mc  = [regex]::Match($pack, 'minecraft = "([^"]+)"').Groups[1].Value
$neo = [regex]::Match($pack, 'neoforge = "([^"]+)"').Groups[1].Value

$name = "pack_LBC"
if ($Local) { $PackUrl = "http://localhost:8080/pack.toml"; $name = "pack_LBC (test local)" }

$tmp = Join-Path $root "build\prism-instance"
if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
New-Item -ItemType Directory -Force (Join-Path $tmp ".minecraft") | Out-Null

@"
InstanceType=OneSix
name=$name
OverrideCommands=true
PreLaunchCommand="`$INST_JAVA" -jar packwiz-installer-bootstrap.jar $PackUrl
OverrideMemory=true
MinMemAlloc=2048
MaxMemAlloc=8192
"@ | Set-Content (Join-Path $tmp "instance.cfg") -Encoding ascii

@"
{
    "components": [
        { "uid": "net.minecraft", "version": "$mc", "important": true },
        { "uid": "net.neoforged", "version": "$neo" }
    ],
    "formatVersion": 1
}
"@ | Set-Content (Join-Path $tmp "mmc-pack.json") -Encoding ascii

Copy-Item (Join-Path $tools "packwiz-installer-bootstrap.jar") (Join-Path $tmp ".minecraft")

$zip = Join-Path $root ("build\" + ($(if ($Local) { "pack_LBC-prism-test.zip" } else { "pack_LBC-prism.zip" })))
if (Test-Path $zip) { Remove-Item $zip }
Compress-Archive -Path (Join-Path $tmp "*") -DestinationPath $zip
Remove-Item $tmp -Recurse -Force
Write-Host "Instance Prism : $zip"
