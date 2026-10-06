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
$vil = @('plains', 'desert', 'savanna', 'snowy', 'taiga' | ForEach-Object { [ordered]@{ structure = "minecraft:village_$_"; weight = 1 } })
$vil += 'plains', 'desert', 'savanna', 'snowy', 'taiga', 'swamp_vanilla', 'cherry' | ForEach-Object { [ordered]@{ structure = "trek:village/$_"; weight = 1 } }
W 'data/minecraft/worldgen/structure_set/villages.json' ([ordered]@{ structures = $vil; placement = [ordered]@{ type = 'minecraft:random_spread'; salt = 10387312; spacing = 36; separation = 16 } })
# Structures redefinies : on garde la version Luki's (capitales "revampedvillages", comme ses autres villages).
# village_taiga : Luki's, avec la liste de biomes plus large de Dungeons and Taverns.
W 'data/minecraft/worldgen/structure/village_taiga.json' ([ordered]@{ type = 'minecraft:jigsaw'; biomes = '#nova_structures:collections/any_taiga'; liquid_settings = 'ignore_waterlogging'; step = 'surface_structures'; spawn_overrides = @{}; terrain_adaptation = 'beard_thin'; start_pool = 'revampedvillages:taiga/start'; size = 5; start_height = @{ absolute = 0 }; project_start_to_heightmap = 'WORLD_SURFACE'; max_distance_from_center = 80; use_expansion_hack = $false })
# pillager_outpost : Luki's (avant-poste revisite) plutot que Trek.
$mon = [ordered]@{ bounding_box = 'full'; spawns = @([ordered]@{ type = 'minecraft:pillager'; maxCount = 1; minCount = 1; weight = 4 }, [ordered]@{ type = 'minecraft:vindicator'; maxCount = 1; minCount = 1; weight = 1 }) }
W 'data/minecraft/worldgen/structure/pillager_outpost.json' ([ordered]@{ type = 'minecraft:jigsaw'; biomes = '#minecraft:has_structure/pillager_outpost'; step = 'surface_structures'; spawn_overrides = [ordered]@{ monster = $mon }; terrain_adaptation = 'beard_thin'; start_pool = 'revampedvillages:outpost/start'; size = 2; start_height = @{ absolute = 0 }; project_start_to_heightmap = 'WORLD_SURFACE'; max_distance_from_center = 80; use_expansion_hack = $false })
# minecraft:end_cities : Nullscape (26/18, adapte a son terrain) et Trek (20/11). On garde Nullscape.
W 'data/minecraft/worldgen/structure_set/end_cities.json' ([ordered]@{ structures = @([ordered]@{ structure = 'minecraft:end_city'; weight = 1 }); placement = [ordered]@{ type = 'minecraft:random_spread'; salt = 10387313; spacing = 26; separation = 18; spread_type = 'triangular' } })

# ---------- 9. Familles de structures (repartition homogene) ----------
# 321 petites structures (Moog's, Born in Chaos, Create Structures Arise, Farmer's, Philips, Explorify) avaient chacune
# leur propre grille -> entassements. Plan fige : scripts/data/structure_families.csv (poids = rarete relative d'origine).
# Chaque famille = un seul ensemble : une structure par case ; si le biome ne convient pas, le jeu en essaie une autre.
# Les structures sont retirees de leur ensemble d'origine par Lithostitched (remove_structure_set_entries).
$famSpacing = @{
    overworld_surface_petit = 8; overworld_surface_moyen = 8; overworld_surface_grand = 14
    overworld_underground_petit = 10; overworld_underground_moyen = 26; overworld_underground_grand = 74
    ocean_moyen = 22; ocean_grand = 63
    nether_petit = 8; nether_moyen = 12; nether_grand = 24
    end_petit = 10; end_moyen = 16; end_grand = 28
}
$fam = Import-Csv (Join-Path $PSScriptRoot 'data\structure_families.csv')
# Ajustements manuels de frequence (multiplicateur du poids), conserves si le CSV est regenere
$famFactor = @{ 'mvs:floating_islands' = 0.33; 'mvs:large_floating_island' = 0.33; 'mns:grave_yard' = 0.1; 'mns:large_house_1' = 0.13; 'mns:circle_blackstone' = 0.27; 'mns:crimson_forge' = 0.3 }
foreach ($r in $fam) { if ($famFactor.ContainsKey($r.structure)) { $r.weight = [Math]::Max(1, [Math]::Round([int]$r.weight * $famFactor[$r.structure])) } }
foreach ($g in ($fam | Group-Object family)) {
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
    @('iceandfire:fire_dragon_roost', $ow, 'Nid de dragon de feu', 'minecraft:fire_charge', 'Ice and Fire'),
    @('iceandfire:ice_dragon_roost', $ow, 'Nid de dragon de glace', 'minecraft:packed_ice', 'Ice and Fire'),
    @('iceandfire:lightning_dragon_roost', $ow, 'Nid de dragon de foudre', 'minecraft:lightning_rod', 'Ice and Fire'),
    @('iceandfire:gorgon_temple', $ow, 'Temple de la gorgone', 'minecraft:quartz_pillar', 'Ice and Fire'),
    @('iceandfire:hydra_cave', $ow, 'Grotte de l''hydre', 'minecraft:lily_pad', 'Ice and Fire'),
    @('iceandfire:cyclops_cave', $ow, 'Grotte du cyclope', 'minecraft:white_wool', 'Ice and Fire'),
    @('mowziesmobs:wrought_chamber', $ow, 'Chambre du Forge-Fer', 'minecraft:iron_block', 'Mowzie''s Mobs'),
    @('mowziesmobs:monastery', $ow, 'Monastere', 'minecraft:chiseled_stone_bricks', 'Mowzie''s Mobs'),
    @('mowziesmobs:umvuthana_grove', $ow, 'Bosquet Umvuthana', 'minecraft:acacia_log', 'Mowzie''s Mobs')
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

$count = (Get-ChildItem $dp -Recurse -File).Count
Write-Host "Datapack genere : $dp ($count fichiers)"
