# Genere le datapack serveur "pack_lbc" (recettes croisees entre mods, sans KubeJS)
#   config/paxi/datapacks/pack_lbc -> charge automatiquement par Paxi (serveur et solo)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dp = Join-Path $root 'config\paxi\datapacks\pack_lbc'
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

# ---------- 4. Born in Chaos : apparitions reduites (~60 %), memes biomes/dimensions ----------
# Copie des biome_modifier d'origine dans scripts/data/borninchaos-spawns.json (a regenerer si le mod change).
# Plafond total et distance au spawn : config/incontrol/spawn.json (In Control!).
$bic = Get-Content (Join-Path $PSScriptRoot 'data\borninchaos-spawns.json') -Raw | ConvertFrom-Json
foreach ($p in $bic.PSObject.Properties) {
    $m = $p.Value
    $m.spawners.weight = [int][math]::Max(1, [math]::Round($m.spawners.weight * 0.6))
    W "data/born_in_chaos_v1/neoforge/biome_modifier/$($p.Name).json" $m
}

# ---------- 5. Create: New Age x Alex's Caves (refait d'apres l'addon 1.20.1 "newagealexscaves", licence MIT) ----------
# Barre d'uranium = combustible du reacteur New Age (meme energie que le combustible New Age)
W 'data/create_new_age/tags/item/nuclear/fuel.json' ([ordered]@{ replace = $false; values = @('alexscaves:uranium_rod') })
W 'data/create_new_age/tags/item/nuclear/energy_28800.json' ([ordered]@{ replace = $false; values = @('alexscaves:uranium_rod') })
# Blocs de neodyme des grottes magnetiques = aimants pour les bobines de generateur
$neo = @('alexscaves:block_of_azure_neodymium', 'alexscaves:block_of_scarlet_neodymium')
foreach ($k in 'block', 'item') {
    W "data/create_new_age/tags/$k/magnet.json" ([ordered]@{ replace = $false; values = $neo })
    W "data/create_new_age/tags/$k/magnet/force_3.json" ([ordered]@{ replace = $false; values = $neo })
}
# Recette alternative de l'aimant de redstone avec les lingots de neodyme
W 'data/pack_lbc/recipe/compat/redstone_magnet_neodymium.json' ([ordered]@{
    type = 'minecraft:crafting_shaped'; category = 'misc'
    pattern = @('I+I', '-#-', 'I+I')
    key = [ordered]@{ '#' = @{ tag = 'c:storage_blocks/redstone' }; '+' = @{ item = 'alexscaves:scarlet_neodymium_ingot' }; '-' = @{ item = 'alexscaves:azure_neodymium_ingot' }; 'I' = @{ tag = 'c:ingots/iron' } }
    result = @{ id = 'create_new_age:redstone_magnet'; count = 4 }
})
# Barre d'uranium a la chaine Create (bloc d'uranium : presse, plaque de fer, presse)
$inc = 'create_new_age:incomplete_fuel'
W 'data/pack_lbc/recipe/compat/uranium_rod_assembly.json' ([ordered]@{
    type = 'create:sequenced_assembly'; ingredient = @{ item = 'alexscaves:block_of_uranium' }; loops = 1
    results = @(@{ id = 'alexscaves:uranium_rod'; count = 2 })
    sequence = @(
        [ordered]@{ type = 'create:pressing'; ingredients = @(@{ item = $inc }); results = @(@{ id = $inc }) },
        [ordered]@{ type = 'create:deploying'; ingredients = @(@{ item = $inc }, @{ tag = 'c:plates/iron' }); results = @(@{ id = $inc }) },
        [ordered]@{ type = 'create:pressing'; ingredients = @(@{ item = $inc }); results = @(@{ id = $inc }) }
    )
    transitional_item = @{ id = $inc }
})

# ---------- 6. Portails Gateways to Eternity (fin de jeu combat) ----------
# Recompenses : butin des monstres a chaque vague + coffre de structure / Apotheosis a la fin (pas d'oeufs, pas de livres garantis).
# Noms : resource pack config/paxi/resourcepacks/pack_lbc_quests/assets/pack_lbc/lang/*.json (cle pack_lbc.<id>)
function Mob($id, $n) { [ordered]@{ type = 'gateways:standard'; entity = $id; count = $n } }
function Loot($id, $r) { [ordered]@{ type = 'gateways:entity_loot'; entity = $id; rolls = $r } }
function Chest($t, $r) { [ordered]@{ type = 'gateways:loot_table'; loot_table = $t; rolls = $r } }
function Xp($n) { [ordered]@{ type = 'gateways:experience'; experience = $n; orb_size = 10 } }
function Affix($n, $rar) { [ordered]@{ type = 'gateways:counted'; count = $n; reward = [ordered]@{ type = 'apotheosis:affix_item'; rarities = @($rar) } } }
function Gem($n, $pur) { [ordered]@{ type = 'gateways:counted'; count = $n; reward = [ordered]@{ type = 'apotheosis:gem'; purities = @($pur) } } }
function Hp($v) { [ordered]@{ attribute = 'generic.max_health'; operation = 'add_multiplied_total'; value = $v } }
function Wave($mobs, $hp, $time) {
    $rw = @(); foreach ($m in $mobs) { $rw += Loot $m.entity ([int]($m.count * 3)) }
    $mods = @(); if ($hp -gt 0) { $mods += Hp $hp }
    [ordered]@{ entities = @($mobs); modifiers = $mods; rewards = $rw; max_wave_time = $time; setup_time = 160 }
}
function Gate($id, $size, $color, $waves, $rewards, $lives, $pattern, $key) {
    W "data/pack_lbc/gateways/$id.json" ([ordered]@{
        type = 'gateways:normal'; size = $size; color = $color; waves = @($waves); rewards = @($rewards)
        failures = @([ordered]@{ type = 'gateways:explosion'; strength = 3; fire = $false; block_damage = $false })
        rules = [ordered]@{ lives = $lives; requires_nearby_player = $true; leash_range = 32.0; remove_mobs_on_failure = $true }
    })
    W "data/pack_lbc/recipe/gateways/$id.json" ([ordered]@{
        'neoforge:conditions' = @(@{ type = 'neoforge:mod_loaded'; modid = 'gateways' })
        type = 'minecraft:crafting_shaped'; category = 'misc'; group = 'pack_lbc_gateways'; pattern = $pattern; key = $key
        result = [ordered]@{ id = 'gateways:gate_pearl'; count = 1; components = @{ 'gateways:gateway' = "pack_lbc:$id" } }
    })
}
$bic = 'born_in_chaos_v1'
# Nuit sans fin (debut)
Gate 'nuit_sans_fin' 'small' '#4A5D8F' @(
    (Wave @((Mob 'minecraft:zombie' 5), (Mob 'minecraft:skeleton' 3)) 0 1200),
    (Wave @((Mob 'minecraft:zombie' 5), (Mob 'minecraft:spider' 4), (Mob 'minecraft:creeper' 2)) 0.1 1400),
    (Wave @((Mob 'minecraft:skeleton' 5), (Mob 'minecraft:witch' 2), (Mob 'minecraft:creeper' 3)) 0.2 1600),
    (Wave @((Mob 'minecraft:zombie' 6), (Mob 'minecraft:skeleton' 5), (Mob 'minecraft:witch' 2), (Mob 'minecraft:spider' 4)) 0.3 2000)
) @((Chest 'minecraft:chests/simple_dungeon' 6), (Xp 300)) 3 @('RGR', 'SES', 'RBR') ([ordered]@{ R = @{ item = 'minecraft:rotten_flesh' }; G = @{ item = 'minecraft:gunpowder' }; S = @{ item = 'minecraft:string' }; B = @{ tag = 'c:bones' }; E = @{ tag = 'c:ender_pearls' } })
# Le Sabbat des citrouilles (Born in Chaos)
Gate 'sabbat_citrouilles' 'medium' '#E07B1A' @(
    (Wave @((Mob "$($bic):pumpkin_dunce" 3), (Mob "$($bic):mr_pumpkin" 3)) 0 1400),
    (Wave @((Mob "$($bic):mrs_pumpkin" 2), (Mob "$($bic):senor_pumpkin" 3), (Mob "$($bic):pumpkin_dunce" 3)) 0.1 1600),
    (Wave @((Mob "$($bic):pumpkin_bruiser" 2), (Mob "$($bic):mr_pumpkin" 4), (Mob "$($bic):senor_pumpkin" 2)) 0.2 1800),
    (Wave @((Mob "$($bic):sir_pumpkinhead_without_horse" 1), (Mob "$($bic):pumpkin_bruiser" 2), (Mob "$($bic):pumpkin_dunce" 3)) 0.25 2400)
) @((Affix 2 'apotheosis:rare'), (Gem 3 'flawed'), (Xp 600)) 3 @('JGJ', 'GEG', 'JGJ') ([ordered]@{ J = @{ item = 'minecraft:jack_o_lantern' }; G = @{ tag = 'c:ingots/gold' }; E = @{ item = 'minecraft:ender_eye' } })
# Les Morts sans repos (Born in Chaos)
Gate 'morts_sans_repos' 'medium' '#7FA88C' @(
    (Wave @((Mob "$($bic):decaying_zombie" 4), (Mob "$($bic):decrepit_skeleton" 3)) 0 1400),
    (Wave @((Mob "$($bic):restless_spirit" 3), (Mob "$($bic):zombie_bruiser" 2), (Mob "$($bic):decrepit_skeleton" 3)) 0.1 1600),
    (Wave @((Mob "$($bic):bonescaller" 2), (Mob "$($bic):skeleton_thrasher" 2), (Mob "$($bic):restless_spirit" 3)) 0.2 1800),
    (Wave @((Mob "$($bic):supreme_bonescaller" 1), (Mob "$($bic):bonescaller" 2), (Mob "$($bic):decaying_zombie" 4)) 0.25 2400)
) @((Gem 4 'normal'), (Affix 1 'apotheosis:rare'), (Xp 600)) 3 @('BSB', 'SES', 'BSB') ([ordered]@{ B = @{ item = 'minecraft:bone_block' }; S = @{ item = 'minecraft:soul_sand' }; E = @{ item = 'minecraft:ender_eye' } })
# L'Echo des profondeurs (Deep Dark / Deeper and Darker)
Gate 'echo_profondeurs' 'large' '#0F5E63' @(
    (Wave @((Mob 'deeperdarker:sculk_snapper' 4), (Mob 'deeperdarker:sculk_leech' 4)) 0.1 1600),
    (Wave @((Mob 'deeperdarker:shattered' 3), (Mob 'deeperdarker:sculk_centipede' 2)) 0.15 1800),
    (Wave @((Mob 'deeperdarker:stalker' 2), (Mob 'deeperdarker:shattered' 3), (Mob 'deeperdarker:sculk_snapper' 3)) 0.2 2000),
    (Wave @((Mob 'minecraft:warden' 1), (Mob 'deeperdarker:shattered' 2)) 0 3000)
) @((Chest 'minecraft:chests/ancient_city' 4), (Chest 'deeperdarker:chests/ancient_temple_apex' 1), (Xp 1000)) 2 @('ESE', 'CPC', 'ESE') ([ordered]@{ E = @{ item = 'minecraft:echo_shard' }; S = @{ item = 'deeperdarker:soul_crystal' }; C = @{ item = 'minecraft:sculk_catalyst' }; P = @{ item = 'minecraft:ender_eye' } })
# Les Gardiens de la sorcellerie (Iron's Spells)
Gate 'gardiens_sorcellerie' 'medium' '#9B4DDB' @(
    (Wave @((Mob 'irons_spellbooks:cultist' 3), (Mob 'irons_spellbooks:magehunter_vindicator' 2)) 0 1600),
    (Wave @((Mob 'irons_spellbooks:pyromancer' 2), (Mob 'irons_spellbooks:cryomancer' 2), (Mob 'irons_spellbooks:cultist' 2)) 0.1 1800),
    (Wave @((Mob 'irons_spellbooks:necromancer' 2), (Mob 'irons_spellbooks:apothecarist' 1), (Mob 'irons_spellbooks:magehunter_vindicator' 2)) 0.2 2000),
    (Wave @((Mob 'irons_spellbooks:archevoker' 2), (Mob 'irons_spellbooks:pyromancer' 1), (Mob 'irons_spellbooks:cryomancer' 1)) 0.25 2600)
) @((Chest 'irons_spellbooks:chests/additional_good_loot' 4), (Chest 'irons_spellbooks:chests/citadel/citadel_tomes' 1), (Xp 800)) 3 @('ALA', 'IEI', 'ALA') ([ordered]@{ A = @{ item = 'irons_spellbooks:arcane_essence' }; L = @{ tag = 'c:gems/lapis' }; I = @{ item = 'irons_spellbooks:common_ink' }; E = @{ item = 'minecraft:ender_eye' } })
# La Citadelle de l'Ender (End / Cataclysm)
Gate 'citadelle_ender' 'large' '#C25BE6' @(
    (Wave @((Mob 'minecraft:enderman' 4), (Mob 'cataclysm:endermaptera' 3)) 0.1 1600),
    (Wave @((Mob 'minecraft:shulker' 3), (Mob 'minecraft:enderman' 3), (Mob 'cataclysm:endermaptera' 3)) 0.15 1800),
    (Wave @((Mob 'cataclysm:ender_golem' 1), (Mob 'minecraft:enderman' 4)) 0.1 2400),
    (Wave @((Mob 'cataclysm:ender_golem' 2), (Mob 'minecraft:shulker' 3), (Mob 'cataclysm:endermaptera' 4)) 0.2 3000)
) @((Chest 'minecraft:chests/end_city_treasure' 4), (Gem 3 'flawless'), (Affix 1 'apotheosis:epic'), (Xp 1200)) 2 @('SCS', 'CEC', 'SCS') ([ordered]@{ S = @{ item = 'minecraft:shulker_shell' }; C = @{ item = 'minecraft:popped_chorus_fruit' }; E = @{ item = 'minecraft:ender_eye' } })
# Le Defi des Seigneurs (fin de jeu) : trophee unique
$trophy = [ordered]@{ type = 'gateways:stack'; stack = [ordered]@{ id = 'minecraft:nether_star'; count = 1; components = [ordered]@{
    'minecraft:custom_name' = [ordered]@{ text = 'Trophée du Défi des Seigneurs'; color = 'gold'; italic = $false }
    'minecraft:lore' = @([ordered]@{ text = 'Remis aux vainqueurs du Défi des Seigneurs.'; color = 'gray'; italic = $false })
    'minecraft:enchantment_glint_override' = $true; 'minecraft:rarity' = 'epic' } } }
Gate 'defi_seigneurs' 'large' '#D4AF37' @(
    (Wave @((Mob 'cataclysm:ignited_revenant' 2), (Mob "$($bic):fallen_chaos_knight" 2)) 0.2 2400),
    (Wave @((Mob 'cataclysm:kobolediator' 1), (Mob 'cataclysm:wadjet' 1), (Mob "$($bic):lifestealer" 1)) 0.25 2800),
    (Wave @((Mob 'irons_spellbooks:archevoker' 2), (Mob "$($bic):supreme_bonescaller" 1), (Mob 'cataclysm:ignited_berserker' 2)) 0.3 3000),
    (Wave @((Mob 'cataclysm:the_prowler' 1), (Mob 'cataclysm:ignited_revenant' 2), (Mob "$($bic):fallen_chaos_knight" 2)) 0.35 3600)
) @((Affix 2 'apotheosis:mythic'), (Gem 3 'perfect'), $trophy, (Xp 3000)) 2 @('IWI', 'DND', 'IWI') ([ordered]@{ I = @{ item = 'cataclysm:ignitium_ingot' }; W = @{ item = 'cataclysm:witherite_ingot' }; D = @{ item = 'minecraft:diamond_block' }; N = @{ item = 'minecraft:nether_star' } })

$count = (Get-ChildItem $dp -Recurse -File).Count
Write-Host "Datapack genere : $dp ($count fichiers)"
