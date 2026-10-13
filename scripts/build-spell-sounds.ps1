# Sons des sorts d'Iron's Spells moins forts (resource pack du pack, Paxi).
# Usage : .\scripts\build-spell-sounds.ps1 -Jar <chemin du jar irons_spellbooks> [-Facteur 0.65]
# A relancer apres une mise a jour d'Iron's Spells (la liste des sons peut changer).
# Garde : sorts, lancers, boucles, projectiles et impacts. Exclus : boss, araignees de glace, marchand, musique, objets, interface.
param([Parameter(Mandatory = $true)][string]$Jar, [double]$Facteur = 0.65)

$root = Split-Path $PSScriptRoot -Parent
$out = Join-Path $root 'config\paxi\resourcepacks\pack_lbc_quests\assets\irons_spellbooks\sounds.json'
$enc = New-Object Text.UTF8Encoding $false

Add-Type -AssemblyName System.IO.Compression.FileSystem
$z = [IO.Compression.ZipFile]::OpenRead((Resolve-Path $Jar).Path)
$e = $z.Entries | Where-Object FullName -eq 'assets/irons_spellbooks/sounds.json'
$r = New-Object IO.StreamReader($e.Open()); $src = $r.ReadToEnd() | ConvertFrom-Json; $r.Close(); $z.Dispose()

$exclus = '^(music\.|ui\.|item\.|entity\.(dead_king|citadel_keeper|fire_boss|ice_spider|generic\.trader|generic\.swing_blade)\b)'
$res = [ordered]@{}
foreach ($p in $src.PSObject.Properties) {
    if ($p.Name -match $exclus) { continue }
    $sons = foreach ($s in $p.Value.sounds) {
        if ($s -is [string]) { [ordered]@{ name = $s; volume = $Facteur } }
        else {
            $o = [ordered]@{}
            foreach ($q in $s.PSObject.Properties) { $o[$q.Name] = $q.Value }
            $v = if ($null -ne $s.volume) { [double]$s.volume } else { 1.0 }
            $o['volume'] = [Math]::Round($v * $Facteur, 3)
            $o
        }
    }
    $def = [ordered]@{ replace = $true; sounds = @($sons) }
    if ($p.Value.subtitle) { $def['subtitle'] = $p.Value.subtitle }
    $res[$p.Name] = $def
}
New-Item -ItemType Directory -Force (Split-Path $out) | Out-Null
[IO.File]::WriteAllText($out, ($res | ConvertTo-Json -Depth 10), $enc)
Write-Host "Sons de sorts : $($res.Count) / $($src.PSObject.Properties.Name.Count) a $([Math]::Round($Facteur * 100)) % -> $out"
