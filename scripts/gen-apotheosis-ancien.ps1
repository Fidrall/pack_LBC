# Reprend l'equilibrage Apotheosis de l'ancien pack (Create Chronicles The Endventure, kubejs/data) sur nos versions des mods.
# Pour chaque fichier surcharge par l'ancien pack : on compare a SON jar (Apotheosis 8.5.3, Irons Apothic 2.2.0) pour savoir
# quelles cles il avait changees, puis on applique seulement ces cles sur le fichier de NOTRE jar (8.9.0 / 2.2.8).
# Un fichier desactive (condition neoforge:false) reste desactive.
# Cles reprises : valeurs, regles des raretes et poids (Apotheosis). Pas les ecoles, attributs, conditions ni categories :
# l'ancien pack visait d'anciens identifiants (hazennstuff:radiance, alshanex_familiars:sound...) qui casseraient chez nous.
# Sortie : scripts/data/apotheosis_ancien/data/** (copie par build-datapack section 13). A relancer si Apotheosis est mis a jour.
param(
    [string]$Ancien = 'C:\Users\Antho\curseforge\minecraft\Instances\Create Chronicles The Endventure',
    [string]$Mods = "$env:APPDATA\PrismLauncher\instances\pack_LBC-prism\.minecraft\mods",
    [string[]]$Dossiers = @('apotheosis/affixes', 'apotheosis/rarities', 'apotheosis/gems', 'irons_apothic/affixes')
)
$reprises = @{ apotheosis = @('values', 'rules', 'definition', 'bonuses'); irons_apothic = @('values') }
# Gemmes que l'ancien pack desactivait (lunar, solar, inferno) : gardees, des joueurs en ont deja serti.
$sansDesactivation = @('apotheosis/gems')
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$sortie = Join-Path $PSScriptRoot 'data\apotheosis_ancien'
if (Test-Path $sortie) { Remove-Item $sortie -Recurse -Force }

function Jar($dossier, $motif) {
    $j = Get-ChildItem $dossier -Filter $motif | Select-Object -First 1
    if (-not $j) { throw "Jar introuvable : $motif dans $dossier" }
    [IO.Compression.ZipFile]::OpenRead($j.FullName)
}
function Lire($zip, $chemin) {
    $e = $zip.GetEntry($chemin)
    if (-not $e) { return $null }
    $r = New-Object IO.StreamReader $e.Open()
    try { $r.ReadToEnd() | ConvertFrom-Json } finally { $r.Close() }
}
function Texte($v) { if ($null -eq $v) { '' } else { $v | ConvertTo-Json -Depth 50 -Compress } }

$jars = @{
    apotheosis    = @{ ancien = (Jar "$Ancien\mods" 'Apotheosis-*.jar'); nous = (Jar $Mods 'Apotheosis-*.jar') }
    irons_apothic = @{ ancien = (Jar "$Ancien\mods" 'irons_apothic-*.jar'); nous = (Jar $Mods 'irons_apothic-*.jar') }
}
$bilan = [ordered]@{ modifies = 0; desactives = 0; inchanges = 0; absents = @(); corriges = @() }
$utf8 = New-Object Text.UTF8Encoding($false)
try {
    foreach ($d in $Dossiers) {
        $ns = $d.Split('/')[0]
        $racine = Join-Path "$Ancien\kubejs\data" ($d -replace '/', '\')
        foreach ($f in Get-ChildItem $racine -Recurse -File -Filter *.json) {
            $chemin = "data/$d/" + $f.FullName.Substring($racine.Length + 1).Replace('\', '/')
            $sur = Get-Content $f.FullName -Raw | ConvertFrom-Json
            $dest = Join-Path $sortie $chemin.Replace('/', '\')
            New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
            if ($sur.conditions -and ($sur.conditions | Where-Object { $_.type -eq 'neoforge:false' })) {
                if ($sansDesactivation -contains $d) { $bilan.absents += "$chemin (desactive dans l'ancien pack, garde tel quel)"; continue }
                [IO.File]::WriteAllText($dest, '{ "conditions": [ { "type": "neoforge:false" } ] }', $utf8)
                $bilan.desactives++; continue
            }
            $orig = Lire $jars[$ns].ancien $chemin
            $neuf = Lire $jars[$ns].nous $chemin
            if (-not $orig -or -not $neuf) { $bilan.absents += "$chemin (jar ancien: $([bool]$orig), notre jar: $([bool]$neuf))"; Remove-Item $dest -ErrorAction SilentlyContinue; continue }
            $cles = @($sur.PSObject.Properties.Name | Where-Object { $reprises[$ns] -contains $_ -and (Texte $sur.$_) -ne (Texte $orig.$_) })
            if (-not $cles) { $bilan.inchanges++; continue }
            foreach ($k in $cles) {
                if ($neuf.PSObject.Properties.Name -contains $k) { $neuf.$k = $sur.$k } else { $neuf | Add-Member -NotePropertyName $k -NotePropertyValue $sur.$k }
            }
            # Fautes de frappe de l'ancien pack : min > max d'un facteur 10 (murderous mythique 0.6 pour un max de 0.12...)
            if ($neuf.values) {
                foreach ($p in $neuf.values.PSObject.Properties) {
                    $v = $p.Value
                    if ($v -is [psobject] -and $null -ne $v.min -and $null -ne $v.max -and [double]$v.min -ge 0 -and [double]$v.min -gt [double]$v.max) {
                        $v.min = [Math]::Min([double]$v.min / 10, [double]$v.max)
                        $bilan.corriges += "$chemin $($p.Name)"
                    }
                }
            }
            [IO.File]::WriteAllText($dest, ($neuf | ConvertTo-Json -Depth 50), $utf8)
            $bilan.modifies++
        }
    }
} finally {
    foreach ($p in $jars.Values) { $p.ancien.Dispose(); $p.nous.Dispose() }
}
"Surcharges ecrites : $($bilan.modifies) modifiees, $($bilan.desactives) desactivees ; $($bilan.inchanges) identiques a l'original (ignorees)"
if ($bilan.absents) { 'Absents (non repris) :'; $bilan.absents | ForEach-Object { "  $_" } }
if ($bilan.corriges) { 'Minimum corrige (/10) :'; $bilan.corriges | ForEach-Object { "  $_" } }
