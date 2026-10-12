# Extensions d'Iron's Spells : chapitre a part dans le groupe Magie (comme l'ancien pack). Les familiers ont leur propre chapitre (familiers.snbt + specs/familiers_lore.ps1).
# Coordonnees d'origine conservees, chapitre remonte de 10 (dy). Racine d'Iron's : 53C9B66BEC667ED0 (dependance inter-chapitres, lignes masquees).
$Chapter = @{ file = 'magie_addons'; title = '&b&lExtensions de magie'; subtitle = 'Grimoires de boss, nouvelles écoles et sorts ultimes'; group = '1A00000000000004'; order = 3; icon = 'irons_spellbooks:iron_spell_book'; dy = -10 }
$racine = '53C9B66BEC667ED0'
function Opt($k, $x, $y, $dep, $task, $t, $st, $d, $crate = 'rare') { @{ k = $k; x = $x; y = $y; deps = @($dep); tasks = @($task); crate = $crate; optional = $true; t = $t; st = $st; d = $d } }
$Quests = @(
  # --- Cataclysm Spellbooks
  @{ k='cs_intro'; x=0; y=12; size=1.5; shape='gear'; deps=@($racine); hideLines=$true; tasks=@('@check'); icon='cataclysm_spellbooks:ignis_spell_book'; crate='commune'
     t='&c&lLes grimoires de Cataclysm'; st='Cataclysm Spellbooks'
     d=@('Les boss de &cCataclysm&r gardent des &esorts&r. Chacun lâche un &6manuscrit&r : utilise-le pour apprendre ses sorts.',
         '',
         'Tu y gagnes aussi des &egrimoires&r, des &ebâtons&r et des &earmures de mage&r aux couleurs de chaque boss.',
         '',
         'Tape &d@cataclysm_spellbooks&r dans JEI pour tout voir.') }
  (Opt 'cs_ignis' 2 10 'cs_intro' 'cataclysm_spellbooks:burning_manuscript' 'Le manuscrit brûlant' 'Les sorts d''Ignis' @('Vaincs &cIgnis&r dans l''arène brûlante pour obtenir son &6manuscrit&r et apprendre ses sorts de feu.'))
  (Opt 'cs_monstro' 3.5 10 'cs_intro' 'cataclysm_spellbooks:encoded_print' 'L''empreinte codée' 'Les sorts de la Monstruosité' @('La &cMonstruosité de Netherite&r cache des sorts infernaux codés dans sa carcasse.'))
  (Opt 'cs_guardian' 5 10 'cs_intro' 'cataclysm_spellbooks:oracle_shulker_shell_script' 'Le script de l''oracle' 'Les sorts du Gardien de l''Ender' @('Les sorts du vide sont gravés sur la carapace de l''&5Ender Guardian&r, au fond de la citadelle en ruine.'))
  (Opt 'cs_remnant' 6.5 10 'cs_intro' 'cataclysm_spellbooks:hieroglyph_manuscript' 'Le manuscrit hiéroglyphique' 'Les sorts de la pyramide maudite' @('Les sorts oubliés de la &epyramide maudite&r, gardés par l''&6Ancient Remnant&r.'))
  (Opt 'cs_maledictus' 2 11.5 'cs_intro' 'cataclysm_spellbooks:frozen_tablet' 'La tablette gelée' 'Les sorts de la prison gelée' @('Les sorts maudits scellés dans la &bprison gelée&r de &cMaledictus&r.'))
  (Opt 'cs_leviathan' 3.5 11.5 'cs_intro' 'cataclysm_spellbooks:abyssal_manuscript' 'Le manuscrit déchiré' 'Les sorts abyssaux' @('Les sorts abyssaux protégés par les deeplings de la &3cité engloutie&r.'))
  (Opt 'cs_harbinger' 5 11.5 'cs_intro' 'cataclysm_spellbooks:strange_disc' 'Le disque étrange' 'Les sorts du Harbinger' @('Joue ce disque dans un juke-box &eaccroupi&r pour apprendre les sorts cachés de l''&eusine antique&r.'))
  (Opt 'cs_amethyst' 6.5 11.5 'cs_intro' 'cataclysm_spellbooks:crystallized_manuscript' 'Le manuscrit cristallisé' 'Les sorts du nid d''améthyste' @('Les sorts cristallins déposés dans le &dnid d''améthyste&r.'))
  (Opt 'cs_book' 2 13 'cs_intro' 'cataclysm_spellbooks:ignis_spell_book' 'Le grimoire d''Ignis' 'Un grimoire de boss' @('Chaque boss a son &egrimoire&r : Ignis, le Livre de R''lyeh, le grimoire du désert, le Codex de la Malice…'))
  (Opt 'cs_ignis_armor' 3.5 13 'cs_ignis' 'cataclysm_spellbooks:ignis_chestplate' 'La robe d''Ignis' 'Armure de mage de feu' @('Une &earmure de mage&r forgée avec les matériaux d''Ignis.'))
  (Opt 'cs_abyssal_armor' 5 13 'cs_leviathan' 'cataclysm_spellbooks:abyssal_warlock_chestplate' 'La robe du sorcier abyssal' 'Armure de mage abyssale' @('Une &earmure de mage&r pour les sorts abyssaux.'))
  (Opt 'cs_pharaoh_armor' 6.5 13 'cs_remnant' 'cataclysm_spellbooks:pharaoh_chestplate' 'Le haubert du pharaon' 'Armure sacrée du désert' @('Une &earmure de mage&r tirée des trésors de la pyramide maudite.'))
  # --- Somake Spells
  @{ k='so_intro'; x=9.5; y=12; size=1.5; shape='gear'; deps=@($racine); hideLines=$true; tasks=@('@check'); icon='somakespells:upgrade_forge'; crate='commune'
     t='&b&lSomake Spells'; st='Nouvelles écoles et nouveaux métaux'
     d=@('&6Somake Spells&r ajoute des écoles de magie (&beau&r, &cfeu infernal&r, &3feu des âmes&r…), de nouveaux &emétaux&r, des &egrimoires à trois niveaux&r et des armes de mage.',
         '',
         'Tape &d@somakespells&r dans JEI pour tout voir.') }
  (Opt 'so_forge' 11.5 10 'so_intro' 'somakespells:upgrade_forge' 'La forge d''amélioration' 'Le cœur de Somake' @('La &eforge d''amélioration&r fait passer grimoires, armes et armures au niveau supérieur.') 'commune')
  (Opt 'so_abyssium' 11.5 11.5 'so_intro' 'somakespells:abyssium_ingot' 'L''abyssium' 'Un métal des profondeurs' @('Un des trois nouveaux &emétaux&r de Somake, avec le céranium et le magmarium.') 'commune')
  (Opt 'so_ceranium' 13 11.5 'so_intro' 'somakespells:ceranium_ingot' 'Le céranium' 'Un métal céleste' @('Un des trois nouveaux &emétaux&r de Somake.') 'commune')
  (Opt 'so_magmarium' 14.5 11.5 'so_intro' 'somakespells:magmarium_ingot' 'Le magmarium' 'Un métal de lave' @('Un des trois nouveaux &emétaux&r de Somake.') 'commune')
  @{ k='so_runes'; x=13; y=10; deps=@('so_intro'); tasks=@('somakespells:aqua_rune','somakespells:infernal_fire_rune','somakespells:soul_fire_rune'); crate='rare'; optional=$true
     t='Les runes des nouvelles écoles'; st='Eau, feu infernal, feu des âmes'
     d=@('Chaque nouvelle école a sa &erune&r, base de ses &eorbes d''amélioration&r.') }
  (Opt 'so_book1' 11.5 13 'so_forge' 'somakespells:burning_magma_spell_book' 'Magma ardent' 'Un grimoire à trois niveaux' @('Les grimoires de Somake s''améliorent en &eII&r puis &eIII&r à la forge d''amélioration.') 'commune')
  (Opt 'so_book2' 13 13 'so_book1' 'somakespells:burning_magma_2_spell_book' 'Magma ardent II' 'Deuxième niveau' @('Plus d''emplacements de sorts et plus de puissance.'))
  (Opt 'so_book3' 14.5 13 'so_book2' 'somakespells:burning_magma_3_spell_book' 'Magma ardent III' 'Le grimoire ultime' @('Le dernier niveau du grimoire.') 'epique')
  (Opt 'so_staff' 16 11.5 'so_intro' 'somakespells:ignitium_staff' 'Le bâton d''ignitium' 'Un bâton de feu' @('Un bâton forgé avec l''&cignitium&r de Cataclysm.'))
  (Opt 'so_armor' 16 13 'so_intro' 'somakespells:aquamancer_chestplate' 'L''aquamancien' 'Armure de l''école de l''eau' @('L''armure de mage de l''école de l''&beau&r.'))
  # --- Twilight Spellbooks
  @{ k='ts_intro'; x=0; y=17; size=1.5; shape='gear'; deps=@($racine); hideLines=$true; tasks=@('@check'); icon='twilight_spellbooks:ironwood_spell_book'; crate='commune'
     t='&2&lLa magie du Crépuscule'; st='Twilight Spellbooks'
     d=@('Les matériaux de la &2Forêt du Crépuscule&r servent aussi aux mages : grimoires, encres et anneaux.',
         '',
         'Chaque &cboss du Crépuscule&r lâche un &6tome&r qui apprend ses sorts.') }
  (Opt 'ts_ironwood' 2 16 'ts_intro' 'twilight_spellbooks:ironwood_spell_book' 'Le tome de bois de fer' 'Le premier grimoire du Crépuscule' @('Un grimoire en &ebois de fer&r.') 'commune')
  (Opt 'ts_steeleaf' 3.5 16 'ts_ironwood' 'twilight_spellbooks:steeleaf_spell_book' 'Le grimoire de feuille d''acier' 'Plus robuste' @('Un grimoire en &efeuille d''acier&r.'))
  (Opt 'ts_fiery' 5 16 'ts_steeleaf' 'twilight_spellbooks:fiery_spell_book' 'Le grimoire ardent' 'Forgé dans le sang de l''hydre' @('Un grimoire en &cmétal ardent&r.') 'epique')
  (Opt 'ts_ink' 6.5 16 'ts_intro' 'twilight_spellbooks:twilight_ink' 'L''encre du Crépuscule' 'Pour des parchemins plus puissants' @('Une &eencre&r propre au Crépuscule, comme l''encre royale et l''encre insolite.'))
  (Opt 'ts_naga' 2 17.5 'ts_intro' 'twilight_spellbooks:nagas_grimoire' 'Le grimoire de la naga' 'Le premier boss' @('Le tome de la &enaga&r.'))
  (Opt 'ts_lich' 3.5 17.5 'ts_intro' 'twilight_spellbooks:lichs_secret' 'Le secret de la liche' 'La tour de la liche' @('Le tome de la &eliche&r.'))
  (Opt 'ts_minoshroom' 5 17.5 'ts_intro' 'twilight_spellbooks:minoshroom_fury' 'La fureur du minoshroom' 'Le labyrinthe' @('Le tome du &eminoshroom&r.'))
  (Opt 'ts_hydra' 6.5 17.5 'ts_intro' 'twilight_spellbooks:hydra_codex' 'Le codex de l''hydre' 'Le marais de feu' @('Le tome de l''&ehydre&r.'))
  (Opt 'ts_knight' 2 19 'ts_intro' 'twilight_spellbooks:knights_memories' 'Les mémoires du chevalier' 'Le bastion des chevaliers' @('Le tome des &echevaliers fantômes&r.'))
  (Opt 'ts_yeti' 3.5 19 'ts_intro' 'twilight_spellbooks:yetis_scream' 'Le cri du yéti' 'La grotte du yéti' @('Le tome du &eyéti alpha&r.'))
  (Opt 'ts_urghast' 5 19 'ts_intro' 'twilight_spellbooks:urghast_chronicle' 'La chronique de l''Ur-Ghast' 'La tour noire' @('Le tome de l''&eUr-Ghast&r.') 'epique')
  (Opt 'ts_queen' 6.5 19 'ts_intro' 'twilight_spellbooks:queens_diary' 'Le journal de la reine' 'Le palais de l''aurore' @('Le tome de la &eReine des neiges&r.') 'epique')
  # --- Deeper and Darker Spellbooks
  @{ k='dd_intro'; x=9.5; y=17; size=1.5; shape='gear'; deps=@($racine); hideLines=$true; tasks=@('@check'); icon='darkermagic:whisper_staff'; crate='commune'
     t='&3&lLa magie de l''Autre Côté'; st='Deeper and Darker Spellbooks'
     d=@('Les matériaux du &3Warden&r et de l''&3Autre Côté&r donnent un bâton, une armure de mage et un grimoire.') }
  @{ k='dd_staff'; x=11.5; y=16; deps=@('dd_intro'); tasks=@('adv:darkermagic:darkermagic/whisper_staff_created'); crate='rare'; optional=$true; icon='darkermagic:whisper_staff'
     t='Les Murmures'; st='Le bâton des profondeurs'; d=@('Fabrique &eles Murmures&r, à partir du bâton sonore de Deeper and Darker.') }
  @{ k='dd_armor'; x=11.5; y=17.5; deps=@('dd_intro'); tasks=@('adv:darkermagic:darkermagic/warden_battlemage_set'); crate='epique'; optional=$true; icon='darkermagic:warden_mage_chestplate'
     t='Un avec le Warden'; st='L''armure de mage du Warden'; d=@('Porte l''armure complète de &3mage-guerrier du Warden&r.') }
  @{ k='dd_book'; x=11.5; y=19; deps=@('dd_intro'); tasks=@('adv:darkermagic:darkermagic/spell_book_volume'); crate='epique'; optional=$true; icon='darkermagic:volume_of_the_deep'
     t='Le Volume des Profondeurs'; st='Un grimoire de Netherite amélioré'; d=@('Améliore ton grimoire de Netherite en &3Volume des Profondeurs&r.') }
  # --- Create : Wizardry
  @{ k='cw_root'; x=14; y=17; size=1.5; shape='gear'; deps=@($racine); hideLines=$true; tasks=@('adv:create_wizardry:root'); icon='create_wizardry:arcane_casing'; crate='commune'
     t='&e&lCreate : Wizardry'; st='La sorcellerie mécanique'
     d=@('&6Create : Wizardry&r automatise la magie avec Create : essence arcanique, encres, mana liquide, foudre et même un lanceur de sorts.') }
  @{ k='cw_alch'; x=16; y=16; deps=@('cw_root'); tasks=@('adv:create_wizardry:alch_101'); crate='commune'; optional=$true; icon='irons_spellbooks:arcane_essence'
     t='Alchimie 101'; st='De l''essence arcanique à la chaîne'; d=@('Synthétise de l''&eessence arcanique&r avec du lapis, de l''améthyste et de l''expérience.') }
  @{ k='cw_ink'; x=17.5; y=16; deps=@('cw_alch'); tasks=@('adv:create_wizardry:industrial_ink'); crate='rare'; optional=$true; icon='irons_spellbooks:rare_ink'
     t='L''encre industrielle'; st='Fini le mélange à la main'; d=@('Mélange de l''&eencre&r avec une machine Create.') }
  @{ k='cw_sheet'; x=16; y=17.5; deps=@('cw_root'); tasks=@('adv:create_wizardry:sploink'); crate='commune'; optional=$true; icon='create_wizardry:arcane_sheet'
     t='La plaque arcanique'; st='Sploink.'; d=@('Obtiens une &eplaque arcanique&r.') }
  @{ k='cw_insulated'; x=17.5; y=17.5; deps=@('cw_sheet'); tasks=@('adv:create_wizardry:splash_guard_on'); crate='commune'; optional=$true; icon='create_wizardry:arcane_pipe'
     t='Bien isolé'; st='Le mana ne fuit plus'; d=@('Isole tes tuyaux avec des &eplaques arcaniques&r pour ne plus perdre de mana en route.') }
  @{ k='cw_siphon'; x=19; y=17.5; deps=@('cw_insulated'); tasks=@('adv:create_wizardry:aura_monster'); crate='rare'; optional=$true; icon='create_wizardry:mana_siphon'
     t='Le siphon de mana'; st='Ton aura en bouteille'; d=@('Fabrique un &esiphon de mana&r pour récolter ton propre mana.') }
  @{ k='cw_crystals'; x=20.5; y=17.5; deps=@('cw_siphon'); tasks=@('adv:create_wizardry:baby_blue'); crate='rare'; optional=$true; icon='irons_spellbooks:arcane_essence'
     t='Pur à 99,7 %'; st='De l''essence presque gratuite'; d=@('Récolte des &ecristaux de mana&r sur un siphon.') }
  @{ k='cw_casing'; x=16; y=19; deps=@('cw_root'); tasks=@('adv:create_wizardry:enlightenment_age'); crate='commune'; optional=$true; icon='create_wizardry:arcane_casing'
     t='L''âge des Lumières'; st='Le boîtier arcanique'; d=@('Fabrique un &eboîtier arcanique&r.') }
  @{ k='cw_channeler'; x=17.5; y=19; deps=@('cw_casing'); tasks=@('adv:create_wizardry:channeler'); crate='rare'; optional=$true; icon='create_wizardry:channeler'
     t='Récolter le ciel'; st='La foudre liquide'; d=@('Pose un &ecanaliseur&r pour récolter de la &efoudre liquide&r pendant les orages.') }
  @{ k='cw_caster'; x=19; y=19; deps=@('cw_casing'); tasks=@('adv:create_wizardry:i_cast_fireball'); crate='epique'; optional=$true; icon='create_wizardry:blaze_caster'
     t='JE LANCE BOULE DE FEU !'; st='Le lanceur de sorts'; d=@('Forge le &elanceur Blaze&r : une machine qui lance des sorts toute seule.') }
)
# --- Apex Arcana : un sort ultime par quete (parchemins tres rares, coffres de fin de jeu)
$Quests += @{ k = 'ax_intro'; x = 0; y = 23; size = 1.5; shape = 'gear'; deps = @($racine); hideLines = $true; tasks = @('@check'); icon = 'irons_spellbooks:legendary_ink'; crate = 'commune'
  t = '&5&lLes sorts ultimes'; st = 'Apex Arcana'
  d = @('&5Apex Arcana&r ajoute &e18 sorts ultimes&r : étoiles qui tombent, dragons de foudre, glaciers, arbres-monde…',
        '',
        'Leurs parchemins sont &ctrès rares&r : on ne les trouve que dans quelques coffres de fin de jeu (cité antique, trésor de la cité de l''End, chambre du Roi Mort, citadelle d''Iron''s, tour du Liche, tour noire du Crépuscule, temple de l''Autre Côté).',
        '',
        'Chaque quête ci-dessous se valide en lançant le sort.') }
$apex = @(@('root', 'Le Grand Sigil'), @('sunfall', 'Chute du soleil'), @('skybreak', 'Brise-ciel'), @('world_tree', 'L''Arbre-monde'), @('heaven_gate', 'Les Portes du Paradis'), @('glaciation', 'Le Glacier'), @('the_gaze', 'Le Regard'), @('voidgrip', 'L''Étreinte du vide'), @('colosseum', 'Le Colisée'), @('reckoning', 'Le Jugement'), @('black_coffin', 'Le Cercueil noir'), @('thousand_blades', 'Mille Lames'), @('phoenix', 'Le Phénix'), @('thunder_dragon', 'Le Dragon de foudre'), @('full_bloom', 'Pleine floraison'), @('ice_age', 'L''Ère glaciaire'), @('crimson_threads', 'Les Fils écarlates'), @('dimension_cut', 'La Coupure dimensionnelle'))
$i = 0
foreach ($a in $apex) {
  $Quests += @{ k = "ax_$($a[0])"; x = 2 + ($i % 6) * 1.25; y = 22 + [Math]::Floor($i / 6) * 1.25; size = 0.75; deps = @('ax_intro'); hideLines = $true; tasks = @("adv:grandsigil:$($a[0])"); crate = 'legendaire'; optional = $true; icon = 'irons_spellbooks:legendary_ink'
    t = $a[1]; st = 'Sort ultime' }
  $i++
}
