# Genere les 4 caisses de recompense FTB Quests (config/ftbquests/quests/reward_tables) + leurs titres (tr/_reward_tables.lang.txt).
# Poids = pourcentage par tirage (chaque caisse fait 100). Recompenses "commande" : tables pack_lbc:caisses/* (build-datapack section 22)
# et cartes pack_lbc:cartes/palier_N (section 14). Ensuite : build-lang.ps1 (titres dans fr_fr.snbt).
$s = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -Path "$s\Snbt.cs", "$s\QConv.cs"
$enc = New-Object Text.UTF8Encoding($false)
$base = Join-Path (Split-Path -Parent (Split-Path -Parent $s)) 'config\ftbquests\quests'
$idFile = "$s\ids\_caisses.json"
$ids = [ordered]@{}
if (Test-Path $idFile) { (Get-Content $idFile -Raw | ConvertFrom-Json).PSObject.Properties | ForEach-Object { $ids[$_.Name] = $_.Value } }
$used = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($f in Get-ChildItem "$base\chapters", "$base\reward_tables" -Filter *.snbt) { foreach ($m in [regex]::Matches([IO.File]::ReadAllText($f.FullName), '"([0-9A-F]{16})"')) { [void]$used.Add($m.Groups[1].Value) } }
# 1re execution : reprendre les ids des recompenses deja presentes (cle = caisse:objet)
foreach ($f in Get-ChildItem "$base\reward_tables" -Filter *.snbt) {
    foreach ($m in [regex]::Matches([IO.File]::ReadAllText($f.FullName), '(?s)\t\t\{\n\t\t\tcount: \d+\n\t\t\tid: "([0-9A-F]{16})"\n\t\t\titem: \{.*?id: "([^"]+)"')) {
        $k = "$($f.BaseName):$($m.Groups[2].Value)"; if (-not $ids.Contains($k)) { $ids[$k] = $m.Groups[1].Value }
    }
}
function Id($key) { if ($ids.Contains($key)) { return $ids[$key] }; do { $n = [QConv]::NewId() } while ($used.Contains($n)); [void]$used.Add($n); $ids[$key] = $n; $n }
function I($item, $count, $w, $comps) { @{ item = $item; count = $count; w = $w; comps = $comps } }
function C($key, $table, $icon, $title, $w) { @{ key = $key; table = $table; icon = $icon; title = $title; w = $w } }
$explo = 'treasurebags:treasure_bag'; $exploC = @{ 'treasurebags:bag_type' = 'pack_lbc:explorateur' }

$caisses = [ordered]@{
    commune = @{ id = '4363F0DDE61F37E2'; nom = 'Caisse commune'; color = 11184810; glow = $false; size = 2; order = 0; r = @(
        (I 'minecraft:cooked_beef' 16 9), (I 'minecraft:iron_ingot' 8 10), (I 'create:andesite_alloy' 16 10), (I 'minecraft:copper_ingot' 16 8),
        (I 'minecraft:golden_carrot' 8 6), (I 'minecraft:redstone' 16 6), (I 'minecraft:experience_bottle' 6 7), (I 'create:shaft' 16 5),
        (I 'create:cogwheel' 8 6), (I 'create:zinc_ingot' 8 6), (I 'minecraft:lapis_lazuli' 12 4), (I 'create:copper_sheet' 8 4),
        (I 'waystones:warp_dust' 8 4), (I 'apotheosis:gem_dust' 8 3), (I 'irons_spellbooks:arcane_essence' 6 3), (I 'farmersdelight:rice' 16 2),
        (I 'farmersdelight:tomato' 16 2), (I 'irons_spellbooks:common_ink' 2 3), (I 'relics:relic_experience_bottle' 1 2)) }
    rare = @{ id = '5BF2DB02CBF4D490'; nom = 'Caisse rare'; color = 3381759; glow = $false; size = 2; order = 1; r = @(
        (I 'minecraft:diamond' 3 7), (I 'minecraft:gold_ingot' 16 7), (I 'create:brass_ingot' 16 8), (I 'minecraft:emerald' 8 5),
        (I 'minecraft:ender_pearl' 8 5), (I 'minecraft:golden_apple' 2 5), (I 'minecraft:experience_bottle' 16 5), (I 'create:precision_mechanism' 2 5),
        (I 'create:electron_tube' 8 5), (I 'minecraft:blaze_rod' 8 4), (I 'apotheosis:gem_dust' 24 4), (I 'irons_spellbooks:arcane_essence' 16 4),
        (I 'waystones:warp_stone' 1 3), (I 'waystones:return_scroll' 3 3), (I 'irons_spellbooks:uncommon_ink' 2 3), (I 'betterinventory:stack_upgrade_1' 2 3),
        (I 'minecraft:name_tag' 1 2), (I 'minecraft:saddle' 1 2), (I 'create:blaze_burner' 1 2), (I 'betterinventory:backpack_2' 1 2),
        (I 'torchmaster:megatorch' 1 1), (I 'reliquified_artifacts:mimi_dust' 1 2), (I $explo 1 4 $exploC),
        (C 'carte_1' 'pack_lbc:cartes/palier_1' 'minecraft:filled_map' 'Carte de structure (palier 1)' 5),
        (C 'parchemin_rare' 'pack_lbc:caisses/parchemin_rare' 'irons_spellbooks:scroll' 'Parchemin de sort' 4)) }
    epique = @{ id = '396C1887C2F887B7'; nom = 'Caisse épique'; color = 11141290; glow = $true; size = 2; order = 2; r = @(
        (I 'minecraft:diamond' 8 9), (I 'minecraft:netherite_scrap' 2 8), (I 'minecraft:experience_bottle' 32 6), (I 'minecraft:ancient_debris' 2 5),
        (I 'minecraft:totem_of_undying' 1 5), (I 'minecraft:shulker_shell' 2 5), (I 'create:precision_mechanism' 6 4), (I 'apotheosis:sigil_of_socketing' 1 3),
        (I 'irons_spellbooks:rare_ink' 2 4), (I 'minecraft:enchanted_golden_apple' 1 4), (I 'create:sturdy_sheet' 8 4), (I 'irons_spellbooks:mithril_scrap' 2 4),
        (I 'betterinventory:stack_upgrade_2' 1 4), (I 'waystones:warp_scroll' 4 4), (I 'minecraft:heart_of_the_sea' 1 3), (I 'apotheosis:sigil_of_withdrawal' 1 2),
        (I 'betterinventory:backpack_3' 1 3),
        (C 'carte_2' 'pack_lbc:cartes/palier_2' 'minecraft:filled_map' 'Carte de structure (palier 2)' 6),
        (C 'equipement_epique' 'pack_lbc:caisses/equipement_epique' 'minecraft:diamond_sword' 'Équipement épique à affixes' 6),
        (C 'relique' 'pack_lbc:caisses/relique' 'relics:ring_of_the_seven_deadly_sins' 'Relique au hasard' 5),
        (C 'parchemin_epique' 'pack_lbc:caisses/parchemin_epique' 'irons_spellbooks:scroll' 'Parchemin de sort (puissant)' 6)) }
    legendaire = @{ id = '7D221ADF1898E942'; nom = 'Caisse légendaire'; color = 16755200; glow = $true; size = 3; order = 3; r = @(
        (I 'minecraft:netherite_ingot' 2 12), (I 'minecraft:enchanted_golden_apple' 3 9), (I 'minecraft:totem_of_undying' 2 9), (I 'minecraft:diamond_block' 2 9),
        (I 'minecraft:nether_star' 1 8), (I 'irons_spellbooks:epic_ink' 2 6), (I 'apotheosis:sigil_of_enhancement' 1 4), (I 'betterinventory:backpack_4' 1 6),
        (I 'irons_spellbooks:legendary_ink' 1 4), (I 'apotheosis:sigil_of_supremacy' 1 2), (I 'betterinventory:backpack_5' 1 2),
        (C 'equipement_mythique' 'pack_lbc:caisses/equipement_mythique' 'minecraft:netherite_sword' 'Équipement mythique à affixes' 10),
        (C 'perle_portail' 'pack_lbc:caisses/perle_portail' 'gateways:gate_pearl' 'Perle de portail (Gateways)' 10),
        (C 'parchemin_legendaire' 'pack_lbc:caisses/parchemin_legendaire' 'irons_spellbooks:scroll' 'Parchemin de sort (légendaire)' 9)) }
}

# Le tirage se fait dans une table de butin vanilla (pack_lbc:caisses_quete/<caisse>, build-datapack section 26) : FTB ne tire
# qu'un nombre fixe de recompenses, la table vanilla 2 a 5 (2 + binomiale 3 x 40 %). La caisse FTB ne lance plus qu'une commande
# silencieuse : plus de notification par objet (icones souvent mal rendues). Contenu ecrit dans scripts/data/caisses_quetes.json.
$lang = New-Object Text.StringBuilder
$data = [ordered]@{}
foreach ($n in $caisses.Keys) {
    $c = $caisses[$n]
    $total = ($c.r | ForEach-Object { $_.w } | Measure-Object -Sum).Sum
    if ($total -ne 100) { Write-Warning "$n : total des poids = $total (attendu 100)" }
    [void]$lang.Append("`treward_table.$($c.id).title: `"$($c.nom)`"`n")
    $data[$n] = @($c.r | ForEach-Object { if ($_.table) { [ordered]@{ table = $_.table; w = $_.w } } else { [ordered]@{ item = $_.item; count = $_.count; w = $_.w; comps = $_.comps } } })
    $rid = Id "${n}:cmd:tirage"
    $sb = New-Object Text.StringBuilder
    [void]$sb.Append("{`n`tid: `"$($c.id)`"`n`tloot_crate: {`n`t`tcolor: $($c.color)`n`t`tdrops: {`n`t`t`tboss: 0`n`t`t`tmonster: 0`n`t`t`tpassive: 0`n`t`t}`n")
    if ($c.glow) { [void]$sb.Append("`t`tglow: true`n") }
    [void]$sb.Append("`t`titem_name: `"$($c.nom)`"`n`t`tstring_id: `"$n`"`n`t}`n`tloot_size: 1`n`torder_index: $($c.order)`n`trewards: [`n")
    [void]$sb.Append("`t`t{`n`t`t`tcommand: `"/loot give {p} loot pack_lbc:caisses_quete/$n`"`n`t`t`ticon: {`n`t`t`t`tcount: 1`n`t`t`t`tid: `"ftbquests:lootcrate`"`n`t`t`t}`n`t`t`tid: `"$rid`"`n`t`t`tpermission_level: 2`n`t`t`tsilent: true`n`t`t`ttype: `"command`"`n`t`t`tweight: 1.0f`n`t`t}`n")
    [void]$lang.Append("`treward.$rid.title: `"$($c.nom) : 2 à 5 récompenses`"`n")
    [void]$sb.Append("`t]`n}`n")
    [void][Snbt]::Parse($sb.ToString())
    [IO.File]::WriteAllText("$base\reward_tables\$n.snbt", $sb.ToString(), $enc)
    "$n : $($c.r.Count) recompenses possibles, 2 a 5 tirages"
}
[IO.File]::WriteAllText((Join-Path (Split-Path -Parent $s) 'data\caisses_quetes.json'), ($data | ConvertTo-Json -Depth 6), $enc)
[IO.File]::WriteAllText("$s\tr\_reward_tables.lang.txt", $lang.ToString(), $enc)
[IO.File]::WriteAllText($idFile, ($ids | ConvertTo-Json), $enc)
