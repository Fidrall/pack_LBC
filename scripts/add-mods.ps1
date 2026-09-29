# Ajoute au pack tous les mods de modlist.txt (idempotent : les mods deja presents sont ignores par packwiz)
$ErrorActionPreference = "Continue"
$root = Split-Path $PSScriptRoot -Parent
$pw = Join-Path (Split-Path $root -Parent) "tools\packwiz.exe"
Set-Location $root

$failed = @()
foreach ($line in Get-Content (Join-Path $root "modlist.txt")) {
    if ($line -match '^\s*(#|$)') { continue }
    $parts = $line.Split('|') | ForEach-Object { $_.Trim() }
    $src, $id = $parts[0], $parts[1]
    Write-Host "==> $src $id"
    if ($src -eq "mr") {
        $out = & $pw -y modrinth add $id 2>&1
    } else {
        $out = & $pw -y curseforge add --addon-id $id 2>&1
    }
    $out | ForEach-Object { Write-Host "    $_" }
    if ($LASTEXITCODE -ne 0) { $failed += "$src | $id" }
}

Write-Host ""
Write-Host "Echecs : $($failed.Count)"
$failed | ForEach-Object { Write-Host "  $_" }
