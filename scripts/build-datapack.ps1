# Genere le datapack serveur "pack_lbc" (recettes croisees entre mods, sans KubeJS)
#   datapacks/pack_lbc  -> copie par build-server.ps1 dans world/datapacks/
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dp = Join-Path $root 'datapacks\pack_lbc'
if (Test-Path $dp) { Remove-Item $dp -Recurse -Force }
$enc = New-Object Text.UTF8Encoding($false)
function W($rel, $obj) {
    $p = Join-Path $dp $rel
    New-Item -ItemType Directory -Force (Split-Path $p) | Out-Null
    [IO.File]::WriteAllText($p, ($obj | ConvertTo-Json -Depth 20), $enc)
}
W 'pack.mcmeta' @{ pack = @{ pack_format = 48; description = 'pack_LBC : recettes croisees (recyclage Create, magie, butin)' } }

# ---------- 1. Recyclage d'equipement aux Roues de Broyage ----------
function Crush($name, $item, $results) {
    W "data/pack_lbc/recipe/crushing/recycle/$name.json" ([ordered]@{ type = 'create:crushing'; ingredients = @(@{ item = $item }); processing_time = 200; results = $results })
}
# quantite de lingots/gemmes dans chaque piece
$vanilla = [ordered]@{ helmet = 5; chestplate = 8; leggings = 7; boots = 4; sword = 2; pickaxe = 3; axe = 3; shovel = 1; hoe = 2 }
$ss = 'chakram','claymore','cutlass','glaive','greataxe','greathammer','halberd','katana','longsword','rapier','sai','scythe','spear','twinblade','warglaive'
function Pieces() { $l = @(); foreach ($k in $vanilla.Keys) { $l += , @("minecraft:{0}_$k", $vanilla[$k]) }; foreach ($w in $ss) { $l += , @("simplyswords:{0}_$w", 2) }; $l }
foreach ($p in Pieces) {
    $n = $p[1]
    # fer et or : ~60 % du metal en pepites
    foreach ($m in @(@('iron', 'minecraft:iron_nugget'), @('golden', 'minecraft:gold_nugget'))) {
        $id = $p[0] -f $m[0]; if ($id -like 'simplyswords:golden_*') { $id = $id -replace 'golden_', 'gold_' }
        $nug = [math]::Max(3, [math]::Floor($n * 9 * 0.6))
        Crush ($id -replace ':', '_') $id @(@{ id = $m[1]; count = [int]$nug }, @{ id = 'create:experience_nugget'; chance = 0.5 })
    }
    # diamant : la moitie des diamants (+1 a 50 %)
    $id = $p[0] -f 'diamond'
    $res = @(); $d = [math]::Floor($n / 2); if ($d -gt 0) { $res += @{ id = 'minecraft:diamond'; count = [int]$d } }; $res += @{ id = 'minecraft:diamond'; chance = 0.5 }; $res += @{ id = 'create:experience_nugget'; chance = 0.75 }
    Crush ($id -replace ':', '_') $id $res
    # netherite : 1 fragment (+1 a 50 %) et les diamants
    $id = $p[0] -f 'netherite'
    $res = @(@{ id = 'minecraft:netherite_scrap'; count = 1 }, @{ id = 'minecraft:netherite_scrap'; chance = 0.5 }); if ($d -gt 0) { $res += @{ id = 'minecraft:diamond'; count = [int]$d } }; $res += @{ id = 'create:experience_nugget'; count = 2 }
    Crush ($id -replace ':', '_') $id $res
}
# cotte de mailles
foreach ($k in 'helmet', 'chestplate', 'leggings', 'boots') { Crush "chainmail_$k" "minecraft:chainmail_$k" @(@{ id = 'minecraft:iron_nugget'; count = 9 }, @{ id = 'create:experience_nugget'; chance = 0.5 }) }

# ---------- 2. Essence Arcanique d'Iron's Spells au Melangeur surchauffe ----------
W 'data/pack_lbc/recipe/mixing/arcane_essence.json' ([ordered]@{
    type = 'create:mixing'; heat_requirement = 'superheated'
    ingredients = @(@{ item = 'minecraft:lapis_lazuli' }, @{ item = 'minecraft:lapis_lazuli' }, @{ item = 'minecraft:blaze_powder' }, @{ item = 'minecraft:blaze_powder' }, @{ item = 'create:experience_nugget' })
    results = @(@{ id = 'irons_spellbooks:arcane_essence'; count = 4 })
})

# ---------- 3. Butin Create dans les coffres de village ----------
W 'data/pack_lbc/loot_table/chests/create_village_bonus.json' ([ordered]@{
    type = 'minecraft:chest'
    pools = @(@{
        rolls = @{ type = 'minecraft:uniform'; min = 0; max = 2 }
        entries = @(
            @{ type = 'minecraft:item'; name = 'create:andesite_alloy'; weight = 10; functions = @(@{ function = 'minecraft:set_count'; count = @{ type = 'minecraft:uniform'; min = 2; max = 8 } }) },
            @{ type = 'minecraft:item'; name = 'create:shaft'; weight = 8; functions = @(@{ function = 'minecraft:set_count'; count = @{ type = 'minecraft:uniform'; min = 2; max = 6 } }) },
            @{ type = 'minecraft:item'; name = 'create:cogwheel'; weight = 6; functions = @(@{ function = 'minecraft:set_count'; count = @{ type = 'minecraft:uniform'; min = 1; max = 4 } }) },
            @{ type = 'minecraft:item'; name = 'create:belt_connector'; weight = 5; functions = @(@{ function = 'minecraft:set_count'; count = @{ type = 'minecraft:uniform'; min = 1; max = 3 } }) },
            @{ type = 'minecraft:item'; name = 'create:zinc_ingot'; weight = 5; functions = @(@{ function = 'minecraft:set_count'; count = @{ type = 'minecraft:uniform'; min = 1; max = 4 } }) },
            @{ type = 'minecraft:item'; name = 'create:gearbox'; weight = 3 },
            @{ type = 'minecraft:item'; name = 'create:water_wheel'; weight = 2 },
            @{ type = 'minecraft:empty'; weight = 12 }
        )
    })
})
$tables = 'minecraft:chests/village/village_toolsmith', 'minecraft:chests/village/village_weaponsmith', 'minecraft:chests/village/village_armorer', 'minecraft:chests/village/village_mason', 'minecraft:chests/village/village_plains_house', 'minecraft:chests/village/village_taiga_house', 'minecraft:chests/village/village_savanna_house', 'minecraft:chests/village/village_desert_house', 'minecraft:chests/village/village_snowy_house', 'ctov:chests/village/village_smith'
$entries = @()
foreach ($t in $tables) {
    $n = 'create_village_' + (($t -split '[:/]')[-1])
    W "data/pack_lbc/loot_modifiers/$n.json" ([ordered]@{ type = 'neoforge:add_table'; conditions = @(@{ condition = 'neoforge:loot_table_id'; loot_table_id = $t }); table = 'pack_lbc:chests/create_village_bonus' })
    $entries += "pack_lbc:$n"
}
W 'data/neoforge/loot_modifiers/global_loot_modifiers.json' ([ordered]@{ replace = $false; entries = $entries })

$count = (Get-ChildItem $dp -Recurse -File).Count
Write-Host "Datapack genere : $dp ($count fichiers)"
