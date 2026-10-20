# Ecrit l'equilibrage des boss (scripts/data/boss_equilibrage.csv) dans les configs des mods qui ont leurs propres reglages :
# Cataclysm (vie, attaque, attaques speciales, plafond de degats recus), Mowzie's Mobs (vie, attaque), Bosses of Mass Destruction
# (vie, degats). Les autres boss passent par le datapack (build-datapack.ps1 section 12, AttributeSetter).
# Relancable : les valeurs d'origine viennent de scripts/data/cataclysm_defauts.json et de la table $bomd ci-dessous.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$enc = New-Object Text.UTF8Encoding($false)
$ic = [cultureinfo]::InvariantCulture
$eq = @{}; foreach ($b in Import-Csv "$PSScriptRoot\data\boss_equilibrage.csv") { $eq[$b.id] = @{ vie = [double]::Parse($b.vie, $ic); deg = [double]::Parse($b.degats, $ic) } }
function Ecrit($f, $lignes) { $nl = if ([IO.File]::ReadAllText($f) -match "`r`n") { "`r`n" } else { "`n" }; [IO.File]::WriteAllText($f, (($lignes -join $nl) + $nl), $enc) }
function F($x) { ([Math]::Round($x, 2)).ToString('0.0#', $ic) }
$plafondDegatsRecus = 40.0   # Cataclysm : 20 a 25 par coup recu par defaut, 999 dans l'ancien pack

# --- Cataclysm : sections [mobs.<boss>.*]
$defauts = Get-Content "$PSScriptRoot\data\cataclysm_defauts.json" -Raw | ConvertFrom-Json
$f = "$root\config\cataclysm-common.toml"; $sec = ''
$lignes = foreach ($l in [IO.File]::ReadAllLines($f)) {
    if ($l -match '^\s*\[mobs\.([a-z_]+)') { $sec = $Matches[1] }
    $id = @("cataclysm:$sec", "cataclysm:the_$sec") | Where-Object { $eq.ContainsKey($_) } | Select-Object -First 1
    if ($id -and $l -match '^(\s*)(health_multiplier|attack_multiplier)\s*=') {
        $v = if ($Matches[2] -eq 'health_multiplier') { $eq[$id].vie } else { $eq[$id].deg }; "$($Matches[1])$($Matches[2]) = $(F $v)"; continue
    }
    if ($defauts.$sec -and $l -match '^(\s*)([a-z_]+)\s*=\s*[\d.]+\s*$' -and $null -ne $defauts.$sec.($Matches[2])) {
        $k = $Matches[2]; $d0 = [double]$defauts.$sec.$k
        if ($k -eq 'damage_cap') { if ($id -and $d0 -lt $plafondDegatsRecus) { "$($Matches[1])$k = $(F $plafondDegatsRecus)"; continue } }
        elseif ($id) { "$($Matches[1])$k = $(F ($d0 * $eq[$id].deg))"; continue }
    }
    $l
}
Ecrit $f $lignes

# --- Mowzie's Mobs : sections [mobs.<boss>.*]
$f = "$root\config\mowziesmobs-common.toml"; $sec = ''
$lignes = foreach ($l in [IO.File]::ReadAllLines($f)) {
    if ($l -match '^\s*\[mobs\.([a-z_]+)') { $sec = $Matches[1] }
    $id = "mowziesmobs:$sec"
    if ($eq.ContainsKey($id) -and $l -match '^(\s*)(health_multiplier|attack_multiplier)\s*=') {
        $v = if ($Matches[2] -eq 'health_multiplier') { $eq[$id].vie } else { $eq[$id].deg }; "$($Matches[1])$($Matches[2]) = $(F $v)"; continue
    }
    $l
}
Ecrit $f $lignes

# --- Bosses of Mass Destruction : valeurs d'origine (vie, degats) par section du json5
$bomd = @{ lichConfig = @('lich', 300, 9); obsidilithConfig = @('obsidilith', 300, 16); gauntletConfig = @('gauntlet', 250, 16); voidBlossomConfig = @('void_blossom', 350, 12) }
$f = "$root\config\bosses_of_mass_destruction.json5"; $sec = ''
$lignes = foreach ($l in [IO.File]::ReadAllLines($f)) {
    if ($l -match '^\s*"?([A-Za-z]+Config)"?\s*:\s*\{') { $sec = $Matches[1] }
    if ($bomd[$sec]) {
        $o = $bomd[$sec]; $e = $eq["bosses_of_mass_destruction:$($o[0])"]
        if ($l -match '^(\s*)"health"\s*:\s*[\d.]+(,?)') { "$($Matches[1])`"health`": $(F ($o[1] * $e.vie))$($Matches[2])"; continue }
        if ($l -match '^(\s*)"(damage|attack)"\s*:\s*[\d.]+(,?)') { "$($Matches[1])`"$($Matches[2])`": $(F ($o[2] * $e.deg))$($Matches[3])"; continue }
    }
    $l
}
Ecrit $f $lignes
Write-Host 'Configs des boss ecrites (Cataclysm, Mowzie, BOMD)'
