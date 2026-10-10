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
W 'pack.mcmeta' @{ pack = @{ pack_format = 48; description = 'Recettes et butin du pack' } }


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
$glmVillages = @()
foreach ($t in $tables) {
    $n = 'create_village_' + (($t -split '[:/]')[-1])
    W "data/pack_lbc/loot_modifiers/$n.json" ([ordered]@{ type = 'neoforge:add_table'; conditions = @(@{ condition = 'neoforge:loot_table_id'; loot_table_id = $t }); table = 'pack_lbc:chests/create_village_bonus' })
    $glmVillages += "pack_lbc:$n"
}

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
function Chest($t, $r) { [ordered]@{ type = 'gateways:loot_table'; loot_table = $t; rolls = $r; desc = 'reward.pack_lbc.' + ($t -replace '[:/]', '.') } }
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
        rules = [ordered]@{ lives = $lives; requires_nearby_player = $true; leash_range = 100.0; remove_mobs_on_failure = $true }
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
    'minecraft:custom_name' = '{"text":"Trophée du Défi des Seigneurs","color":"gold","italic":false}'
    'minecraft:lore' = @('{"text":"Remis aux vainqueurs du Défi des Seigneurs.","color":"gray","italic":false}')
    'minecraft:enchantment_glint_override' = $true; 'minecraft:rarity' = 'epic' } } }
Gate 'defi_seigneurs' 'large' '#D4AF37' @(
    (Wave @((Mob 'cataclysm:ignited_revenant' 2), (Mob "$($bic):fallen_chaos_knight" 2)) 0.2 2400),
    (Wave @((Mob 'cataclysm:kobolediator' 1), (Mob 'cataclysm:wadjet' 1), (Mob "$($bic):lifestealer" 1)) 0.25 2800),
    (Wave @((Mob 'irons_spellbooks:archevoker' 2), (Mob "$($bic):supreme_bonescaller" 1), (Mob 'cataclysm:ignited_berserker' 2)) 0.3 3000),
    (Wave @((Mob 'cataclysm:the_prowler' 1), (Mob 'cataclysm:ignited_revenant' 2), (Mob "$($bic):fallen_chaos_knight" 2)) 0.35 3600)
) @((Affix 2 'apotheosis:mythic'), (Gem 3 'perfect'), $trophy, (Xp 3000)) 2 @('IWI', 'DND', 'IWI') ([ordered]@{ I = @{ item = 'cataclysm:ignitium_ingot' }; W = @{ item = 'cataclysm:witherite_ingot' }; D = @{ item = 'minecraft:diamond_block' }; N = @{ item = 'minecraft:nether_star' } })

# ---------- 7. Correctifs Archaion (bug du mod, toutes versions 1.4.x) ----------
# misc_room.nbt et misc_room_x.nbt sont vides dans le jar -> retires des pools.
# start_jigsaw "arena_mainhall" n'existe que dans arena.nbt (arena_hall n'a que la cible) -> pool de depart reduit a arena.
# Copies d'origine : scripts/data/archaion/*-orig.json (a reverifier si Archaion est mis a jour).
$ad = Join-Path $PSScriptRoot 'data\archaion'
foreach ($pool in 'rooms', 'rooms_x') {
    $j = Get-Content (Join-Path $ad "$pool-template_pool-orig.json") -Raw | ConvertFrom-Json
    $j.elements = @($j.elements | Where-Object { $_.element.location -notmatch 'misc_room' })
    W "data/archaion/worldgen/template_pool/ancient_keep/$pool.json" $j
}
$j = Get-Content (Join-Path $ad 'main_path-template_pool-orig.json') -Raw | ConvertFrom-Json
$j.elements = @($j.elements | Where-Object { $_.element.location -eq 'archaion:ancient_keep/arena' })
W 'data/pack_lbc/worldgen/template_pool/archaion/start.json' $j
$j = Get-Content (Join-Path $ad 'ancient_keep-structure-orig.json') -Raw | ConvertFrom-Json
$j.start_pool = 'pack_lbc:archaion/start'
W 'data/archaion/worldgen/structure/ancient_keep.json' $j

# ---------- 8. Ensembles de structures redefinis par deux mods (le dernier charge ecrasait l'autre) ----------
# minecraft:villages : Luki's Grand Capitals (villages vanilla, 50/35) et Trek (vanilla + 7 villages Trek, 48/20).
# On fusionne : tous les villages, espacement proche de Luki (ses capitales sont grandes).
# Capitales de Luki favorisees (poids 3 contre 1 pour Trek) : 3 villages sur 4 dans les biomes ou les deux existent
$vil = @('plains', 'desert', 'savanna', 'snowy', 'taiga' | ForEach-Object { [ordered]@{ structure = "minecraft:village_$_"; weight = 3 } })
$vil += 'plains', 'desert', 'savanna', 'snowy', 'taiga', 'swamp_vanilla', 'cherry' | ForEach-Object { [ordered]@{ structure = "trek:village/$_"; weight = 1 } }
W 'data/minecraft/worldgen/structure_set/villages.json' ([ordered]@{ structures = $vil; placement = [ordered]@{ type = 'minecraft:random_spread'; salt = 10387312; spacing = 26; separation = 12 } })
# Structures redefinies : on garde la version Luki's (capitales "revampedvillages", comme ses autres villages).
# village_taiga : Luki's, avec la liste de biomes plus large de Dungeons and Taverns.
W 'data/minecraft/worldgen/structure/village_taiga.json' ([ordered]@{ type = 'minecraft:jigsaw'; biomes = '#nova_structures:collections/any_taiga'; liquid_settings = 'ignore_waterlogging'; step = 'surface_structures'; spawn_overrides = @{}; terrain_adaptation = 'beard_thin'; start_pool = 'revampedvillages:taiga/start'; size = 5; start_height = @{ absolute = 0 }; project_start_to_heightmap = 'WORLD_SURFACE'; max_distance_from_center = 80; use_expansion_hack = $false })
# pillager_outpost : Luki's (avant-poste revisite) plutot que Trek.
$mon = [ordered]@{ bounding_box = 'full'; spawns = @([ordered]@{ type = 'minecraft:pillager'; maxCount = 1; minCount = 1; weight = 4 }, [ordered]@{ type = 'minecraft:vindicator'; maxCount = 1; minCount = 1; weight = 1 }) }
W 'data/minecraft/worldgen/structure/pillager_outpost.json' ([ordered]@{ type = 'minecraft:jigsaw'; biomes = '#minecraft:has_structure/pillager_outpost'; step = 'surface_structures'; spawn_overrides = [ordered]@{ monster = $mon }; terrain_adaptation = 'beard_thin'; start_pool = 'revampedvillages:outpost/start'; size = 2; start_height = @{ absolute = 0 }; project_start_to_heightmap = 'WORLD_SURFACE'; max_distance_from_center = 80; use_expansion_hack = $false })
# minecraft:end_cities : Trek la redefinit (20/11) ; on garde un espacement un peu plus large (26/18).
W 'data/minecraft/worldgen/structure_set/end_cities.json' ([ordered]@{ structures = @([ordered]@{ structure = 'minecraft:end_city'; weight = 1 }); placement = [ordered]@{ type = 'minecraft:random_spread'; salt = 10387313; spacing = 26; separation = 18; spread_type = 'triangular' } })
# Stellarity : ses biomes de l'End sont aussi des biomes "c:is_end" (minerais et creatures des autres mods),
# et la Citadelle en ruine de Cataclysm (Ender Guardian) peut aussi apparaitre dans ses biomes, pas seulement dans les deux vanilla.
W 'data/c/tags/worldgen/biome/is_end.json' ([ordered]@{ replace = $false; values = @([ordered]@{ id = '#stellarity:biomes/all'; required = $false }) })
W 'data/cataclysm/tags/worldgen/biome/has_structure/ruined_citadel_biomes.json' ([ordered]@{ replace = $false; values = @([ordered]@{ id = '#stellarity:biomes/regular'; required = $false }) })

# ---------- 9. Familles de structures (repartition homogene) ----------
# 321 petites structures (Moog's, Born in Chaos, Create Structures Arise, Farmer's, Philips, Explorify) avaient chacune
# leur propre grille -> entassements. Plan fige : scripts/data/structure_families.csv (poids = rarete relative d'origine).
# Chaque famille = un seul ensemble : une structure par case ; si le biome ne convient pas, le jeu en essaie une autre.
# Les structures sont retirees de leur ensemble d'origine par Lithostitched (remove_structure_set_entries).
$famSpacing = @{
    overworld_surface_petit = 8; overworld_surface_moyen = 8; overworld_surface_grand = 21
    overworld_underground_petit = 8; overworld_underground_moyen = 21; overworld_underground_grand = 74
    ocean_moyen = 18; ocean_grand = 63
    nether_petit = 8; nether_moyen = 10; nether_grand = 24
    end_petit = 8; end_moyen = 13; end_grand = 28
}
$fam = Import-Csv (Join-Path $PSScriptRoot 'data\structure_families.csv')
# Ajustements manuels de frequence (multiplicateur du poids), conserves si le CSV est regenere
$famFactor = @{ 'mns:grave_yard' = 0.1; 'mns:large_house_1' = 0.13; 'mns:circle_blackstone' = 0.27; 'mns:crimson_forge' = 0.3; 'mns:small_arena' = 0.33; 'philipsruins:rare_ruin' = 0.2 }
foreach ($r in $fam) { if ($famFactor.ContainsKey($r.structure)) { $r.weight = [Math]::Max(1, [Math]::Round([int]$r.weight * $famFactor[$r.structure])) } }
# Iles volantes (Moog's) : hors familles, ensemble a part -> elles ne prennent plus de case aux structures au sol
$iles = @($fam | Where-Object { $_.structure -like 'mvs:*floating*' })
W 'data/pack_lbc/worldgen/structure_set/iles_volantes.json' ([ordered]@{ structures = @([ordered]@{ structure = 'mvs:floating_islands'; weight = 7 }, [ordered]@{ structure = 'mvs:large_floating_island'; weight = 12 }); placement = [ordered]@{ type = 'minecraft:random_spread'; salt = 71925503; spacing = 260; separation = 100 } })
foreach ($g in ($fam | Where-Object { $iles.structure -notcontains $_.structure } | Group-Object family)) {
    $sp = $famSpacing[$g.Name]; if (-not $sp) { throw "Famille sans espacement : $($g.Name)" }
    $salt = 0; foreach ($ch in $g.Name.ToCharArray()) { $salt = ($salt * 31 + [int]$ch) % 1000000007 }
    $pl = [ordered]@{ type = 'minecraft:random_spread'; salt = $salt; spacing = $sp; separation = [Math]::Floor($sp / 2) }
    if ($g.Name -like 'overworld_surface_*') { $pl.exclusion_zone = [ordered]@{ other_set = 'minecraft:villages'; chunk_count = 4 } }
    $entries = @($g.Group | ForEach-Object { [ordered]@{ structure = $_.structure; weight = [int]$_.weight } })
    W "data/pack_lbc/worldgen/structure_set/familles/$($g.Name).json" ([ordered]@{ structures = $entries; placement = $pl })
}
$i = 0
foreach ($g in ($fam | Group-Object source_set)) {
    W ("data/pack_lbc/lithostitched/worldgen_modifier/familles/retrait_{0:D3}.json" -f $i) ([ordered]@{ type = 'lithostitched:remove_structure_set_entries'; structure_sets = $g.Name; structures = @($g.Group.structure) })
    $i++
}

# ---------- 10. Ensembles hors familles resserres (objectif : >= 15 exemplaires attendus dans un rayon de 60 000 blocs) ----------
# Copies figees des fichiers des mods avec spacing/separation reduits : scripts/data/structure_set_overrides/
# (contient aussi les iles volantes de Moog's remontees : start_height 60 -> 95 blocs au-dessus du sol)
# (a regenerer si ces mods sont mis a jour : scratchpad make_overrides.ps1).
$ov = Join-Path $PSScriptRoot 'data\structure_set_overrides'
foreach ($f in Get-ChildItem $ov -Recurse -File) {
    $rel = $f.FullName.Substring($ov.Length + 1)
    $to = Join-Path $dp $rel
    New-Item -ItemType Directory -Force (Split-Path $to) | Out-Null
    Copy-Item $f.FullName $to -Force
}

# ---------- 11. Cartes de structures (cartes roulees d'Iron's Spells, comme le marche de l'ancien pack) ----------
# Une table de butin par carte : data/pack_lbc/loot_table/cartes/carte_<mod>_<structure>.json (test : /loot give @s loot pack_lbc:cartes/...).
# Clic droit -> carte au tresor vers la structure la plus proche (seulement dans la bonne dimension).
# Mode d'obtention (quetes, marchand, portails...) a decider plus tard ; la 4e colonne est un objet evocateur pour une future recette.
$ow = 'minecraft:overworld'; $nt = 'minecraft:the_nether'; $en = 'minecraft:the_end'
$cartes = @(
    @('minecraft:ancient_city', $ow, 'Cite antique', 'minecraft:sculk', 'Minecraft'),
    @('minecraft:mansion', $ow, 'Manoir des bois', 'minecraft:dark_oak_log', 'Minecraft'),
    @('minecraft:monument', $ow, 'Monument oceanique', 'minecraft:prismarine_shard', 'Minecraft'),
    @('cataclysm:acropolis', $ow, 'Acropole', 'minecraft:nautilus_shell', 'Cataclysm'),
    @('cataclysm:ancient_factory', $ow, 'Usine antique', 'minecraft:redstone_block', 'Cataclysm'),
    @('cataclysm:cursed_pyramid', $ow, 'Pyramide maudite', 'minecraft:chiseled_sandstone', 'Cataclysm'),
    @('cataclysm:frosted_prison', $ow, 'Prison gelee', 'minecraft:blue_ice', 'Cataclysm'),
    @('cataclysm:sunken_city', $ow, 'Cite engloutie', 'minecraft:prismarine_crystals', 'Cataclysm'),
    @('cataclysm:burning_arena', $nt, 'Arene ardente', 'minecraft:magma_block', 'Cataclysm'),
    @('cataclysm:soul_black_smith', $nt, 'Forge des ames', 'minecraft:soul_sand', 'Cataclysm'),
    @('cataclysm:ruined_citadel', $en, 'Citadelle en ruine', 'minecraft:end_stone_bricks', 'Cataclysm'),
    @('irons_spellbooks:evoker_fort', $ow, 'Fort des evocateurs', 'minecraft:emerald', 'Iron''s Spells'),
    @('irons_spellbooks:ice_spider_den', $ow, 'Antre des araignees de glace', 'minecraft:cobweb', 'Iron''s Spells'),
    @('irons_spellbooks:mangrove_hut', $ow, 'Hutte des mangroves', 'minecraft:mangrove_log', 'Iron''s Spells'),
    @('irons_spellbooks:catacombs', $ow, 'Catacombes', 'minecraft:bone_block', 'Iron''s Spells'),
    @('irons_spellbooks:citadel', $nt, 'Citadelle du Nether', 'minecraft:gilded_blackstone', 'Iron''s Spells'),
    @('bosses_of_mass_destruction:void_blossom', $ow, 'Fleur du vide', 'minecraft:spore_blossom', 'Bosses of Mass Destruction'),
    @('bosses_of_mass_destruction:lich_tower', $ow, 'Tour de la liche', 'minecraft:snow_block', 'Bosses of Mass Destruction'),
    @('bosses_of_mass_destruction:gauntlet_arena', $nt, 'Arene du gantelet', 'minecraft:blackstone', 'Bosses of Mass Destruction'),
    @('bosses_of_mass_destruction:obsidilith_arena', $en, 'Arene de l''obsidilithe', 'minecraft:obsidian', 'Bosses of Mass Destruction'),
    @('archaion:ancient_keep', $ow, 'Donjon antique', 'minecraft:deepslate_bricks', 'Archaion'),
    @('mowziesmobs:wrought_chamber', $ow, 'Chambre du Forge-Fer', 'minecraft:iron_block', 'Mowzie''s Mobs'),
    @('mowziesmobs:monastery', $ow, 'Monastere', 'minecraft:chiseled_stone_bricks', 'Mowzie''s Mobs'),
    @('mowziesmobs:umvuthana_grove', $ow, 'Bosquet Umvuthana', 'minecraft:acacia_log', 'Mowzie''s Mobs'),
    @('block_factorys_bosses:yeti_hideout', $ow, 'Repaire du yeti', 'minecraft:packed_ice', 'Bosses''Rise'),
    @('block_factorys_bosses:sandworm_nest', $ow, 'Nid du ver des sables', 'minecraft:sandstone', 'Bosses''Rise'),
    @('block_factorys_bosses:kraken_ship', $ow, 'Navire du Kraken', 'minecraft:dark_oak_planks', 'Bosses''Rise'),
    @('block_factorys_bosses:underworld_arena', $nt, 'Arene des enfers', 'minecraft:soul_soil', 'Bosses''Rise'),
    @('block_factorys_bosses:dragon_tower', $ow, 'Tour du dragon infernal', 'minecraft:magma_block', 'Bosses''Rise')
)
foreach ($k in $cartes) {
    $name = 'carte_' + ($k[0] -replace '[:/]', '_')
    $dim = switch ($k[1]) { $ow { 'Overworld' } $nt { 'Nether' } default { 'End' } }
    $res = [ordered]@{ id = 'irons_spellbooks:furled_map'; count = 1; components = [ordered]@{
            'irons_spellbooks:furled_map_data' = [ordered]@{ destination = $k[0]; descriptionOverride = @{ text = $k[2] }; dimension = $k[1] }
            'minecraft:custom_name' = '{"text":"Carte : ' + $k[2] + '","italic":false}'
            'minecraft:lore' = @('{"text":"[' + $k[4] + ' - ' + $dim + ']","italic":false,"color":"gray"}')
        } }
    W "data/pack_lbc/loot_table/cartes/$name.json" ([ordered]@{ type = 'minecraft:generic'; pools = @([ordered]@{ rolls = 1; entries = @([ordered]@{ type = 'minecraft:item'; name = $res.id; functions = @([ordered]@{ function = 'minecraft:set_components'; components = $res.components }) }) }) })
}

# ---------- 12. Boss renforces (+25 % vie, +15 % degats) via AttributeSetter ----------
# Pour les boss dont le mod n'a pas de reglage (Cataclysm, Mowzie, BOMD, dragon : configs).
# MULTIPLY_BASE = modificateur ADD_MULTIPLIED_BASE a identifiant fixe (pas de cumul au rechargement), vie remise au max a l'apparition.
$bossPlus = @(
    'twilightforest:naga', 'twilightforest:lich', 'twilightforest:minoshroom', 'twilightforest:hydra', 'twilightforest:knight_phantom',
    'twilightforest:ur_ghast', 'twilightforest:alpha_yeti', 'twilightforest:snow_queen',
    'aether:slider', 'aether:valkyrie_queen', 'aether:sun_spirit',
    'irons_spellbooks:dead_king', 'irons_spellbooks:fire_boss',
    'hazennstuff:pyromus', 'hazennstuff:aegis', 'hazennstuff:aptos',
    'born_in_chaos_v1:lord_pumpkinhead', 'born_in_chaos_v1:lord_pumpkinhead_withouta_horse', 'born_in_chaos_v1:lord_the_headless',
    'born_in_chaos_v1:missioner', 'born_in_chaos_v1:supreme_bonescaller', 'born_in_chaos_v1:supreme_bonescaller_not_despawn',
    'born_in_chaos_v1:supreme_bonescaller_stage_2', 'born_in_chaos_v1:krampus',
    'friendsandfoes:wildfire', 'illagerinvasion:invoker', 'archaion:deepslate_sentinel',
    'minecraft:wither', 'minecraft:elder_guardian', 'minecraft:warden',
    'block_factorys_bosses:yeti', 'block_factorys_bosses:sandworm', 'block_factorys_bosses:kraken',
    'block_factorys_bosses:underworld_knight', 'block_factorys_bosses:infernal_dragon',
    'alexscaves:luxtructosaurus'
)
$attr = [ordered]@{}
foreach ($b in $bossPlus) {
    $attr[$b] = @(
        [ordered]@{ attribute = 'minecraft:generic.max_health'; value = 0.25; operation = 'MULTIPLY_BASE' },
        [ordered]@{ attribute = 'minecraft:generic.attack_damage'; value = 0.15; operation = 'MULTIPLY_BASE' }
    )
}
W 'data/pack_lbc/attributesetter/entity/boss_renforces.json' $attr

# ---------- 13. Butin : injection Apotheosis reduite, Treasure Bags limite aux boss ----------
# Avec Lootr chaque joueur a sa copie de chaque coffre : l'injection Apotheosis (affixes 35/30 %, gemmes 25/20 %
# de TOUS les coffres, en plus du contenu) est ramenee a ~10 % / ~8 %.
W 'data/apotheosis/loot_modifiers/affix_loot_injection.json' ([ordered]@{ type = 'apotheosis:affix_loot'; conditions = @(); entries = @(
            [ordered]@{ chance = 0.10; pattern = [ordered]@{ domain = 'minecraft'; path_regex = 'chests.*' } },
            [ordered]@{ chance = 0.09; pattern = [ordered]@{ path_regex = 'chests.*' } },
            [ordered]@{ chance = 0.09; pattern = [ordered]@{ domain = 'twilightforest'; path_regex = 'structures.*' } }) })
W 'data/apotheosis/loot_modifiers/gem_loot_injection.json' ([ordered]@{ type = 'apotheosis:gems'; conditions = @(); entries = @(
            [ordered]@{ chance = 0.08; pattern = [ordered]@{ domain = 'minecraft'; path_regex = 'chests.*' } },
            [ordered]@{ chance = 0.06; pattern = [ordered]@{ path_regex = 'chests.*' } },
            [ordered]@{ chance = 0.06; pattern = [ordered]@{ domain = 'twilightforest'; path_regex = 'structures.*' } }) })
# Treasure Bags : en attendant l'equilibrage, seuls les boss lachent des sacs (2 par boss, reglage du mod).
# Monstres, animaux et joueurs (PvP) neutralises.
foreach ($g in 'hostile', 'peaceful', 'player') { W "data/treasurebags/loot_table/entity_group/$g.json" ([ordered]@{ type = 'minecraft:entity'; pools = @() }) }
# Inventaire de depart (donne une seule fois, a la premiere connexion) : le Sac du voyageur avec le livre de quetes et les guides des mods.
W 'data/pack_lbc/treasurebags_types/voyageur.json' ([ordered]@{ bag_color = '#FF6B4A2B'; bag_overlay_color = '#FF3F7FBF'; bag_string_color = '#FFE8D9A8'; display_name = 'Sac du voyageur'; drops_from_groups = @(); group = 'pack_lbc'; loot_table = 'pack_lbc:bags/voyageur'; rarity = 'uncommon'; visible = $true })
$guides = @('ftbquests:book', 'akashictome:tome', 'solcarrot:food_book', 'aether:book_of_lore', 'alexscaves:cave_book', 'alshanex_familiars:familiar_tome')
$patchouli = @('apotheosis:apoth_chronicle', 'irons_spellbooks:iss_guide_book', 'twilightdelight:twilight_guide')
$livres = @($guides | ForEach-Object { [ordered]@{ rolls = 1; entries = @([ordered]@{ type = 'minecraft:item'; name = $_ }) } }) +
    @($patchouli | ForEach-Object { [ordered]@{ rolls = 1; entries = @([ordered]@{ type = 'minecraft:item'; name = 'patchouli:guide_book'; functions = @([ordered]@{ function = 'minecraft:set_components'; components = [ordered]@{ 'patchouli:book' = $_ } }) }) } })
W 'data/pack_lbc/loot_table/bags/voyageur.json' ([ordered]@{ type = 'minecraft:gift'; pools = $livres })
W 'data/treasurebags/loot_table/starting_inventory.json' ([ordered]@{ type = 'minecraft:gift'; pools = @([ordered]@{ rolls = 1; entries = @([ordered]@{ type = 'minecraft:item'; name = 'treasurebags:treasure_bag'; functions = @([ordered]@{ function = 'treasurebags:set_bag_type'; bag_type = 'pack_lbc:voyageur' }) }) }) })

# ---------- 14. Butin de boss : sac thematique (Treasure Bags) + chance de carte de structure selon la difficulte ----------
# S'ajoute au butin normal du boss (modificateur de butin NeoForge declenche par le TYPE de boss tue, joueur requis).
# Le sac generique de Treasure Bags (2 par boss) est remplace par un sac thematique par famille.
W 'data/treasurebags/loot_table/entity_group/boss.json' ([ordered]@{ type = 'minecraft:entity'; pools = @() })
# Paliers de cartes (structures du plus accessible au plus dangereux)
$palier = @{
    1 = @('irons_spellbooks:ice_spider_den', 'irons_spellbooks:mangrove_hut', 'irons_spellbooks:catacombs', 'irons_spellbooks:evoker_fort', 'minecraft:monument', 'minecraft:mansion', 'mowziesmobs:umvuthana_grove', 'block_factorys_bosses:yeti_hideout', 'block_factorys_bosses:sandworm_nest')
    2 = @('minecraft:ancient_city', 'cataclysm:cursed_pyramid', 'cataclysm:frosted_prison', 'cataclysm:ancient_factory', 'cataclysm:sunken_city', 'cataclysm:acropolis', 'cataclysm:soul_black_smith', 'irons_spellbooks:citadel', 'mowziesmobs:monastery', 'mowziesmobs:wrought_chamber', 'bosses_of_mass_destruction:lich_tower', 'bosses_of_mass_destruction:void_blossom', 'block_factorys_bosses:kraken_ship', 'block_factorys_bosses:underworld_arena')
    3 = @('cataclysm:burning_arena', 'cataclysm:ruined_citadel', 'bosses_of_mass_destruction:gauntlet_arena', 'bosses_of_mass_destruction:obsidilith_arena', 'archaion:ancient_keep', 'block_factorys_bosses:dragon_tower')
}
foreach ($n in 1..3) {
    $ent = @($palier[$n] | ForEach-Object { [ordered]@{ type = 'minecraft:loot_table'; value = 'pack_lbc:cartes/carte_' + ($_ -replace '[:/]', '_'); weight = 1 } })
    W "data/pack_lbc/loot_table/cartes/palier_$n.json" ([ordered]@{ type = 'minecraft:generic'; pools = @([ordered]@{ rolls = 1; entries = $ent }) })
}
# chance de carte et paliers tires selon la difficulte du boss
$carteTier = @{ 1 = @{ chance = 0.25; w = @{ 1 = 1 } }; 2 = @{ chance = 0.30; w = @{ 1 = 1; 2 = 2 } }; 3 = @{ chance = 0.40; w = @{ 2 = 1; 3 = 2 } } }
# Familles de boss : nom du sac, couleurs, materiaux du mod ; boss par palier de difficulte
$apo = @(
    [ordered]@{ type = 'minecraft:item'; name = 'apotheosis:gem_dust'; weight = 5; functions = @([ordered]@{ function = 'minecraft:set_count'; count = [ordered]@{ type = 'minecraft:uniform'; min = 2; max = 6 } }) },
    [ordered]@{ type = 'minecraft:item'; name = 'apotheosis:mysterious_scrap_metal'; weight = 4; functions = @([ordered]@{ function = 'minecraft:set_count'; count = [ordered]@{ type = 'minecraft:uniform'; min = 1; max = 3 } }) },
    [ordered]@{ type = 'minecraft:item'; name = 'apotheosis:timeworn_fabric'; weight = 3; functions = @([ordered]@{ function = 'minecraft:set_count'; count = [ordered]@{ type = 'minecraft:uniform'; min = 1; max = 2 } }) },
    [ordered]@{ type = 'minecraft:item'; name = 'apotheosis:luminous_crystal_shard'; weight = 2 },
    [ordered]@{ type = 'minecraft:item'; name = 'apotheosis:sigil_of_socketing'; weight = 1 },
    [ordered]@{ type = 'minecraft:item'; name = 'minecraft:experience_bottle'; weight = 4; functions = @([ordered]@{ function = 'minecraft:set_count'; count = [ordered]@{ type = 'minecraft:uniform'; min = 4; max = 8 } }) }
)
$familles = [ordered]@{
    cataclysm = @{ nom = 'Butin de Cataclysm'; c = @('#FF3A0F0F', '#FFFF5500', '#FFAA3300'); mat = @('cataclysm:ancient_metal_ingot', 'cataclysm:witherite_ingot', 'cataclysm:ignitium_ingot', 'cataclysm:black_steel_ingot', 'cataclysm:koboleton_bone')
        boss = @{ 2 = @('cataclysm:netherite_monstrosity', 'cataclysm:ender_guardian', 'cataclysm:ancient_remnant', 'cataclysm:maledictus'); 3 = @('cataclysm:ignis', 'cataclysm:the_harbinger', 'cataclysm:the_leviathan', 'cataclysm:scylla') } }
    twilight = @{ nom = 'Butin du Crepuscule'; c = @('#FF1E3B1E', '#FF6FD08C', '#FFB0E0B0'); mat = @('twilightforest:knightmetal_ingot', 'twilightforest:ironwood_ingot', 'twilightforest:fiery_ingot', 'twilightforest:steeleaf_ingot', 'twilightforest:carminite', 'twilightforest:torchberries')
        boss = @{ 1 = @('twilightforest:naga', 'twilightforest:lich'); 2 = @('twilightforest:minoshroom', 'twilightforest:hydra', 'twilightforest:knight_phantom', 'twilightforest:alpha_yeti'); 3 = @('twilightforest:ur_ghast', 'twilightforest:snow_queen') } }
    aether = @{ nom = 'Butin celeste'; c = @('#FFE8F4FF', '#FFFFD54F', '#FF7FC8FF'); mat = @('aether:zanite_gemstone', 'aether:enchanted_gravitite', 'aether:ambrosium_shard', 'aether:golden_amber', 'aether:aechor_petal')
        boss = @{ 1 = @('aether:slider'); 2 = @('aether:valkyrie_queen'); 3 = @('aether:sun_spirit') } }
    arcane = @{ nom = 'Butin arcanique'; c = @('#FF2A1B4A', '#FFB07CFF', '#FF6A4CC2'); mat = @('irons_spellbooks:arcane_essence', 'irons_spellbooks:mithril_scrap', 'irons_spellbooks:rare_ink', 'irons_spellbooks:epic_ink', 'irons_spellbooks:divine_pearl', 'hazennstuff:pyrium_nugget', 'hazennstuff:stardust')
        boss = @{ 1 = @('irons_spellbooks:dead_king'); 2 = @('irons_spellbooks:fire_boss', 'hazennstuff:pyromus', 'hazennstuff:aegis', 'hazennstuff:aptos') } }
    chaos = @{ nom = 'Butin du Chaos'; c = @('#FF1A1A1A', '#FFC23B22', '#FF8A8A8A'); mat = @('born_in_chaos_v1:dark_metal_ingot', 'born_in_chaos_v1:dark_metal_nugget', 'born_in_chaos_v1:bundle_of_bones', 'born_in_chaos_v1:seedof_chaos')
        boss = @{ 1 = @('born_in_chaos_v1:missioner', 'born_in_chaos_v1:krampus', 'born_in_chaos_v1:supreme_bonescaller_stage_2', 'born_in_chaos_v1:lord_the_headless') } }
    mowzie = @{ nom = 'Butin ancestral'; c = @('#FF5B3A1E', '#FFE0B050', '#FF9C6B30'); mat = @('mowziesmobs:ice_crystal', 'mowziesmobs:naga_fang', 'mowziesmobs:foliaath_seed', 'minecraft:gold_ingot')
        boss = @{ 1 = @('mowziesmobs:ferrous_wroughtnaut', 'mowziesmobs:umvuthi'); 2 = @('mowziesmobs:frostmaw', 'mowziesmobs:sculptor') } }
    destruction = @{ nom = 'Butin de destruction'; c = @('#FF101820', '#FF9B30FF', '#FF5050A0'); mat = @('bosses_of_mass_destruction:ancient_anima', 'bosses_of_mass_destruction:crystal_fruit', 'bosses_of_mass_destruction:soul_star', 'bosses_of_mass_destruction:void_thorn')
        boss = @{ 2 = @('bosses_of_mass_destruction:lich', 'bosses_of_mass_destruction:gauntlet', 'bosses_of_mass_destruction:void_blossom'); 3 = @('bosses_of_mass_destruction:obsidilith') } }
    bossesrise = @{ nom = 'Butin des Souverains'; c = @('#FF241A14', '#FFE08A2C', '#FF8C5A2B'); mat = @('block_factorys_bosses:kraken_tooth', 'block_factorys_bosses:dragon_bone', 'block_factorys_bosses:dragon_shank', 'minecraft:gold_ingot', 'minecraft:emerald')
        boss = @{ 1 = @('block_factorys_bosses:yeti', 'block_factorys_bosses:sandworm'); 2 = @('block_factorys_bosses:kraken', 'block_factorys_bosses:underworld_knight'); 3 = @('block_factorys_bosses:infernal_dragon') } }
    illager = @{ nom = 'Butin illager'; c = @('#FF3C3C46', '#FF2FB45A', '#FFB4B4B4'); mat = @('illagerinvasion:hallowed_gem', 'illagerinvasion:platinum_chunk', 'illagerinvasion:illusionary_dust', 'minecraft:emerald')
        boss = @{ 1 = @('illagerinvasion:invoker'); 2 = @('friendsandfoes:wildfire') } }
    legende = @{ nom = 'Butin legendaire'; c = @('#FF101010', '#FF7A2BBF', '#FFFFD700'); mat = @('minecraft:diamond', 'minecraft:emerald', 'minecraft:ender_pearl', 'minecraft:blaze_rod', 'archaion:brave_essence')
        boss = @{ 1 = @('minecraft:elder_guardian'); 2 = @('minecraft:wither'); 3 = @('minecraft:warden', 'minecraft:ender_dragon', 'archaion:deepslate_sentinel') } }
}
# (contient deja les bonus Create des villages de la section 3 : le fichier global est ecrit une seule fois, a la fin)
$glm = @($glmVillages)
foreach ($f in $familles.Keys) {
    $fd = $familles[$f]
    W "data/pack_lbc/treasurebags_types/$f.json" ([ordered]@{ bag_color = $fd.c[0]; bag_overlay_color = $fd.c[1]; bag_string_color = $fd.c[2]; display_name = $fd.nom; drops_from_groups = @(); group = 'pack_lbc'; loot_table = "pack_lbc:bags/$f"; rarity = 'epic'; visible = $true })
    $mat = @($fd.mat | ForEach-Object { [ordered]@{ type = 'minecraft:item'; name = $_; functions = @([ordered]@{ function = 'minecraft:set_count'; count = [ordered]@{ type = 'minecraft:uniform'; min = 1; max = 4 } }) } })
    W "data/pack_lbc/loot_table/bags/$f.json" ([ordered]@{ type = 'minecraft:gift'; pools = @(
                [ordered]@{ rolls = [ordered]@{ type = 'minecraft:uniform'; min = 2; max = 3 }; entries = $mat },
                [ordered]@{ rolls = 2; entries = $apo }) })
    foreach ($t in $fd.boss.Keys) {
        $ct = $carteTier[[int]$t]
        $cartes = @($ct.w.Keys | ForEach-Object { [ordered]@{ type = 'minecraft:loot_table'; value = "pack_lbc:cartes/palier_$_"; weight = $ct.w[$_] } })
        $kp = [ordered]@{ condition = 'minecraft:killed_by_player' }
        W "data/pack_lbc/loot_table/boss/${f}_t$t.json" ([ordered]@{ type = 'minecraft:entity'; pools = @(
                    [ordered]@{ rolls = 1; conditions = @($kp); entries = @([ordered]@{ type = 'minecraft:item'; name = 'treasurebags:treasure_bag'; functions = @([ordered]@{ function = 'treasurebags:set_bag_type'; bag_type = "pack_lbc:$f" }) }) },
                    [ordered]@{ rolls = 1; conditions = @($kp, [ordered]@{ condition = 'minecraft:random_chance'; chance = $ct.chance }); entries = $cartes }) })
        $terms = @($fd.boss[$t] | ForEach-Object { [ordered]@{ condition = 'minecraft:entity_properties'; entity = 'this'; predicate = [ordered]@{ type = $_ } } })
        W "data/pack_lbc/loot_modifiers/boss/${f}_t$t.json" ([ordered]@{ type = 'neoforge:add_table'; conditions = @([ordered]@{ condition = 'minecraft:any_of'; terms = $terms }); table = "pack_lbc:boss/${f}_t$t" })
        $glm += "pack_lbc:boss/${f}_t$t"
    }
}
# Sacs dans les coffres de structure : 1 % de chance, seulement dans les coffres interessants des structures standard
# (score de butin 9 a 45 ; ni coffres banals, ni grandes structures / donjons / arenes deja riches).
# Liste figee : scripts/data/coffres_sacs.csv (table, famille). Sac "explorateur" : 1 equipement a affixes (80 % rare, 20 % epique) OU 1 relique, 50/50 (Relics, monte en niveau).
$sacChance = 0.01
W 'data/pack_lbc/treasurebags_types/explorateur.json' ([ordered]@{ bag_color = '#FF5A4632'; bag_overlay_color = '#FF8FBF6A'; bag_string_color = '#FFD9C27A'; display_name = "Sac d'explorateur"; drops_from_groups = @(); group = 'pack_lbc'; loot_table = 'pack_lbc:bags/explorateur'; rarity = 'rare'; visible = $true })
$reliques = 'reflective_necklace', 'jellyfish_necklace', 'kinetic_belt', 'hunting_belt', 'springy_boot', 'roller_skate', 'cut_glass_boot', 'leafy_mantle', 'midnight_mantle', 'glitchy_mantle', 'ghostly_mantle', 'chorus_staff', 'piglin_mask', 'rider_flute', 'pet_bone', 'ring_of_the_seven_deadly_sins', 'sphere_of_self_sacrifice', 'clot_of_time', 'golden_tooth', 'chef_hat', 'experience_disperser', 'shield_of_retaliation'
# Relique 50 % (22 x 5) / equipement 50 % (110) dont 80 % rare bleu (88) et 20 % epique violet (22)
$explo = @([ordered]@{ type = 'apotheosis:random_affix_item'; weight = 88; rarities = @('apotheosis:rare') }, [ordered]@{ type = 'apotheosis:random_affix_item'; weight = 22; rarities = @('apotheosis:epic') }) + @($reliques | ForEach-Object { [ordered]@{ type = 'minecraft:item'; name = "relics:$_"; weight = 5 } })
W 'data/pack_lbc/loot_table/bags/explorateur.json' ([ordered]@{ type = 'minecraft:gift'; pools = @([ordered]@{ rolls = 1; entries = $explo }) })
foreach ($g in (Import-Csv (Join-Path $PSScriptRoot 'data\coffres_sacs.csv') | Group-Object famille)) {
    $ent = @([ordered]@{ type = 'minecraft:item'; name = 'treasurebags:treasure_bag'; functions = @([ordered]@{ function = 'treasurebags:set_bag_type'; bag_type = 'pack_lbc:explorateur' }) })
    W "data/pack_lbc/loot_table/coffres/sac_$($g.Name).json" ([ordered]@{ type = 'minecraft:chest'; pools = @([ordered]@{ rolls = 1; entries = $ent }) })
    $terms = @($g.Group | ForEach-Object { [ordered]@{ condition = 'neoforge:loot_table_id'; loot_table_id = $_.table } })
    W "data/pack_lbc/loot_modifiers/coffres/sac_$($g.Name).json" ([ordered]@{ type = 'neoforge:add_table'; conditions = @([ordered]@{ condition = 'minecraft:any_of'; terms = $terms }, [ordered]@{ condition = 'minecraft:random_chance'; chance = $sacChance }); table = "pack_lbc:coffres/sac_$($g.Name)" })
    $glm += "pack_lbc:coffres/sac_$($g.Name)"
}
# ---------- Bosses'Rise : arenes aussi dans les biomes equivalents de Terralith et des autres mods ----------
# (le mod ne vise que des biomes vanilla precis, plus rares avec Terralith)
function OptT($ids) { @($ids | ForEach-Object { [ordered]@{ id = $_; required = $false } }) }
W 'data/block_factorys_bosses/tags/worldgen/biome/yeti_hideout.json' ([ordered]@{ replace = $false; values = (OptT @('minecraft:snowy_taiga', 'terralith:snowy_shield', 'terralith:cold_shrubland', 'terralith:ice_marsh')) })
W 'data/block_factorys_bosses/tags/worldgen/biome/sandworm_nest.json' ([ordered]@{ replace = $false; values = (OptT @('terralith:ancient_sands', 'terralith:lush_desert', 'terralith:gravel_desert', 'terralith:sandstone_valley', 'terralith:desert_oasis')) })
W 'data/block_factorys_bosses/tags/worldgen/biome/kraken_ship.json' ([ordered]@{ replace = $false; values = (OptT @('#minecraft:is_deep_ocean', 'terralith:deep_warm_ocean')) })
W 'data/block_factorys_bosses/tags/worldgen/biome/dragon_tower.json' ([ordered]@{ replace = $false; values = (OptT @('#c:is_plains', '#c:is_savanna')) })
# Tablettes de grotte d'Alex's Caves : sources ajoutees pour les temples de jungle YUNG (Toxic Caves)
# et les manoirs de Repurposed Structures (Forlorn Hollows), en plus des coffres vanilla prevus par le mod.
$tablettes = [ordered]@{
    toxic_caves     = @('betterjungletemples:chests/treasure')
    forlorn_hollows = @('birch', 'desert', 'jungle', 'mangrove', 'oak', 'savanna', 'snowy', 'taiga' | ForEach-Object { "repurposed_structures:chests/mansions/$_" })
}
foreach ($b in $tablettes.Keys) {
    $terms = @($tablettes[$b] | ForEach-Object { [ordered]@{ condition = 'neoforge:loot_table_id'; loot_table_id = $_ } })
    W "data/pack_lbc/loot_modifiers/tablette_$b.json" ([ordered]@{ type = 'alexscaves:cave_tablet'; biome = "alexscaves:$b"; replace = $false; conditions = @([ordered]@{ condition = 'minecraft:any_of'; terms = $terms }) })
    $glm += "pack_lbc:tablette_$b"
}
W 'data/neoforge/loot_modifiers/global_loot_modifiers.json' ([ordered]@{ replace = $false; entries = $glm })

# ---------- 15. Coffres Dungeons Arise reequilibres (tables figees dans scripts/data/loot_overrides) ----------
# 109 tables : diamants/emeraudes/or /5, netherite /3, equipement enchante 1 tirage au lieu de 2-3.
# (regenerer avec scratchpad da_rebalance.ps1 si Dungeons Arise est mis a jour)
$lo = Join-Path $PSScriptRoot 'data\loot_overrides'
foreach ($f in Get-ChildItem $lo -Recurse -File) {
    $to = Join-Path $dp $f.FullName.Substring($lo.Length + 1)
    New-Item -ItemType Directory -Force (Split-Path $to) | Out-Null
    Copy-Item $f.FullName $to -Force
}

# ---------- 16. Dragon de Stellarity : 400 PV (300 par defaut) ----------
# Stellarity garde ce reglage dans un score du monde ; il ne le cree que s'il est absent.
# Le score est force a chaque chargement : le menu de config de Stellarity ne le change donc plus.
$fn = Join-Path $dp 'data\pack_lbc\function\stellarity_config.mcfunction'
New-Item -ItemType Directory -Force (Split-Path $fn) | Out-Null
[IO.File]::WriteAllText($fn, "scoreboard objectives add stellarity.config.dragon_health dummy`nscoreboard players set #stellarity.config stellarity.config.dragon_health 400`n", $enc)
W 'data/minecraft/tags/function/load.json' ([ordered]@{ values = @('pack_lbc:stellarity_config') })

$count = (Get-ChildItem $dp -Recurse -File).Count
Write-Host "Datapack genere : $dp ($count fichiers)"
