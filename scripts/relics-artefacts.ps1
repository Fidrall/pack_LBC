# Reglage du butin des artefacts (Reliquified Artifacts) : les plus puissants seulement dans les coffres tresor, comme les reliques de Relics.
# Entree : config/reliquified_artifacts/relics/*.yaml (generes par le mod au 1er lancement, copies dans le pack). A relancer apres une MAJ du mod
# qui regenererait ces fichiers. Le reste du fichier (capacites, niveaux) n'est pas touche, seulement la section lootData (en fin de fichier).
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root 'config\reliquified_artifacts\relics'
$enc = New-Object Text.UTF8Encoding($false)
$tresor = 'treasure|tresure|vault|elite|epic|boss|secret|hidden|legendary|reward_rare|reward_unique|reward_ominous'
$puissants = @('cloud_in_a_bottle', 'crystal_heart', 'warp_drive', 'obsidian_skull', 'chorus_totem', 'vampiric_glove', 'power_glove', 'fire_gauntlet', 'scarf_of_invisibility', 'helium_flamingo')
function Entrees($t) {
  $ld = $t.Substring($t.IndexOf('lootData:'))
  foreach ($b in [regex]::Matches($ld, '(?s)-[ \t]+(biomes:.*?)(?=\n[ \t]*-[ \t]+biomes:|\z)')) {
    $s = $b.Groups[1].Value
    $liste = { param($cle) $m = [regex]::Match($s, "$cle\:[ \t]*\r?\n((?:[ \t]*-[ \t]*[^\r\n]+\r?\n?)+)"); @([regex]::Matches($m.Groups[1].Value, '-[ \t]*([^\r\n]+)') | ForEach-Object { $_.Groups[1].Value.Trim().Trim("'") }) }
    [ordered]@{ biomes = @(& $liste 'biomes'); dimensions = @(& $liste 'dimensions'); tables = @(& $liste 'tables'); weight = [int][regex]::Match($s, 'weight:\s*(\d+)').Groups[1].Value }
  }
}
function Yaml($entrees) {
  $l = @('lootData:', '    # List of conditions for obtaining the relic. Supports both direct ID specification and regular expressions.', '    entries:')
  foreach ($e in $entrees) {
    $l += '    -   biomes:'; $e.biomes | ForEach-Object { $l += "        - '$_'" }
    $l += '        dimensions:'; $e.dimensions | ForEach-Object { $l += "        - '$_'" }
    $l += '        tables:'; $e.tables | ForEach-Object { $l += "        - '$_'" }
    $l += "        weight: $($e.weight)"
  }
  ($l -join "`n") + "`n"
}
foreach ($n in $puissants) {
  $f = Join-Path $dir "$n.yaml"; $t = [IO.File]::ReadAllText($f)
  $apres = $t.Substring($t.IndexOf('lootData:'))
  if ($apres -split "`n" | Select-Object -Skip 1 | Where-Object { $_ -match '^\S' }) { throw "$n : lootData n'est pas en fin de fichier" }
  $nouv = foreach ($e in (Entrees $t)) {
    $tables = foreach ($tb in $e.tables) {
      if ($tb -match '^\[\\w\]\+:chests\\/\[\\w_\\/\]\*\[\\w\]\+\[\\w_\\/\]\*$') { "[\w]+:chests\/[\w_\/]*($tresor)[\w_\/]*" }                 # n'importe quel coffre -> coffres tresor
      elseif ($tb -match '^\[\\w\]\+:chests\\/\[\\w_\\/\]\*\((.+)\)\[\\w_\\/\]\*$') { "[\w]+:chests\/(?=[\w_\/]*($($Matches[1])))(?=[\w_\/]*($tresor))[\w_\/]*" }  # theme -> theme ET tresor
    }
    $e.tables = @(@($tables) + 'minecraft:chests\/(ancient_city|stronghold_library)' | Select-Object -Unique)
    $e.biomes = @('.*')     # tresor + biome precis serait quasi introuvable : le theme reste porte par la table (Nether, End, mine...)
    $e
  }
  [IO.File]::WriteAllText($f, $t.Substring(0, $t.IndexOf('lootData:')) + (Yaml $nouv), $enc)
  "$n : $(@($nouv).Count) entree(s) -> coffres tresor"
}
# Steak eternel : aucune entree dans le mod (introuvable en coffre) -> coffre quelconque, poids moyen
$f = Join-Path $dir 'eternal_steak.yaml'; $t = [IO.File]::ReadAllText($f)
$i = $t.IndexOf('lootData:')
if ($i -ge 0 -and @(Entrees $t).Count -eq 0) {
  [IO.File]::WriteAllText($f, $t.Substring(0, $i) + (Yaml @([ordered]@{ biomes = @('.*'); dimensions = @('.*'); tables = @('[\w]+:chests\/[\w_\/]*[\w]+[\w_\/]*'); weight = 300 })), $enc)
  'eternal_steak : entree ajoutee (tout coffre, poids 300)'
}
