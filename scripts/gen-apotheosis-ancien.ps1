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
    [string[]]$Dossiers = @('apotheosis/affixes', 'apotheosis/rarities', 'apotheosis/gems', 'irons_apothic/affixes'),
    # Plancher : aucune valeur sous Plancher x la valeur d'origine du mod (choix de l'user le 2026-11-11 : 0.5 ;
    # l'ancien pack descendait a x0.1-0.4). 0 = valeurs de l'ancien pack telles quelles.
    [double]$Plancher = 0.5
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
# Meme forme par rarete : objet <-> objet (memes cles min/max/steps), nombre <-> nombre ; "steps" >= 1
function MemeForme($a, $b) {
    if ((Texte $a) -match '"steps":0[,}]') { return $false }
    foreach ($p in $a.PSObject.Properties) {
        $x = $p.Value; $y = $b.($p.Name)
        if ($null -eq $y) { continue }
        if (($x -is [psobject]) -ne ($y -is [psobject])) { return $false }
        if ($x -is [psobject]) {
            if ((@($x.PSObject.Properties.Name | Sort-Object) -join ',') -ne (@($y.PSObject.Properties.Name | Sort-Object) -join ',')) { return $false }
            if ($null -ne $x.steps -and [int]$x.steps -lt 1) { return $false }
        }
    }
    $true
}
# Parcourt les valeurs (y compris duree/amplificateur des effets) et corrige chaque intervalle {min, max, step} :
# - min > max d'un facteur 10 (fautes de frappe de l'ancien pack : murderous mythique 0.6 pour un max de 0.12...)
# - Apotheosis 8.9 exige un pas (0.01 par defaut s'il est absent) qui divise (max - min) ; la 8.5 ne verifiait pas -> pas valide le plus proche
function Corrige($o, $ou) {
    foreach ($p in @($o.PSObject.Properties)) {
        $v = $p.Value
        if (-not ($v -is [psobject])) { continue }
        if ($null -ne $v.min -and $null -ne $v.max -and $null -eq $v.steps) {
            if ([double]$v.min -ge 0 -and [double]$v.min -gt [double]$v.max) {
                $v.min = [Math]::Min([double]$v.min / 10, [double]$v.max)
                $bilan.corriges += "$ou.$($p.Name) (min /10)"
            }
            $ecart = [Math]::Abs([double]$v.max - [double]$v.min)
            $pas = if ($null -ne $v.step) { [Math]::Abs([double]$v.step) } else { 0.01 }
            if ($ecart -gt 0 -and $pas -gt 0) {
                $n = [Math]::Round($ecart / $pas, 6)
                if ($n -ne [Math]::Floor($n)) {
                    $k = [Math]::Max(1, [Math]::Round($ecart / $pas))
                    $nouveau = [Math]::Round($ecart / $k, 8)
                    if ($null -ne $v.step) { $v.step = $nouveau * [Math]::Sign([double]$v.step) } else { $v | Add-Member -NotePropertyName step -NotePropertyValue $nouveau }
                    $bilan.corriges += "$ou.$($p.Name) (pas $pas -> $nouveau)"
                }
            }
        } else { Corrige $v "$ou.$($p.Name)" }
    }
}
# Chaque nombre garde au moins |Plancher x valeur du jar| (signe conserve) ; "steps" (nombre de paliers Irons) et "cooldown" non touches.
# Les pas invalides apres coup sont corriges ensuite par Corrige.
function Remonte($o, $ref) {
    if (-not ($o -is [psobject]) -or -not ($ref -is [psobject])) { return }
    foreach ($p in @($o.PSObject.Properties)) {
        if ($p.Name -in 'steps', 'cooldown') { continue }
        $r = $ref.($p.Name)
        if ($null -eq $r) { continue }
        $v = $p.Value
        if ($v -is [psobject]) { Remonte $v $r }
        elseif (($v -is [ValueType]) -and ($r -is [ValueType]) -and $v -isnot [bool]) {
            $mini = [Math]::Abs([double]$r) * $Plancher
            if ([Math]::Abs([double]$v) -lt $mini) { $o.($p.Name) = [Math]::Round($mini * [Math]::Sign([double]$(if ([double]$v -ne 0) { $v } else { $r })), 6) }
        }
    }
}
# Gemmes : bonus compares a la meme position, seulement s'ils visent le meme type et le meme attribut
function RemonteGemmes($bon, $ref) {
    for ($i = 0; $i -lt [Math]::Min(@($bon).Count, @($ref).Count); $i++) {
        $a = @($bon)[$i]; $b = @($ref)[$i]
        if ($a.type -ne $b.type -or $a.attribute -ne $b.attribute) { continue }
        if ($a.values) { Remonte $a.values $b.values }
    }
}
$ordre = @('apotheosis:common', 'apotheosis:uncommon', 'apotheosis:rare', 'apotheosis:epic', 'apotheosis:mythic')
function Complete($vals, $jar, $ou) {
    $presentes = @($ordre | Where-Object { $vals.PSObject.Properties.Name -contains $_ })
    if (-not $presentes) { return }
    foreach ($r in $ordre) {
        if ($vals.PSObject.Properties.Name -contains $r -or -not ($jar.PSObject.Properties.Name -contains $r)) { continue }
        $i = [array]::IndexOf($ordre, $r)
        $src = @($presentes | Where-Object { [array]::IndexOf($ordre, $_) -lt $i } | Select-Object -Last 1)
        if (-not $src) { $src = @($presentes | Select-Object -First 1) }
        $copie = $vals.($src[0]) | ConvertTo-Json -Depth 50 | ConvertFrom-Json
        $vals | Add-Member -NotePropertyName $r -NotePropertyValue $copie
        $bilan.corriges += "$ou $r (rarete manquante <- $($src[0]))"
    }
}
# Poids a 0 partout dans "definition" (forme simple {weight, quality} ou par palier {haven: {weight, quality}, ...})
function Neutralise($o) {
    if (-not ($o -is [psobject])) { return }
    foreach ($p in @($o.PSObject.Properties)) {
        if ($p.Name -eq 'weight' -and $p.Value -isnot [psobject]) { $o.weight = 0 }
        elseif ($p.Name -eq 'quality' -and $p.Value -isnot [psobject]) { $o.quality = 0 }
        else { Neutralise $p.Value }
    }
}
# Intervalles {min, max[, step]} ramenes a 0 (les nombres seuls aussi)
function Zero($o) {
    foreach ($p in @($o.PSObject.Properties)) {
        $v = $p.Value
        if ($v -is [psobject]) {
            if ($null -ne $v.min -and $null -ne $v.max) { $v.min = 0; $v.max = 0; if ($null -ne $v.step) { $v.step = 0 } }
            else { Zero $v }
        } elseif ($v -is [double] -or $v -is [int] -or $v -is [long] -or $v -is [decimal]) { $o.($p.Name) = 0 }
    }
}
# Gemmes dont les bonus de l'ancien pack ne passent plus (purete manquante, effet sans amplifier)
$Gardees = @('data/apotheosis/gems/the_end/endersurge.json', 'data/apotheosis/gems/core/warlord.json')

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
                # Une condition false ne suffit pas : le fichier saute et le jeu reprend celui du jar. On neutralise donc
                # notre version : poids 0 (plus tire sur les nouveaux objets) et valeurs a 0 (plus d'effet sur les objets existants).
                $neuf = Lire $jars[$ns].nous $chemin
                if (-not $neuf) { $bilan.absents += "$chemin (desactive mais absent de notre jar)"; continue }
                Neutralise $neuf.definition
                if ($neuf.values) { Zero $neuf.values }
                [IO.File]::WriteAllText($dest, ($neuf | ConvertTo-Json -Depth 50), $utf8)
                $bilan.desactives++; continue
            }
            $orig = Lire $jars[$ns].ancien $chemin
            $neuf = Lire $jars[$ns].nous $chemin
            if (-not $orig -or -not $neuf) { $bilan.absents += "$chemin (jar ancien: $([bool]$orig), notre jar: $([bool]$neuf))"; Remove-Item $dest -ErrorAction SilentlyContinue; continue }
            $cles = @($sur.PSObject.Properties.Name | Where-Object { $reprises[$ns] -contains $_ -and (Texte $sur.$_) -ne (Texte $orig.$_) })
            if (-not $cles) { $bilan.inchanges++; continue }
            # Format des valeurs change depuis l'ancienne version (nombre <-> objet, "steps" a 0, bonus de gemmes) : on garde notre fichier.
            if ($cles -contains 'values' -and -not (MemeForme $sur.values $neuf.values)) { $bilan.absents += "$chemin (format des valeurs different, garde tel quel)"; Remove-Item $dest -ErrorAction SilentlyContinue; continue }
            if ($cles -contains 'bonuses' -and $Gardees -contains $chemin) { $bilan.absents += "$chemin (bonus incompatibles avec notre version, garde tel quel)"; Remove-Item $dest -ErrorAction SilentlyContinue; continue }
            foreach ($k in $cles) {
                if ($neuf.PSObject.Properties.Name -contains $k) { $neuf.$k = $sur.$k } else { $neuf | Add-Member -NotePropertyName $k -NotePropertyValue $sur.$k }
            }
            # Rarete presente dans notre jar mais absente de l'ancien pack : un objet de cette rarete avec cet affixe fait
            # planter le client (AttributeAffix.addModifiers, modif null). On reprend la valeur de la rarete la plus proche.
            if ($cles -contains 'values' -and $orig.values) { Complete $neuf.values $orig.values $chemin }
            if ($Plancher -gt 0) {
                if ($neuf.values) { Corrige $neuf.values "$chemin values" }   # fautes de frappe avant de remonter
                $ref = Lire $jars[$ns].nous $chemin
                if ($cles -contains 'values' -and $ref.values) { Remonte $neuf.values $ref.values }
                if ($cles -contains 'bonuses' -and $ref.bonuses) { RemonteGemmes $neuf.bonuses $ref.bonuses }
            }
            if ($neuf.values) { Corrige $neuf.values "$chemin values" }
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
