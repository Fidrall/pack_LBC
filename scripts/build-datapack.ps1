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
# Radiation du reacteur New Age : la combinaison Hazmat d'Alex's Caves protege (comme le cuir), les blocs Hazmat servent de blindage
W 'data/create_new_age/tags/item/hazmat_suit.json' ([ordered]@{ replace = $false; values = @('alexscaves:hazmat_mask', 'alexscaves:hazmat_chestplate', 'alexscaves:hazmat_leggings', 'alexscaves:hazmat_boots') })
$blindage = @('alexscaves:hazmat_block', 'alexscaves:hazmat_warning_block')
foreach ($k in 'block', 'item') { W "data/create_new_age/tags/$k/stops_radiation.json" ([ordered]@{ replace = $false; values = $blindage }) }
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
# Boss a sac de tresor (section 14) presents dans les vagues : leur butin n'est pas rejoue en recompense (sinon plusieurs sacs).
$bossAvecSac = @('minecraft:warden', 'deeperdarker:stalker')
function Wave($mobs, $hp, $time) {
    $rw = @(); foreach ($m in $mobs) { if ($bossAvecSac -notcontains $m.entity) { $rw += Loot $m.entity ([int]($m.count * 3)) } }
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
W 'data/minecraft/worldgen/structure_set/villages.json' ([ordered]@{ structures = $vil; placement = [ordered]@{ type = 'minecraft:random_spread'; salt = 10387312; spacing = 34; separation = 14 } })   # 26/12 jusqu'au 2026-10-21 (trop dense), 34 = vanilla (30 essaye puis abandonne)
# Structures redefinies : on garde la version Luki's (capitales "revampedvillages", comme ses autres villages).
# village_taiga : Luki's, avec la liste de biomes plus large de Dungeons and Taverns.
W 'data/minecraft/worldgen/structure/village_taiga.json' ([ordered]@{ type = 'minecraft:jigsaw'; biomes = '#nova_structures:collections/any_taiga'; liquid_settings = 'ignore_waterlogging'; step = 'surface_structures'; spawn_overrides = @{}; terrain_adaptation = 'beard_thin'; start_pool = 'revampedvillages:taiga/start'; size = 5; start_height = @{ absolute = 0 }; project_start_to_heightmap = 'WORLD_SURFACE'; max_distance_from_center = 80; use_expansion_hack = $false })
# pillager_outpost : Luki's (avant-poste revisite) plutot que Trek.
$mon = [ordered]@{ bounding_box = 'full'; spawns = @([ordered]@{ type = 'minecraft:pillager'; maxCount = 1; minCount = 1; weight = 4 }, [ordered]@{ type = 'minecraft:vindicator'; maxCount = 1; minCount = 1; weight = 1 }) }
W 'data/minecraft/worldgen/structure/pillager_outpost.json' ([ordered]@{ type = 'minecraft:jigsaw'; biomes = '#minecraft:has_structure/pillager_outpost'; step = 'surface_structures'; spawn_overrides = [ordered]@{ monster = $mon }; terrain_adaptation = 'beard_thin'; start_pool = 'revampedvillages:outpost/start'; size = 2; start_height = @{ absolute = 0 }; project_start_to_heightmap = 'WORLD_SURFACE'; max_distance_from_center = 80; use_expansion_hack = $false })
# minecraft:end_cities : Trek la redefinit (20/11) ; on garde un espacement un peu plus large (26/18).
W 'data/minecraft/worldgen/structure_set/end_cities.json' ([ordered]@{ structures = @([ordered]@{ structure = 'minecraft:end_city'; weight = 1 }); placement = [ordered]@{ type = 'minecraft:random_spread'; salt = 10387313; spacing = 26; separation = 18; spread_type = 'triangular' } })
# Nullscape : les iles exterieures sont surtout ses 3 biomes (crystal_peaks, shadowlands, void_barrens) ; il ne garde que
# end_highlands et small_end_islands en vanilla, et plus de end_midlands. La Citadelle en ruine de Cataclysm (Ender Guardian),
# prevue pour les biomes vanilla seulement, y apparait donc aussi.
W 'data/cataclysm/tags/worldgen/biome/has_structure/ruined_citadel_biomes.json' ([ordered]@{ replace = $false; values = @([ordered]@{ id = '#nullscape:all_nullscape_biomes'; required = $false }) })

# ---------- 9. Familles de structures (repartition homogene) ----------
# 321 petites structures (Moog's, Born in Chaos, Create Structures Arise, Farmer's, Philips, Explorify) avaient chacune
# leur propre grille -> entassements. Plan fige : scripts/data/structure_families.csv (poids = rarete relative d'origine).
# Chaque famille = un seul ensemble : une structure par case ; si le biome ne convient pas, le jeu en essaie une autre.
# Les structures sont retirees de leur ensemble d'origine par Lithostitched (remove_structure_set_entries).
$famSpacing = @{
    overworld_surface_petit = 8; overworld_surface_moyen = 8; overworld_surface_grand = 23
    overworld_underground_petit = 8; overworld_underground_moyen = 21; overworld_underground_grand = 74
    ocean_moyen = 18; ocean_grand = 63
    nether_petit = 8; nether_moyen = 10; nether_grand = 24
    end_petit = 8; end_moyen = 13; end_grand = 28
}
$fam = Import-Csv (Join-Path $PSScriptRoot 'data\structure_families.csv')
# Ajustements manuels de frequence (multiplicateur du poids), conserves si le CSV est regenere
$famFactor = @{ 'mns:grave_yard' = 0.1; 'mns:large_house_1' = 0.13; 'mns:circle_blackstone' = 0.27; 'mns:crimson_forge' = 0.3; 'mns:small_arena' = 0.33; 'philipsruins:rare_ruin' = 0.2
    # Create Structures Arise : grandes de surface ~0,6x l'original du mod (elles etaient ~1,55x), caisse sous ballon /5 (encore trop vue a /2)
    'create_structures_arise:windmill' = 0.4; 'create_structures_arise:createminiskyvillage' = 0.4; 'create_structures_arise:pillagersteampunkairship' = 0.4
    'create_structures_arise:crimsite_tower' = 0.4; 'create_structures_arise:towerofochrum' = 0.4; 'create_structures_arise:createairdrop' = 0.2 }
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
# When Dungeons Arise (mesure 2026-10-11 : ~20 % de reussite sur terre a cause de la planeite) : grandes terrestres a 28
# avec geantes en poids 2, navires/Typhon a part dans pack_lbc:dungeons_arise_marins (37), petites a 34.
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

# ---------- 12. Boss renforces selon leur difficulte, via AttributeSetter ----------
# Valeurs : scripts/data/boss_equilibrage.csv (vie et degats par boss : courbe sur la vie de base, ancien pack compresse
# pour Cataclysm/BOMD, plancher et plafond par palier 1-4, degats +5/+15/+30/+30 % plafonnes a +30 %).
# Cataclysm, Mowzie et BOMD ont leurs propres reglages : valeurs ecrites dans leurs configs (scripts/boss-configs.ps1).
# MULTIPLY_BASE = modificateur ADD_MULTIPLIED_BASE a identifiant fixe (pas de cumul au rechargement), vie remise au max a l'apparition.
$bossEq = Import-Csv (Join-Path $PSScriptRoot 'data\boss_equilibrage.csv')
$ic = [cultureinfo]::InvariantCulture
$attr = [ordered]@{}
foreach ($b in $bossEq | Where-Object { $_.id.Split(':')[0] -notin 'cataclysm', 'mowziesmobs', 'bosses_of_mass_destruction' }) {
    $mods = @()
    $v = [double]::Parse($b.vie, $ic) - 1; if ($v -gt 0.001) { $mods += [ordered]@{ attribute = 'minecraft:generic.max_health'; value = [Math]::Round($v, 3); operation = 'MULTIPLY_BASE' } }
    $d = [double]::Parse($b.degats, $ic) - 1; if ($d -gt 0.001) { $mods += [ordered]@{ attribute = 'minecraft:generic.attack_damage'; value = [Math]::Round($d, 3); operation = 'MULTIPLY_BASE' } }
    if ($mods) { $attr[$b.id] = $mods }
}
W 'data/pack_lbc/attributesetter/entity/boss_renforces.json' $attr
# Boss dont la vie suit le nombre de joueurs proches (lbcfixes : +50 % par joueur en plus, jamais a la baisse pendant le combat)
W 'data/pack_lbc/tags/entity_type/boss_multijoueur.json' ([ordered]@{ replace = $false; values = @($bossEq.id | ForEach-Object { [ordered]@{ id = $_; required = $false } }) })

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
        boss = @{ 1 = @('born_in_chaos_v1:missioner', 'born_in_chaos_v1:krampus', 'born_in_chaos_v1:supreme_bonescaller_stage_2', 'born_in_chaos_v1:lord_the_headless', 'born_in_chaos_v1:lord_pumpkinhead_head') } }
    mowzie = @{ nom = 'Butin ancestral'; c = @('#FF5B3A1E', '#FFE0B050', '#FF9C6B30'); mat = @('mowziesmobs:ice_crystal', 'mowziesmobs:naga_fang', 'mowziesmobs:foliaath_seed', 'minecraft:gold_ingot')
        boss = @{ 1 = @('mowziesmobs:ferrous_wroughtnaut', 'mowziesmobs:umvuthi'); 2 = @('mowziesmobs:frostmaw', 'mowziesmobs:sculptor') } }
    destruction = @{ nom = 'Butin de destruction'; c = @('#FF101820', '#FF9B30FF', '#FF5050A0'); mat = @('bosses_of_mass_destruction:ancient_anima', 'bosses_of_mass_destruction:crystal_fruit', 'bosses_of_mass_destruction:soul_star', 'bosses_of_mass_destruction:void_thorn')
        boss = @{ 2 = @('bosses_of_mass_destruction:lich', 'bosses_of_mass_destruction:gauntlet', 'bosses_of_mass_destruction:void_blossom'); 3 = @('bosses_of_mass_destruction:obsidilith') } }
    bossesrise = @{ nom = 'Butin des Souverains'; c = @('#FF241A14', '#FFE08A2C', '#FF8C5A2B'); mat = @('block_factorys_bosses:kraken_tooth', 'block_factorys_bosses:dragon_bone', 'block_factorys_bosses:dragon_shank', 'minecraft:gold_ingot', 'minecraft:emerald')
        boss = @{ 1 = @('block_factorys_bosses:yeti', 'block_factorys_bosses:sandworm'); 2 = @('block_factorys_bosses:kraken', 'block_factorys_bosses:underworld_knight'); 3 = @('block_factorys_bosses:infernal_dragon') } }
    illager = @{ nom = 'Butin illager'; c = @('#FF3C3C46', '#FF2FB45A', '#FFB4B4B4'); mat = @('illagerinvasion:hallowed_gem', 'illagerinvasion:platinum_chunk', 'illagerinvasion:illusionary_dust', 'minecraft:emerald')
        boss = @{ 1 = @('illagerinvasion:invoker'); 2 = @('friendsandfoes:wildfire') } }
    legende = @{ nom = 'Butin legendaire'; c = @('#FF101010', '#FF7A2BBF', '#FFFFD700'); mat = @('minecraft:diamond', 'minecraft:emerald', 'minecraft:ender_pearl', 'minecraft:blaze_rod', 'archaion:brave_essence')
        boss = @{ 1 = @('minecraft:elder_guardian'); 2 = @('minecraft:wither'); 3 = @('minecraft:warden', 'minecraft:ender_dragon', 'archaion:last_of_deepslate') } }
    profondeurs = @{ nom = 'Butin des profondeurs'; c = @('#FF0B1F24', '#FF2FD6C8', '#FF0F5A66'); mat = @('deeperdarker:resonarium', 'deeperdarker:soul_crystal', 'deeperdarker:soul_dust', 'deeperdarker:reinforced_echo_shard', 'deeperdarker:sculk_bone', 'minecraft:echo_shard')
        boss = @{ 2 = @('deeperdarker:stalker') } }
    cavernes = @{ nom = 'Butin des cavernes'; c = @('#FF3B2412', '#FFE07B2A', '#FF7A4A22'); mat = @('alexscaves:scarlet_neodymium_ingot', 'alexscaves:azure_neodymium_ingot', 'alexscaves:tectonic_shard', 'alexscaves:heavy_bone', 'alexscaves:amber_curiosity', 'alexscaves:pearl')
        boss = @{ 2 = @('alexscaves:luxtructosaurus') } }
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
        # Plus de modificateur de butin : lbcfixes (BossButin) tire cette table pour CHAQUE joueur present a la mort du boss
        # et la met dans son inventaire. Le tag pack_lbc:butin_boss/<famille>_t<palier> relie le boss a sa table.
        W "data/pack_lbc/tags/entity_type/butin_boss/${f}_t$t.json" ([ordered]@{ replace = $false; values = @($fd.boss[$t] | ForEach-Object { [ordered]@{ id = $_; required = $false } }) })
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
# Parchemins d'Apex Arcana (grandsigil) : retires de tous les tirages aleatoires de parchemins (tables reecrites dans
# scripts/data/spell_loot, copiees en section 17) et places seulement dans quelques coffres de fin de jeu, tres rarement.
# Chance par coffre (Lootr : par joueur). Liste des sorts : scripts/data/sorts_apex.txt.
# Un coffre de recompense par structure (sauf cite antique : beaucoup de coffres, d'ou 1 %).
$apexChance = [ordered]@{
    'minecraft:chests/ancient_city'                       = 0.01
    'minecraft:chests/end_city_treasure'                  = 0.02
    'irons_spellbooks:chests/catacombs/dead_king_vault'   = 0.03  # Dead King
    'irons_spellbooks:chests/citadel/citadel_vault'       = 0.03
    'bosses_of_mass_destruction:chests/lich_tower'        = 0.03
    'twilightforest:darktower_boss'                       = 0.03  # Ur-Ghast
    'deeperdarker:chests/ancient_temple_apex'             = 0.03
}
$apexSorts = @([IO.File]::ReadAllLines((Join-Path $PSScriptRoot 'data\sorts_apex.txt')) | Where-Object { $_.Trim() })
W 'data/pack_lbc/loot_table/coffres/parchemin_apex.json' ([ordered]@{ type = 'minecraft:chest'; pools = @([ordered]@{ rolls = 1; entries = @([ordered]@{ type = 'minecraft:item'; name = 'irons_spellbooks:scroll'; functions = @([ordered]@{ function = 'irons_spellbooks:randomize_spell'; quality = [ordered]@{ min = 0.0; max = 1.0 }; spell_filter = [ordered]@{ spells = $apexSorts } }) }) }) })
$i = 0
foreach ($t in $apexChance.Keys) {
    $i++
    W "data/pack_lbc/loot_modifiers/coffres/parchemin_apex_$i.json" ([ordered]@{ type = 'neoforge:add_table'; conditions = @([ordered]@{ condition = 'neoforge:loot_table_id'; loot_table_id = $t }, [ordered]@{ condition = 'minecraft:random_chance'; chance = $apexChance[$t] }); table = 'pack_lbc:coffres/parchemin_apex' })
    $glm += "pack_lbc:coffres/parchemin_apex_$i"
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

# ---------- 16. Dragon : Ender Dragon Fight Remastered (EDFR, 500 PV) ----------
# Son endfight:tick balaie ~20 fois par tick TOUTES les entites du serveur (@e[tag=...] sans type), meme sans personne dans l'End.
# Remplace (pack_lbc charge apres le datapack du mod) : le tick d'origine (copie GPL dans scripts/data/edfr) ne tourne que si
# un joueur est dans l'End ; sinon on coupe seulement la musique des joueurs partis en plein combat.
function Fn($rel, $lines) { $p = Join-Path $dp $rel; New-Item -ItemType Directory -Force (Split-Path $p) | Out-Null; [IO.File]::WriteAllText($p, (($lines -join "`n") + "`n"), $enc) }
$dansEnd = 'execute in minecraft:the_end if entity @a[x=0,y=0,z=0,distance=0..]'
$horsEnd = 'execute in minecraft:the_end unless entity @a[x=0,y=0,z=0,distance=0..]'
Fn 'data/endfight/function/tick.mcfunction' @(
    '# pack_lbc : EDFR ne tourne que si un joueur est dans l''End (voir build-datapack section 16)',
    "$dansEnd in minecraft:overworld run function pack_lbc:edfr/tick",
    "$horsEnd if entity @a[tag=playerMusic] run function pack_lbc:edfr/coupe_musique",
    "$horsEnd if entity @a[tag=playerMusicMAD] run function pack_lbc:edfr/coupe_musique")
Fn 'data/pack_lbc/function/edfr/tick.mcfunction' ([IO.File]::ReadAllLines((Join-Path $PSScriptRoot 'data\edfr\tick.mcfunction')))
Fn 'data/pack_lbc/function/edfr/coupe_musique.mcfunction' @(
    'stopsound @a record endfight:boss.phase1', 'stopsound @a record endfight:boss.phase2',
    'tag @a remove playerMusic', 'tag @a remove playerMusic.timerInit',
    'tag @a remove playerMusicMAD', 'tag @a remove playerMusicMAD.init', 'tag @a remove playerMusicMAD.timerInit')

# ---------- 17. Parchemins d'Iron's et de ses addons sans Apex Arcana (tables figees dans scripts/data/spell_loot) ----------
# 59 tables : chaque tirage aleatoire recoit une liste explicite de sorts (toutes ecoles ou l'ecole demandee), sans grandsigil.
# (regenerer avec scratchpad gen_spell_loot.ps1 apres chaque mise a jour d'Iron's ou d'un addon de sorts)
$sl = Join-Path $PSScriptRoot 'data\spell_loot'
foreach ($f in Get-ChildItem $sl -Recurse -File) {
    $to = Join-Path $dp $f.FullName.Substring($sl.Length + 1)
    New-Item -ItemType Directory -Force (Split-Path $to) | Out-Null
    Copy-Item $f.FullName $to -Force
}

# ---------- 18. Gemmes et elites Apotheosis par lieu (End, cavernes, Nether, Twilight, Aether, Otherside, Alex's Caves) ----------
# Gemmes data/pack_lbc/gems/<lieu>/<nom> : ne tombent qu'au lieu indique (constraints dimensions ou biomes), sur les monstres
# et dans les coffres. Effets choisis absents des 38 gemmes d'Apotheosis et d'Iron's Apothic (verifie le 2026-10-11).
# Elites data/pack_lbc/apothic_elites/<lieu>/<nom> : mini-boss nommes, equipes au palier du joueur, apparition naturelle.
# Noms (fr/en), modeles et textures (dessinees ici) : resource pack config/paxi/resourcepacks/pack_lbc_quests.
$rp = Join-Path $root 'config\paxi\resourcepacks\pack_lbc_quests\assets'
function RW($rel, $text) { $p = Join-Path $rp $rel; New-Item -ItemType Directory -Force (Split-Path $p) | Out-Null; [IO.File]::WriteAllText($p, $text, $enc) }
$PUR = @('cracked', 'chipped', 'flawed', 'normal', 'flawless', 'perfect')
# Valeurs par purete : le tableau couvre les N dernieres puretes (3 = normale -> parfaite, 4 = imparfaite -> parfaite)
function V($vals) { $o = [ordered]@{}; $s = 6 - $vals.Count; for ($i = 0; $i -lt $vals.Count; $i++) { $o[$PUR[$s + $i]] = $vals[$i] }; $o }
function Att($cls, $attr, $op, $vals) { [ordered]@{ type = 'apotheosis:attribute'; attribute = $attr; gem_class = $cls; operation = $op; values = (V $vals) } }
function Red($cls, $dmg, $vals) { [ordered]@{ type = 'apotheosis:damage_reduction'; damage_type = $dmg; gem_class = $cls; values = (V $vals) } }
function Eff($cls, $eff, $target, $d, $amp, $cd) {
    $o = [ordered]@{}; $s = 6 - $d.Count
    for ($i = 0; $i -lt $d.Count; $i++) { $o[$PUR[$s + $i]] = [ordered]@{ duration = $d[$i]; amplifier = $amp[$i]; cooldown = $cd } }
    [ordered]@{ type = 'apotheosis:mob_effect'; gem_class = $cls; mob_effect = $eff; target = $target; values = $o }
}
function Tiers($names, $w) { $o = [ordered]@{}; foreach ($t in $names) { $o[$t] = [ordered]@{ quality = 2.0; weight = $w } }; $o }
$coreArmor = [ordered]@{ key = 'core_armor'; types = @('apotheosis:chestplate', 'apotheosis:leggings') }
$lightWeapon = [ordered]@{ key = 'light_weapon'; types = @('apotheosis:melee_weapon', 'apotheosis:trident') }
$fin = Tiers @('summit', 'pinnacle') 40
$milieu = Tiers @('frontier', 'ascent', 'summit', 'pinnacle') 30
$tard = Tiers @('ascent', 'summit', 'pinnacle') 30
$end = [ordered]@{ dimensions = @('minecraft:the_end') }
$gemmes = @(
    # --- End
    @{ path = 'the_end/apesanteur'; fr = "Gemme d'Apesanteur"; en = 'Weightless Gem'; color = 0x8FE3E0; c = $end; w = $fin; bonuses = @(
            [ordered]@{ type = 'apotheosis:multi_attribute'; desc = 'bonus.apotheosis:multi_attr.desc.and'; gem_class = 'apotheosis:boots'; modifiers = @(
                    [ordered]@{ attribute = 'minecraft:generic.safe_fall_distance'; operation = 'add_value'; values = (V @(4, 8, 16)) },
                    [ordered]@{ attribute = 'minecraft:generic.fall_damage_multiplier'; operation = 'add_multiplied_total'; values = (V @(-0.25, -0.5, -0.75)) }) },
            (Eff $coreArmor 'minecraft:slow_falling' 'hurt_self' @(60, 80, 100) @(0, 0, 0) 200),
            (Eff 'apotheosis:bow' 'minecraft:levitation' 'arrow_target' @(40, 60, 80) @(0, 0, 0) 100)) }
    @{ path = 'the_end/neant'; fr = 'Gemme du Néant'; en = 'Void Gem'; color = 0x5B2A86; c = $end; w = $fin; bonuses = @(
            (Eff $lightWeapon 'minecraft:levitation' 'attack_target' @(20, 30, 40) @(0, 0, 0) 80),
            (Eff 'apotheosis:shield' 'minecraft:levitation' 'block_attacker' @(40, 60, 80) @(0, 0, 0) 200),
            (Red $coreArmor 'explosion' @(0.15, 0.25, 0.35))) }
    @{ path = 'the_end/chorale'; fr = 'Gemme Chorale'; en = 'Chorus Gem'; color = 0xB57EDC; c = $end; w = $fin; bonuses = @(
            (Att 'apotheosis:helmet' 'irons_spellbooks:summon_damage' 'add_multiplied_base' @(0.10, 0.15, 0.25)),
            (Att 'apotheosis:chestplate' 'irons_spellbooks:casting_movespeed' 'add_multiplied_base' @(0.15, 0.25, 0.40)),
            (Att 'apotheosis:boots' 'minecraft:generic.jump_strength' 'add_multiplied_base' @(0.10, 0.20, 0.30))) }
    @{ path = 'the_end/coeur_de_dragon'; fr = 'Cœur de Dragon'; en = 'Dragonheart'; color = 0x7A1FA2; min = 'flawless'; c = $end; w = (Tiers @('pinnacle') 15); bonuses = @(
            (Att $lightWeapon 'apothic_attributes:current_hp_damage' 'add_value' @(0.04, 0.08)),
            [ordered]@{ type = 'apotheosis:attribute'; attribute = 'apothic_attributes:elytra_flight'; gem_class = 'apotheosis:chestplate'; operation = 'add_value'; values = [ordered]@{ perfect = 1.0 } },
            (Red 'apotheosis:helmet' 'fire' @(0.20, 0.35))) }
    @{ path = 'the_end/cristal'; fr = 'Gemme de Cristal'; en = 'Crystal Gem'; color = 0xF2A7D8; c = $end; w = $fin; bonuses = @(
            (Eff 'apotheosis:chestplate' 'minecraft:regeneration' 'hurt_self' @(60, 80, 100) @(0, 0, 1) 300),
            (Att 'apotheosis:helmet' 'apothic_attributes:overheal' 'add_value' @(0.10, 0.20, 0.30))) }
    @{ path = 'the_end/shulker'; fr = 'Gemme de Shulker'; en = 'Shulker Gem'; color = 0xA97CA9; c = $end; w = $fin; bonuses = @(
            (Red $coreArmor 'projectile' @(0.15, 0.25, 0.35)),
            (Eff 'apotheosis:helmet' 'minecraft:levitation' 'hurt_attacker' @(40, 60, 80) @(0, 0, 0) 200)) }
    @{ path = 'the_end/prospecteur'; fr = 'Gemme du Prospecteur'; en = "Prospector's Gem"; color = 0xDCDB9C; c = $end; w = $fin
        desc = @{ fr = "Casser de la pierre de l'End a %s%% de chances de donner une perle de l'Ender."; en = 'Breaking End Stone has a %s%% chance to drop an Ender Pearl instead.' }; bonuses = @(
            [ordered]@{ type = 'apotheosis:drop_transform'; conditions = @([ordered]@{ condition = 'apotheosis:matches_block'; valid_blocks = 'minecraft:end_stone' }); desc = 'gem.pack_lbc:the_end/prospecteur.bonus.pickaxe'; gem_class = 'apotheosis:breaker'; inputs = [ordered]@{ item = 'minecraft:end_stone' }; output = [ordered]@{ count = 1; id = 'minecraft:ender_pearl' }; values = (V @(0.05, 0.10, 0.15)) }) }
    # --- Cavernes de l'Overworld (biomes)
    @{ path = 'cavernes/sculk'; fr = 'Gemme du Sculk'; en = 'Sculk Gem'; color = 0x0F5A66; min = 'flawed'; w = $milieu
        c = [ordered]@{ biomes = @('minecraft:deep_dark', 'deeperdarker:blooming_caverns', 'deeperdarker:deeplands', 'deeperdarker:echoing_forest', 'deeperdarker:overcast_columns') }; bonuses = @(
            (Eff 'apotheosis:helmet' 'minecraft:glowing' 'hurt_attacker' @(100, 160, 200, 300) @(0, 0, 0, 0) 60),
            (Att 'apotheosis:boots' 'minecraft:player.sneaking_speed' 'add_value' @(0.10, 0.20, 0.30, 0.45)),
            (Eff $lightWeapon 'minecraft:blindness' 'attack_target' @(40, 60, 80, 100) @(0, 0, 0, 0) 100)) }
    @{ path = 'cavernes/filon'; fr = 'Gemme du Filon'; en = 'Lode Gem'; color = 0xC08A55; min = 'flawed'; w = $milieu; c = [ordered]@{ biomes = @('minecraft:dripstone_caves', 'minecraft:lush_caves') }
        desc = @{ fr = "Casser de l'ardoise des abîmes a %s%% de chances de donner du fer brut."; en = 'Breaking Deepslate has a %s%% chance to drop Raw Iron instead.' }; bonuses = @(
            [ordered]@{ type = 'apotheosis:drop_transform'; conditions = @([ordered]@{ condition = 'apotheosis:matches_block'; valid_blocks = 'minecraft:deepslate' }); desc = 'gem.pack_lbc:cavernes/filon.bonus.pickaxe'; gem_class = 'apotheosis:breaker'; inputs = [ordered]@{ item = 'minecraft:cobbled_deepslate' }; output = [ordered]@{ count = 1; id = 'minecraft:raw_iron' }; values = (V @(0.02, 0.04, 0.06, 0.08)) },
            (Att 'apotheosis:leggings' 'minecraft:player.mining_efficiency' 'add_value' @(2, 4, 6, 9))) }
    @{ path = 'cavernes/toxique'; fr = 'Gemme Toxique'; en = 'Toxic Gem'; color = 0x7CC242; min = 'flawed'; w = $tard; c = [ordered]@{ biomes = @('alexscaves:toxic_caves') }; bonuses = @(
            (Eff $lightWeapon 'minecraft:poison' 'attack_target' @(60, 80, 100, 140) @(0, 0, 1, 1) 60),
            (Eff 'apotheosis:helmet' 'minecraft:nausea' 'hurt_attacker' @(60, 80, 100, 140) @(0, 0, 0, 0) 200)) }
    @{ path = 'cavernes/magnetique'; fr = 'Gemme Magnétique'; en = 'Magnetic Gem'; color = 0xB33A3A; min = 'flawed'; w = $tard; c = [ordered]@{ biomes = @('alexscaves:magnetic_caves') }; bonuses = @(
            (Eff $lightWeapon 'minecraft:slowness' 'attack_target' @(40, 60, 80, 80) @(0, 0, 0, 1) 60),
            (Att 'apotheosis:chestplate' 'minecraft:generic.explosion_knockback_resistance' 'add_value' @(0.25, 0.5, 0.75, 1.0))) }
    @{ path = 'cavernes/primordiale'; fr = 'Gemme Primordiale'; en = 'Primordial Gem'; color = 0xD9822B; min = 'flawed'; w = $tard; c = [ordered]@{ biomes = @('alexscaves:primordial_caves') }; bonuses = @(
            (Att 'apotheosis:melee_weapon' 'minecraft:player.sweeping_damage_ratio' 'add_value' @(0.10, 0.20, 0.30, 0.45)),
            (Red 'apotheosis:leggings' 'fall' @(0.20, 0.30, 0.40, 0.50))) }
    @{ path = 'cavernes/abysses'; fr = 'Gemme des Abysses'; en = 'Abyssal Gem'; color = 0x1E4FA8; min = 'flawed'; w = $tard
        c = [ordered]@{ biomes = @('alexscaves:abyssal_chasm', 'minecraft:deep_ocean', 'minecraft:deep_cold_ocean', 'minecraft:deep_lukewarm_ocean', 'minecraft:deep_frozen_ocean') }; bonuses = @(
            (Att 'apotheosis:helmet' 'minecraft:generic.oxygen_bonus' 'add_value' @(1, 2, 3, 4)),
            (Att 'apotheosis:boots' 'minecraft:generic.water_movement_efficiency' 'add_value' @(0.15, 0.25, 0.35, 0.5)),
            (Eff 'apotheosis:chestplate' 'minecraft:conduit_power' 'hurt_self' @(100, 140, 200, 300) @(0, 0, 0, 0) 300)) }
    # --- Autres dimensions
    @{ path = 'the_nether/cendre'; fr = 'Gemme de Cendre'; en = 'Ash Gem'; color = 0x6E6A66; min = 'flawed'; w = $tard; c = [ordered]@{ dimensions = @('minecraft:the_nether') }; bonuses = @(
            (Att 'apotheosis:chestplate' 'minecraft:generic.burning_time' 'add_multiplied_total' @(-0.2, -0.3, -0.4, -0.5)),
            (Eff $lightWeapon 'minecraft:wither' 'attack_target' @(40, 60, 80, 80) @(0, 0, 0, 1) 80)) }
    @{ path = 'twilight/liche'; fr = 'Gemme de la Liche'; en = "Lich's Gem"; color = 0x9FB7C9; min = 'flawed'; w = $milieu; c = [ordered]@{ dimensions = @('twilightforest:twilight_forest') }; bonuses = @(
            (Eff $lightWeapon 'minecraft:weakness' 'attack_target' @(60, 80, 100, 100) @(0, 0, 0, 1) 80),
            (Eff 'apotheosis:helmet' 'minecraft:mining_fatigue' 'hurt_attacker' @(60, 80, 100, 100) @(0, 0, 0, 1) 200)) }
    @{ path = 'aether/celeste'; fr = 'Gemme Céleste'; en = 'Celestial Gem'; color = 0xF5E27A; min = 'flawed'; w = $tard; c = [ordered]@{ dimensions = @('aether:the_aether') }; bonuses = @(
            (Att 'apotheosis:bow' 'apothic_attributes:projectile_damage' 'add_multiplied_total' @(0.05, 0.10, 0.15, 0.20)),
            (Red 'apotheosis:chestplate' 'lightning' @(0.20, 0.30, 0.40, 0.50))) }
)
# Texture 16x16 d'une gemme taillee : contour, ombre, teinte, clair, reflet (couleurs derivees de la teinte de la gemme)
$motif = @('................', '................', '....oooooooo....', '...ohhlllmmdo...', '..ohhllllmmmdo..', '.ohlllllmmmmddo.', '.oooooooooooooo.', '.olhllmmmmmdddo.', '..olllmmmmmddo..', '...ollmmmmddo...', '....olmmmmdo....', '.....olmmdo.....', '......omdo......', '.......oo.......', '................', '................')
Add-Type -AssemblyName System.Drawing
function Gemme-Png($path, [int]$rgb) {
    $c0 = @((($rgb -shr 16) -band 255), (($rgb -shr 8) -band 255), ($rgb -band 255))
    $pal = @{}
    foreach ($e in @(@('o', -0.7), @('d', -0.35), @('m', 0.0), @('l', 0.3), @('h', 0.65))) {
        $f = [double]$e[1]
        $v = foreach ($x in $c0) { if ($f -ge 0) { [int]($x + (255 - $x) * $f) } else { [int]($x * (1 + $f)) } }
        $pal[$e[0]] = [Drawing.Color]::FromArgb(255, $v[0], $v[1], $v[2])
    }
    $bmp = New-Object Drawing.Bitmap 16, 16
    for ($y = 0; $y -lt 16; $y++) { for ($x = 0; $x -lt 16; $x++) { $c = [string]$motif[$y][$x]; $bmp.SetPixel($x, $y, $(if ($c -eq '.') { [Drawing.Color]::Transparent } else { $pal[$c] })) } }
    New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null
    $bmp.Save($path, [Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()
}
$texGemmes = Join-Path $rp 'pack_lbc\textures\item\gems'
if (Test-Path $texGemmes) { Remove-Item -LiteralPath $texGemmes -Recurse -Force }
# Apotheosis cherche le modele d'une gemme dans apotheosis:item/gems/<chemin>, quel que soit son espace de noms
$modGemmes = Join-Path $rp 'apotheosis\models\item\gems'
$ancienMod = Join-Path $rp 'pack_lbc\models\item\gems'
if (Test-Path $ancienMod) { Remove-Item -LiteralPath $ancienMod -Recurse -Force }
if (Test-Path $modGemmes) { Remove-Item -LiteralPath $modGemmes -Recurse -Force }
$langFr = [ordered]@{}; $langEn = [ordered]@{}
foreach ($gm in $gemmes) {
    $obj = [ordered]@{ type = 'apotheosis:gem'; constraints = $gm.c; min_purity = $(if ($gm.min) { $gm.min } else { 'normal' }); unique = $true; weights = $gm.w; bonuses = $gm.bonuses }
    W "data/pack_lbc/gems/$($gm.path).json" $obj
    RW "apotheosis/models/item/gems/$($gm.path).json" (([ordered]@{ parent = 'item/generated'; textures = [ordered]@{ layer0 = "pack_lbc:item/gems/$($gm.path)" } }) | ConvertTo-Json)
    Gemme-Png ((Join-Path $texGemmes ($gm.path -replace '/', '\')) + '.png') $gm.color
    $langFr["item.apotheosis.gem.pack_lbc:$($gm.path)"] = $gm.fr; $langEn["item.apotheosis.gem.pack_lbc:$($gm.path)"] = $gm.en
    if ($gm.desc) { $langFr["gem.pack_lbc:$($gm.path).bonus.pickaxe"] = $gm.desc.fr; $langEn["gem.pack_lbc:$($gm.path).bonus.pickaxe"] = $gm.desc.en }
}
RW 'pack_lbc_gemmes/lang/fr_fr.json' ($langFr | ConvertTo-Json)
RW 'pack_lbc_gemmes/lang/en_us.json' ($langEn | ConvertTo-Json)

# Elites : apparition naturelle seulement (pas d'oeuf, de generateur ni d'invocation), equipement du palier du joueur
$pasInvoque = [ordered]@{ type = 'apotheosis:not'; spawn_condition = [ordered]@{ type = 'apotheosis:spawn_type'; spawn_types = @('spawn_egg', 'spawner', 'mob_summoned') } }
$sousTerre = [ordered]@{ type = 'apotheosis:surface_type'; surface_type = 'below_surface' }
function Mod($attr, $op, $val) { [ordered]@{ attribute = $attr; operation = $op; value = $val } }
function Vie($min, $max) { Mod 'minecraft:generic.max_health' 'add_value' ([ordered]@{ min = [double]$min; max = [double]$max }) }
function Elite($nom, $entities, $c, $tiers, $kind, $mods, $effects, $aura, $chance, [switch]$Sous) {
    $poidsE = [ordered]@{}; $gear = [ordered]@{}
    foreach ($t in $tiers) { $poidsE[$t] = [ordered]@{ quality = 0.1; weight = 100 }; $gear[$t] = @("#${t}_$kind") }
    $conds = @($pasInvoque); if ($Sous) { $conds += $sousTerre }
    $basic = [ordered]@{ constraints = $c; name = $nom; spawn_conditions = $conds; valid_gear_sets = $gear; weights = $poidsE }
    if ($aura) { $basic.nbt = [ordered]@{ Passengers = @([ordered]@{ id = 'minecraft:area_effect_cloud'; Duration = 200000; Radius = 3.0; ReapplicationDelay = 20; WaitTime = 0; Particle = [ordered]@{ type = 'entity_effect'; color = 0 }; potion_contents = [ordered]@{ custom_effects = @($aura | ForEach-Object { [ordered]@{ id = $_; amplifier = 0; duration = 60 } }) } }) } }
    $stats = [ordered]@{ attribute_modifiers = $mods }
    if ($effects) { $stats.effects = @($effects | ForEach-Object { [ordered]@{ amplifier = [double]$_[1]; effect = $_[0] } }) }
    $stats.enchant_chance = 0.3; $stats.enchantment_levels = [ordered]@{ primary = 25; secondary = 15 }
    [ordered]@{ type = 'apotheosis:elite'; affix_data = [ordered]@{ affix_chance = 0.4 }; basic_data = $basic; entities = $entities; stats = $stats; success_chance = $chance }
}
$ow = [ordered]@{ dimensions = @('minecraft:overworld') }
$tousPaliers = @('haven', 'frontier', 'ascent', 'summit', 'pinnacle')
$pal3 = @('ascent', 'summit', 'pinnacle')
$endermen = @('minecraft:enderman', 'endermanoverhaul:end_enderman', 'endermanoverhaul:end_islands_enderman')
$elites = [ordered]@{
    'the_end/sentinelle_du_vide' = (Elite 'Sentinelle du Vide' $endermen $end $pal3 'melee' @((Vie 40 80), (Mod 'minecraft:generic.attack_damage' 'add_multiplied_total' 0.5), (Mod 'minecraft:generic.armor' 'add_value' 10.0), (Mod 'minecraft:generic.knockback_resistance' 'add_value' 1.0)) @(, @('minecraft:resistance', 0)) $null 0.02)
    'the_end/assassin_de_l_ender' = (Elite "Assassin de l'Ender" $endermen $end $pal3 'melee' @((Vie 20 40), (Mod 'minecraft:generic.attack_damage' 'add_multiplied_total' 1.0), (Mod 'minecraft:generic.movement_speed' 'add_multiplied_base' 0.3), (Mod 'apothic_attributes:crit_chance' 'add_value' 0.3)) @(, @('minecraft:speed', 1)) $null 0.015)
    'the_end/gardien_shulker' = (Elite 'Gardien Shulker' @('minecraft:shulker') $end $pal3 'ranged' @((Vie 30 50), (Mod 'minecraft:generic.armor' 'add_value' 10.0)) $null @('minecraft:slowness', 'minecraft:weakness') 0.06)
    'cavernes/mineur_maudit' = (Elite 'Mineur Maudit' @('minecraft:zombie') $ow $tousPaliers 'melee' @((Vie 20 40), (Mod 'minecraft:generic.armor' 'add_value' 6.0), (Mod 'minecraft:generic.knockback_resistance' 'add_value' 0.5)) @(, @('minecraft:haste', 1)) $null 0.01 -Sous)
    'cavernes/matriarche_des_profondeurs' = (Elite 'Matriarche des Profondeurs' @('minecraft:spider', 'minecraft:cave_spider') $ow $tousPaliers 'melee' @((Vie 20 40), (Mod 'minecraft:generic.attack_damage' 'add_multiplied_total' 0.5)) $null @('minecraft:poison') 0.01 -Sous)
    'the_nether/spectre_de_cendre' = (Elite 'Spectre de Cendre' @('minecraft:blaze') ([ordered]@{ dimensions = @('minecraft:the_nether') }) $pal3 'ranged' @((Vie 30 50), (Mod 'apothic_attributes:fire_damage' 'add_value' 4.0), (Mod 'minecraft:generic.armor' 'add_value' 6.0)) $null @('minecraft:weakness') 0.03)
    'the_nether/brute_dechue' = (Elite 'Brute Déchue' @('minecraft:zombified_piglin', 'minecraft:piglin') ([ordered]@{ dimensions = @('minecraft:the_nether') }) $pal3 'melee' @((Vie 30 60), (Mod 'minecraft:generic.attack_damage' 'add_multiplied_total' 0.5), (Mod 'minecraft:generic.armor' 'add_value' 8.0), (Mod 'minecraft:generic.knockback_resistance' 'add_value' 0.6)) $null $null 0.015)
    'twilight/druide_de_la_liche' = (Elite 'Druide de la Liche' @('twilightforest:skeleton_druid') ([ordered]@{ dimensions = @('twilightforest:twilight_forest') }) @('frontier', 'ascent', 'summit', 'pinnacle') 'ranged' @((Vie 20 40), (Mod 'minecraft:generic.armor' 'add_value' 6.0)) @(, @('minecraft:resistance', 0)) @('minecraft:slowness') 0.04)
    'twilight/spectre_errant' = (Elite 'Spectre Errant' @('twilightforest:wraith') ([ordered]@{ dimensions = @('twilightforest:twilight_forest') }) @('frontier', 'ascent', 'summit', 'pinnacle') 'melee' @((Vie 20 40), (Mod 'minecraft:generic.movement_speed' 'add_multiplied_base' 0.2)) $null @('minecraft:weakness') 0.05)
    'aether/valkyrie_dechue' = (Elite 'Valkyrie Déchue' @('aether:valkyrie') ([ordered]@{ dimensions = @('aether:the_aether') }) $pal3 'melee' @((Vie 30 50), (Mod 'minecraft:generic.attack_damage' 'add_multiplied_total' 0.5), (Mod 'minecraft:generic.armor' 'add_value' 8.0)) $null $null 0.05)
    'aether/zephyr_furieux' = (Elite 'Zéphyr Furieux' @('aether:zephyr') ([ordered]@{ dimensions = @('aether:the_aether') }) $pal3 'ranged' @((Vie 30 60)) @(, @('minecraft:resistance', 0)) $null 0.05)
    'otherside/rodeur_du_sculk' = (Elite 'Rôdeur du Sculk' @('deeperdarker:shattered') ([ordered]@{ dimensions = @('deeperdarker:otherside') }) @('summit', 'pinnacle') 'melee' @((Vie 40 80), (Mod 'minecraft:generic.armor' 'add_value' 8.0)) $null @('minecraft:darkness') 0.05)
    'alexscaves/gardien_magnetique' = (Elite 'Gardien Magnétique' @('alexscaves:magnetron') $ow $pal3 'melee' @((Vie 30 60), (Mod 'minecraft:generic.armor' 'add_value' 8.0)) $null @('minecraft:slowness') 0.05)
    'alexscaves/raptor_alpha' = (Elite 'Raptor Alpha' @('alexscaves:vallumraptor') $ow $pal3 'melee' @((Vie 20 40), (Mod 'minecraft:generic.attack_damage' 'add_multiplied_total' 0.5), (Mod 'minecraft:generic.movement_speed' 'add_multiplied_base' 0.2)) $null $null 0.04)
    'alexscaves/rejeton_radioactif' = (Elite 'Rejeton Radioactif' @('alexscaves:nucleeper') $ow $pal3 'melee' @((Vie 20 40)) @(, @('minecraft:resistance', 0)) @('minecraft:poison') 0.04)
    'alexscaves/chevalier_des_profondeurs' = (Elite 'Chevalier des Profondeurs' @('alexscaves:deep_one_knight') $ow $pal3 'melee' @((Vie 30 60), (Mod 'minecraft:generic.armor' 'add_value' 8.0), (Mod 'minecraft:generic.knockback_resistance' 'add_value' 0.5)) $null $null 0.04)
    'alexscaves/veilleur_oublie' = (Elite 'Veilleur Oublié' @('alexscaves:watcher') $ow $pal3 'melee' @((Vie 30 50)) $null @('minecraft:blindness') 0.04)
}
foreach ($k in $elites.Keys) { W "data/pack_lbc/apothic_elites/$k.json" $elites[$k] }

# ---------- 19. Unification des metaux (Almost Unified, config/almostunified/unification/materials.json) ----------
# Almost Unified ne voit que les objets ranges dans les tags communs c: ; ces objets n'y etaient pas.
# Platine : celui de Create Propulsion est prioritaire, le minerai de Wyrmroost ne se genere plus
# (biome_modifier platinum_ore neutralise dans scripts/data/structure_set_overrides).
$unif = [ordered]@{
    'ingots/platinum'             = @('wyrmroost:platinum_ingot')
    'ores/platinum'               = @('wyrmroost:platinum_ore')
    'raw_materials/platinum'      = @('wyrmroost:raw_platinum')
    'storage_blocks/platinum'     = @('wyrmroost:platinum_block')
    'storage_blocks/raw_platinum' = @('wyrmroost:raw_platinum_block')
    'nuggets/steel'               = @('hazennstuff:steel_nugget')
}
foreach ($k in $unif.Keys) { W "data/c/tags/item/$k.json" ([ordered]@{ replace = $false; values = $unif[$k] }) }
# Tag propre a Wyrmroost (10 recettes d'outils et d'armures en platine) : Almost Unified ne le modifie pas -> on y ajoute le platine prioritaire.
W 'data/wyrmroost/tags/item/platinum_ingots.json' ([ordered]@{ replace = $false; values = @('createpropulsion:platinum_ingot') })

# ---------- 20. Sorts desactives ----------
# Pumpkin Bomb (Somake Spells 1.0.8) : sa zone pose un effet non enregistre (Holder.direct) ; Relics le sauvegarde -> exception,
# Neruina tue la zone puis expulse le joueur quand l'effet se termine.
W 'data/somakespells/irons_spellbooks_spell_config/pumpkin_bomb.json' ([ordered]@{ 'irons_spellbooks:enabled' = $false })

# ---------- 21. Tags et donnees casses par des fautes de frappe dans les mods ----------
# Une reference obligatoire inconnue fait echouer TOUT le tag. replace = true efface les fichiers des mods (pack_lbc charge apres eux) :
# listes reprises de chaque jar -> A METTRE A JOUR si un mod de la liste ajoute des entrees.
# minecraft:enchantable/equippable : Deeper and Darker: Spellbooks ecrit darkermagic:whispers_staff (l'objet est whisper_staff).
# Tag vide = Malediction du lien impossible + c:enchantables (NeoForge) casse lui aussi.
$equippable = @('#minecraft:foot_armor', '#minecraft:leg_armor', '#minecraft:chest_armor', '#minecraft:head_armor', 'minecraft:elytra', '#minecraft:skulls', 'minecraft:carved_pumpkin') +
    (OptT (@('#minecraft:enchantable/armor', 'darkermagic:whisper_staff', 'deeperdarker:soul_elytra', 'redomesticate:collar_tag') +
        @('helmet', 'chestplate', 'leggings', 'boots' | ForEach-Object { "#hazennstuff:armors/hns_$_" }) +
        @('ignis_leggings', 'abyssal_warlock_leggings', 'cursium_mage_skirt', 'ignis_helmet', 'abyssal_warlock_helmet', 'abyssal_warlock_mask', 'cursium_mage_circlet',
          'ignis_boots', 'abyssal_warlock_boots', 'cursium_mage_boots', 'ignis_chestplate', 'ignis_chestplate_elytra', 'abyssal_warlock_chestplate',
          'cursium_mage_chestplate', 'cursium_mage_elytra' | ForEach-Object { "cataclysm_spellbooks:$_" })))
W 'data/minecraft/tags/item/enchantable/equippable.json' ([ordered]@{ replace = $true; values = $equippable; remove = @('twilightforest:phantom_helmet', 'twilightforest:phantom_chestplate') })
# relics:relics : Reliquified Iron's Spells ecrit bloodied_voodoo_doll (l'objet est bloody_voodoo_doll) -> ses 24 reliques hors du tag.
$reliquesMages = @('bloody_voodoo_doll', 'cardiac_trap', 'cloak_of_the_bloody_feather', 'dimension_key', 'dragon_blood_vial',
    'echo_glove', 'ender_bow', 'galaxy_devourer_diadem', 'flask_of_the_red_mist', 'hat_of_omniscience', 'immaterial_disperser', 'living_flesh', 'lunar_sextant',
    'mirror_of_transgression', 'mask_of_hunger', 'pulsar_mantle', 'ring_of_blades', 'ring_of_elusiveness', 'sealed_claymore', 'sealed_rapier', 'sealed_sword',
    'shadow_claws', 'sinner_crown', 'slicer' | ForEach-Object { "reliquified_irons_spells_and_spellbooks:$_" })
W 'data/relics/tags/item/relics.json' ([ordered]@{ replace = $true; values = (OptT $reliquesMages) })
# Sable Physics Compat 1.3.0 : physics_block_properties/float.json est un tableau (ancien format, 1 objet par fichier attendu) -> rejete.
# Repris pour les mods presents : gravitite enchantee et nuages de l'Aether, nuages du Twilight flottent comme la levitite.
function Flotte($sel, $scale) { [ordered]@{ selector = $sel; properties = [ordered]@{ 'sable:floating_material' = 'aeronautics:levitite'; 'sable:floating_scale' = $scale } } }
W 'data/sable/physics_block_properties/float.json' (Flotte 'aether:enchanted_gravitite' 4.0)
W 'data/sable/physics_block_properties/lbc_float_aerclouds.json' (Flotte '#aether:aerclouds' 1.0)
W 'data/sable/physics_block_properties/lbc_float_tf_clouds.json' (Flotte '#twilightforest:clouds' 1.0)
W 'data/sable/physics_block_properties/lbc_float_chromatic_aercloud.json' (Flotte 'aether:chromatic_aercloud' 6.0)
# Son tags/block/bouncy.json a une virgule finale -> fichier ignore (le slime de Sable reste). Seul bloc present dans le pack : Sundrop d'Alex's Caves.
W 'data/sable/tags/block/bouncy.json' ([ordered]@{ replace = $false; values = @(OptT @('alexscaves:sundrop')) })

# ---------- 22. Tables tirees par les caisses de FTB Quests (recompense "commande" : loot give {p} loot pack_lbc:caisses/...) ----------
# Les caisses elles-memes : config/ftbquests/quests/reward_tables, generees par scripts/quests/build-crates.ps1.
function Caisse($nom, $entries) { W "data/pack_lbc/loot_table/caisses/$nom.json" ([ordered]@{ type = 'minecraft:chest'; pools = @([ordered]@{ rolls = 1; entries = @($entries) }) }) }
# Equipement des caisses : objet tire au niveau de la caisse (diamant / netherite), puis forge a sa rarete (apotheosis:reforge_item).
# random_affix_item tirait l'objet au palier du joueur : une epee en pierre mythique en Havre.
$moddes = Import-Csv (Join-Path $PSScriptRoot 'data\affix_moddes.csv')
function Equip($nom, $rar, $vanilla, $niveaux) {
    $fams = [ordered]@{ vanilla = @($vanilla); simplyswords = @(); epicknights_armes = @(); epicknights_armures = @(); aether = @(); deeperdarker = @() }
    foreach ($m in $moddes | Where-Object { $_.niveau -in $niveaux }) { $fams[$m.famille] += $m.item }
    $parts = @{ vanilla = 40; simplyswords = 20; epicknights_armes = 15; epicknights_armures = 15; aether = 5; deeperdarker = 5 }
    $entries = foreach ($f in $fams.Keys) { foreach ($i in $fams[$f]) {
        $w = $parts[$f] * 20 / $fams[$f].Count; if ($i -match '_(pickaxe|shovel)$') { $w /= 2 }
        [ordered]@{ type = 'minecraft:item'; name = $i; weight = [Math]::Max(1, [int][Math]::Round($w)); functions = @([ordered]@{ function = 'apotheosis:reforge_item'; rarities = @($rar) }) } } }
    Caisse $nom $entries
}
$tw = 'twilightforest'
Equip 'equipement_epique' 'apotheosis:epic' (@('sword', 'axe', 'pickaxe', 'shovel', 'helmet', 'chestplate', 'leggings', 'boots' | ForEach-Object { "minecraft:diamond_$_" }) + @('minecraft:trident', 'minecraft:bow', 'minecraft:crossbow') +
    @('knightmetal_sword', 'knightmetal_axe', 'knightmetal_pickaxe', 'knightmetal_helmet', 'knightmetal_chestplate', 'knightmetal_leggings', 'knightmetal_boots', 'fiery_sword', 'fiery_pickaxe',
      'fiery_helmet', 'fiery_chestplate', 'fiery_leggings', 'fiery_boots', 'arctic_helmet', 'arctic_chestplate', 'arctic_leggings', 'arctic_boots', 'ice_sword', 'ice_bow', 'seeker_bow' | ForEach-Object { "${tw}:$_" })) @('diamant')
Equip 'equipement_mythique' 'apotheosis:mythic' (@('sword', 'axe', 'pickaxe', 'shovel', 'helmet', 'chestplate', 'leggings', 'boots' | ForEach-Object { "minecraft:netherite_$_" }) +
    @('giant_sword', 'giant_pickaxe', 'glass_sword', 'yeti_helmet', 'yeti_chestplate', 'yeti_leggings', 'yeti_boots', 'triple_bow', 'ender_bow' | ForEach-Object { "${tw}:$_" })) @('netherite', 'warden')
# Artefacts : devenus des reliques avec Reliquified Artifacts (liste = config/reliquified_artifacts/relics/*.yaml du 1er lancement)
$artefacts = @('anglers_hat', 'antidote_vessel', 'aqua_dashers', 'bunny_hoppers', 'charm_of_shrinking', 'charm_of_sinking', 'chorus_totem', 'cloud_in_a_bottle',
    'cowboy_hat', 'cross_necklace', 'crystal_heart', 'digging_claws', 'eternal_steak', 'everlasting_beef', 'feral_claws', 'fire_gauntlet', 'flame_pendant', 'flippers',
    'golden_hook', 'helium_flamingo', 'kitty_slippers', 'lucky_scarf', 'night_vision_goggles', 'novelty_drinking_hat', 'obsidian_skull', 'onion_ring', 'panic_necklace',
    'pickaxe_heater', 'plastic_drinking_hat', 'pocket_piston', 'power_glove', 'rooted_boots', 'running_shoes', 'scarf_of_invisibility', 'shock_pendant', 'snorkel',
    'snowshoes', 'steadfast_spikes', 'strider_shoes', 'superstitious_hat', 'thorn_pendant', 'umbrella', 'universal_attractor', 'vampiric_glove', 'villager_hat',
    'warp_drive', 'whoopee_cushion', 'withered_bracelet' | ForEach-Object { "artifacts:$_" })
Caisse 'relique' @(@($reliques | ForEach-Object { "relics:$_" }) + $reliquesMages + $artefacts | ForEach-Object { [ordered]@{ type = 'minecraft:item'; name = $_ } })
# Parchemins : meme liste de sorts que le butin d'Iron's (sans Apex Arcana, section 17), qualite croissante selon la caisse
$sorts = ((Get-Content (Join-Path $PSScriptRoot 'data\spell_loot\data\irons_spellbooks\loot_table\test\scroll_gen.json') -Raw | ConvertFrom-Json).pools[0].entries[0].functions | Where-Object { $_.function -eq 'irons_spellbooks:randomize_spell' }).spell_filter
foreach ($p in @(@('parchemin_rare', 0.15, 0.45), @('parchemin_epique', 0.4, 0.75), @('parchemin_legendaire', 0.7, 1.0))) {
    Caisse $p[0] @([ordered]@{ type = 'minecraft:item'; name = 'irons_spellbooks:scroll'; functions = @([ordered]@{ function = 'irons_spellbooks:randomize_spell'; quality = [ordered]@{ min = $p[1]; max = $p[2] }; spell_filter = $sorts }) })
}
# Perles de portail (Gateways to Eternity) : nos portails, le defi final deux fois plus rare
$portails = [ordered]@{ nuit_sans_fin = 2; sabbat_citrouilles = 2; morts_sans_repos = 2; echo_profondeurs = 2; gardiens_sorcellerie = 2; citadelle_ender = 2; defi_seigneurs = 1 }
Caisse 'perle_portail' @($portails.Keys | ForEach-Object { [ordered]@{ type = 'minecraft:item'; name = 'gateways:gate_pearl'; weight = $portails[$_]; functions = @([ordered]@{ function = 'minecraft:set_components'; components = [ordered]@{ 'gateways:gateway' = "pack_lbc:$_" } }) } })

# ---------- 23. Tetes : joueur tue par un joueur, monstres moddes qui ont une tete sans drop ----------
# Tetes des mobs vanilla : All The Heads (2,5 % tue par un joueur, +1 % par niveau de Butin). Meme chance ici pour les mobs moddes.
# Tete du joueur : seulement en PvP (killed_by_player), avec son skin (fill_player_head this). Pas de liste de pseudos.
function Tete($nom, $item, $fill) {
    $e = [ordered]@{ type = 'minecraft:item'; name = $item }
    if ($fill) { $e.functions = @([ordered]@{ function = 'minecraft:fill_player_head'; entity = 'this' }) }
    W "data/pack_lbc/loot_table/tetes/$nom.json" ([ordered]@{ type = 'minecraft:entity'; pools = @([ordered]@{ rolls = 1; entries = @($e) }) })
}
$chanceTete = [ordered]@{ condition = 'minecraft:random_chance_with_enchanted_bonus'; enchantment = 'minecraft:looting'; unenchanted_chance = 0.025
    enchanted_chance = [ordered]@{ type = 'minecraft:linear'; base = 0.035; per_level_above_first = 0.01 } }
Tete 'joueur' 'minecraft:player_head' $true
W 'data/pack_lbc/loot_modifiers/tetes/joueur.json' ([ordered]@{ type = 'neoforge:add_table'; conditions = @(
    [ordered]@{ condition = 'neoforge:loot_table_id'; loot_table_id = 'minecraft:entities/player' }, [ordered]@{ condition = 'minecraft:killed_by_player' }); table = 'pack_lbc:tetes/joueur' })
$glm += 'pack_lbc:tetes/joueur'
# Tetes des mods sans drop (verifie dans les jars : seulement des tables de blocs). Les boss (Twilight, Cataclysm, Mutant...) lachent deja la leur.
$tetesMods = [ordered]@{
    'rottencreatures:burned_head' = @('burned', 'burned_obsidian'); 'rottencreatures:dead_beard_head' = @('dead_beard'); 'rottencreatures:frostbitten_head' = @('frostbitten')
    'rottencreatures:glacial_hunter_head' = @('glacial_hunter'); 'rottencreatures:immortal_head' = @('immortal'); 'rottencreatures:mummy_head' = @('mummy')
    'rottencreatures:swampy_head' = @('swampy'); 'rottencreatures:zap_head' = @('zap')
    'rottencreatures:undead_miner_head' = @('undead_stone_miner', 'undead_iron_miner', 'undead_gold_miner', 'undead_diamond_miner')
    'cataclysm:draugr_head' = @('draugr', 'elite_draugr', 'royal_draugr'); 'cataclysm:aptrgangr_head' = @('aptrgangr')
}
foreach ($item in $tetesMods.Keys) {
    $ns = $item.Split(':')[0]; $nom = $item.Split(':')[1]
    Tete $nom $item $false
    $terms = @($tetesMods[$item] | ForEach-Object { [ordered]@{ condition = 'neoforge:loot_table_id'; loot_table_id = "${ns}:entities/$_" } })
    W "data/pack_lbc/loot_modifiers/tetes/$nom.json" ([ordered]@{ type = 'neoforge:add_table'; conditions = @(
        [ordered]@{ condition = 'minecraft:any_of'; terms = $terms }, [ordered]@{ condition = 'minecraft:killed_by_player' }, $chanceTete); table = "pack_lbc:tetes/$nom" })
    $glm += "pack_lbc:tetes/$nom"
}
W 'data/neoforge/loot_modifiers/global_loot_modifiers.json' ([ordered]@{ replace = $false; entries = $glm })

# ---------- 24. Petting 5 : friandises dorees et liste fermee de mobs apprivoisables ----------
# Petting 5 n'a plus de liste blanche : un mob s'apprivoise si son type est dans le tag de la friandise tenue.
# On remplace les 9 tags du mod (replace) : seuls nos mobs restent apprivoisables. Etoile doree vide et sans recette :
# elle apprivoisait boss et raiders, et posee sur l'oeuf de dragon elle fait renaitre l'Ender Dragon deja apprivoise.
$friandises = [ordered]@{
    golden_bone   = @('twilightforest:mist_wolf', 'twilightforest:winter_wolf', 'born_in_chaos_v1:dread_hound', 'born_in_chaos_v1:dire_hound_leader')
    golden_fish   = @('minecraft:polar_bear', 'born_in_chaos_v1:thornshell_crab', 'friendsandfoes:mauler', 'twilightforest:yeti',
        'mowziesmobs:naga', 'minecraft:dolphin', 'create_abyss:cookiecutter_shark')
    golden_fungus = @('minecraft:hoglin', 'minecraft:piglin_brute')
    golden_flesh  = @('minecraft:zoglin', 'twilightforest:troll', 'born_in_chaos_v1:felsteed', 'illagerinvasion:basher', 'illagerinvasion:marauder')
    golden_wheat  = @('twilightforest:boar', 'twilightforest:minotaur', 'minecraft:ravager', 'mowziesmobs:lantern', 'twilightforest:kobold', 'born_in_chaos_v1:pumpkin_bruiser',
        'aether:aerwhale')
    golden_eye    = @('minecraft:spider', 'deeperdarker:sculk_snapper', 'mowziesmobs:grottol', 'minecraft:iron_golem')
    golden_kelp   = @(); golden_slime = @(); golden_star = @()
}
foreach ($f in $friandises.Keys) { W "data/petting/tags/entity_type/tames_with/$f.json" ([ordered]@{ replace = $true; values = @(OptT $friandises[$f]) }) }
# Varech et slime dores n'apprivoisent plus rien : recettes retirees aussi
foreach ($r in @(@('golden_star', 'golden_star'), @('golden_kelp', 'golden_kelp'), @('golden_slime', 'golden_slime'), @('golden_slime_from_magma', 'golden_slime'))) {
    W "data/petting/recipe/$($r[0]).json" ([ordered]@{ 'neoforge:conditions' = @(@{ type = 'neoforge:false' }); type = 'minecraft:crafting_shapeless'; ingredients = @(@{ item = 'minecraft:barrier' }); result = @{ id = "petting:$($r[1])" } })
}

# ---------- 25. Apotheosis : armes et armures moddees dans le butin a affixes ----------
# Le butin aleatoire d'Apotheosis (coffres, monstres, envahisseurs) ne tire que dans sa liste d'objets de base (vanilla + Twilight).
# On y ajoute les series "par materiau" des mods (scripts/data/affix_moddes.csv, classe d'apres le metal / la protection),
# avec les poids du vanilla du meme niveau ramenes a une part du vanilla. Les armes uniques et de boss restent hors liste.
$paliers = [ordered]@{ havre = 'haven'; frontiere = 'frontier'; ascension = 'ascent'; sommet = 'summit'; apogee = 'pinnacle' }
foreach ($m in $moddes) {
    $w = [ordered]@{}; foreach ($p in $paliers.Keys) { if ([int]$m.$p -gt 0) { $w[$paliers[$p]] = [ordered]@{ weight = [int]$m.$p } } }
    W "data/pack_lbc/affix_loot_entries/$($m.famille)/$($m.item.Split(':')[1]).json" ([ordered]@{ type = 'apotheosis:affix_loot_entry'; stack = [ordered]@{ count = 1; id = $m.item }; weights = $w })
}

# ---------- 26. Caisses de quetes FTB : tirage de 2 a 5 recompenses ----------
# Contenu ecrit par scripts/quests/build-crates.ps1 (scripts/data/caisses_quetes.json, poids en %). La caisse FTB lance
# /loot give {p} loot pack_lbc:caisses_quete/<caisse> : 2 tirages garantis + binomiale 3 x 40 % -> 2 (22 %), 3 (43 %), 4 (29 %), 5 (6 %).
$cq = Get-Content (Join-Path $PSScriptRoot 'data\caisses_quetes.json') -Raw | ConvertFrom-Json
foreach ($n in $cq.PSObject.Properties.Name) {
    $entries = foreach ($r in $cq.$n) {
        if ($r.table) { [ordered]@{ type = 'minecraft:loot_table'; value = $r.table; weight = [int]$r.w } }
        else {
            $f = @(); if ([int]$r.count -gt 1) { $f += [ordered]@{ function = 'minecraft:set_count'; count = [int]$r.count } }
            if ($r.comps) { $comps = [ordered]@{}; $r.comps.PSObject.Properties | ForEach-Object { $comps[$_.Name] = $_.Value }; $f += [ordered]@{ function = 'minecraft:set_components'; components = $comps } }
            $e = [ordered]@{ type = 'minecraft:item'; name = $r.item; weight = [int]$r.w }; if ($f) { $e.functions = $f }; $e
        }
    }
    # communes et rares : 1 a 3 (1 + binomiale 2 x 45 % : 1 = 30 %, 2 = 50 %, 3 = 20 %) ; epiques et legendaires : 2 a 5
    $tirages = if ($n -in 'commune', 'rare') { @(1, 2, 0.45) } else { @(2, 3, 0.4) }
    W "data/pack_lbc/loot_table/caisses_quete/$n.json" ([ordered]@{ type = 'minecraft:chest'; pools = @(
        [ordered]@{ rolls = $tirages[0]; entries = @($entries) },
        [ordered]@{ rolls = [ordered]@{ type = 'minecraft:binomial'; n = $tirages[1]; p = $tirages[2] }; entries = @($entries) }) })
}

# ---------- 27. Audit d'equilibrage : recettes retirees ou adoucies ----------
# Encres epique et legendaire d'Iron's : seulement au chaudron d'alchimiste (4 fioles -> 1), comme le pack d'origine.
# Create Wizardry ajoutait des recettes au melangeur Create qui rendaient l'encre legendaire automatisable des le milieu de partie.
foreach ($r in 'irons_spellbooks:mixing/epic_ink', 'irons_spellbooks:mixing/epic_ink_mana_recipe', 'irons_spellbooks:mixing/legendary_ink',
    'irons_spellbooks:mixing/legendary_ink_mana_recipe', 'minecraft:mixing/cei_epic_ink_recipe', 'minecraft:mixing/cei_legendary_ink_recipe') {
    $ns, $chemin = $r.Split(':')
    W "data/$ns/recipe/$chemin.json" ([ordered]@{ 'neoforge:conditions' = @(@{ type = 'neoforge:false' }); type = 'minecraft:crafting_shapeless'; ingredients = @(@{ item = 'minecraft:barrier' }); result = @{ id = 'irons_spellbooks:epic_ink' } })
}
# Pomme de Notch de Create New Age : 4 blocs d'or + 4 eclats d'echo (au lieu de 8 blocs d'or) par pomme. L'or est illimite
# (fermes du Nether), les eclats d'echo viennent des cites antiques (et de l'infusion Apothic Enchanting, fin de partie).
$pommeI = [ordered]@{ item = 'create_new_age:incomplete_enchanted_golden_apple' }; $pommeR = @([ordered]@{ id = 'create_new_age:incomplete_enchanted_golden_apple' })
W 'data/create_new_age/recipe/sequenced_assembly/enchanted_golden_apple.json' ([ordered]@{ type = 'create:sequenced_assembly'; ingredient = @{ item = 'minecraft:apple' }; loops = 4
    results = @(@{ id = 'minecraft:enchanted_golden_apple' }); sequence = @(
        [ordered]@{ type = 'create_new_age:energising'; energy_needed = 2000000; ingredients = @($pommeI); results = $pommeR },
        [ordered]@{ type = 'create:deploying'; ingredients = @($pommeI, @{ tag = 'c:storage_blocks/gold' }); results = $pommeR },
        [ordered]@{ type = 'create:deploying'; ingredients = @($pommeI, @{ item = 'minecraft:echo_shard' }); results = $pommeR })
    transitional_item = [ordered]@{ id = 'create_new_age:incomplete_enchanted_golden_apple' } })
# Pyrium (1 lingot garanti sur chaque boss de Hazen) : 1 debris antique au lieu de 5, recyclage et non source de netherite
W 'data/irons_spellbooks/recipe/ancient_debris_from_pyrium.json' ([ordered]@{ type = 'minecraft:blasting'; cookingtime = 200; experience = 0.0; ingredient = @{ item = 'irons_spellbooks:pyrium_ingot' }; result = [ordered]@{ id = 'minecraft:ancient_debris'; count = 1 } })

# ---------- 28. Create Structures Arise : pas de structures "terrestres" dans les deserts et badlands ----------
# Leur liste de biomes (structures_arise:landbiomes) contient #minecraft:stronghold_biased_to (presque tous les biomes
# terrestres, deserts et Terralith compris) et les badlands : leurs batiments a base de terre et d'herbe se posaient dans le sable.
$terrestres = @('minecraft:forest', 'minecraft:birch_forest', 'minecraft:flower_forest', 'minecraft:taiga', 'minecraft:plains')
$terrestres += @('#minecraft:is_forest', '#minecraft:is_taiga', '#minecraft:is_jungle', '#minecraft:is_savanna', '#c:is_plains' | ForEach-Object { [ordered]@{ id = $_; required = $false } })
W 'data/structures_arise/tags/worldgen/biome/landbiomes.json' ([ordered]@{ replace = $true; values = $terrestres })

$count = (Get-ChildItem $dp -Recurse -File).Count
Write-Host "Datapack genere : $dp ($count fichiers)"
