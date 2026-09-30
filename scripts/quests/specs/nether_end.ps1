$Chapter = @{ file = 'nether_end'; title = '&4&lLe Nether et l''End'; subtitle = 'Deux dimensions transformées'; group = '1A00000000000005'; order = 3; icon = 'minecraft:netherrack' }
$Quests = @(
  # --- Nether
  @{ k='nether'; x=-3; y=0; size=2; shape='gear'; tasks=@('dim:minecraft:the_nether'); icon='minecraft:netherrack'; crate='commune'
     t='&4&lUn Nether transformé'; st='Incendium et bien d''autres'
     d=@('Le Nether de ce pack est bien plus dangereux et riche qu''en vanilla :',
         '',
         '- &6Incendium&r ajoute de nouveaux biomes (déserts de cendres, dunes infernales, forêts flétries…), des structures et des boss ;',
         '- &eYUNG''s&r améliore les forteresses, &eFormations Nether&r et les structures de &eMoog&r ajoutent des ruines partout ;',
         '- &6Hellish Trials&r propose des épreuves de combat.',
         '',
         'Prévois de la &cRésistance au feu&r et une armure en or pour les piglins.') }
  @{ k='fortress'; x=-4.5; y=1.5; deps=@('nether'); tasks=@('struct:betterfortresses:fortress'); crate='rare'
     t='Une forteresse du Nether'; st='YUNG''s Better Nether Fortresses'
     d=@('Les &eforteresses&r sont immenses et labyrinthiques. Leurs coffres peuvent contenir l''&cŒil du Nether&r.',
         '',
         'On y trouve aussi les Wither squelettes, dont les crânes servent à invoquer le Wither.') }
  @{ k='piglin'; x=-3; y=1.5; deps=@('nether'); tasks=@('adv:incendium:misc/loot_piglin_village'); crate='rare'
     t='Le village des piglins'; st='Incendium'
     d=@('Les piglins ont construit leurs propres &evillages&r dans le Nether. Pille leur trésor… si tu l''oses.') }
  @{ k='lab'; x=-1.5; y=1.5; deps=@('nether'); tasks=@('adv:incendium:misc/ruined_lab'); crate='commune'
     t='Le laboratoire en ruine'; st='Des expériences qui ont mal tourné'
     d=@('Un ancien &elaboratoire&r abandonné dans le Nether. Qui sait ce qu''on y étudiait ?') }
  @{ k='spirit'; x=-4.5; y=3; deps=@('fortress'); tasks=@('adv:incendium:withered_forest/kill_spirit'); crate='rare'
     t='L''esprit de la forêt flétrie'; st='Incendium'
     d=@('Dans la &eforêt flétrie&r rôde un esprit redoutable. Vaincs-le !') }
  @{ k='sanctum'; x=-3; y=3; deps=@('piglin'); tasks=@('adv:incendium:quartz_flats/sanctum/vault_hunter'); crate='rare'
     t='Le coffre du sanctuaire'; st='Les plaines de quartz'
     d=@('Dans les &eplaines de quartz&r se cache un &esanctuaire&r et sa chambre forte. Trouve comment l''ouvrir !') }
  @{ k='pipeline'; x=-1.5; y=3; deps=@('lab'); tasks=@('adv:incendium:infernal_dunes/pipeline/kill_sentry'); crate='rare'
     t='Le pipeline des dunes'; st='Et sa sentinelle'
     d=@('Dans les &edunes infernales&r, un grand &epipeline&r est gardé par une &esentinelle&r. Détruis-la !') }
  @{ k='castle'; x=-4.5; y=4.5; size=1.5; deps=@('spirit'); tasks=@('adv:incendium:ash_barrens/conquer_castle'); icon='minecraft:blackstone'; crate='epique'
     t='&c&lLe Château Interdit'; st='Les déserts de cendres'
     d=@('Au cœur des &edéserts de cendres&r se dresse le &cChâteau Interdit&r, la plus grande forteresse du Nether d''Incendium.',
         '',
         'Conquiers-le et affronte ce qui s''y cache !') }
  @{ k='inferno'; x=-1.5; y=4.5; size=1.5; deps=@('pipeline','sanctum'); tasks=@('adv:incendium:infernal_dunes/inferno/kill'); icon='minecraft:blaze_powder'; crate='epique'
     t='&6&lL''Inferno'; st='Le boss des dunes infernales'
     d=@('L''&6Inferno&r est le grand boss d''Incendium. Il s''invoque dans les &edunes infernales&r (le livre des succès d''Incendium donne des indices).',
         '',
         'Prépare-toi : c''est l''un des combats les plus durs du Nether.') }
  @{ k='trial'; x=-3; y=4.5; deps=@('sanctum'); tasks=@('struct:hellish_trials:nether_trial'); crate='rare'; optional=$true
     t='Une épreuve infernale'; st='Hellish Trials'
     d=@('&6Hellish Trials&r ajoute des &eépreuves&r dans le Nether : des vagues d''ennemis à vaincre pour gagner des récompenses.') }
  @{ k='nethermaster'; x=-3; y=6; size=2; shape='hexagon'; deps=@('castle','inferno'); tasks=@('@check'); checkTitle='Le Nether est à moi'; icon='minecraft:nether_star'; crate='legendaire'; xp=1000
     t='&4&lMaître du Nether'; st='Le Nether n''a plus de secret'
     d=@('Château Interdit et Inferno vaincus : tu es le maître du Nether !') }

  # --- End
  @{ k='end'; x=3; y=0; size=2; shape='gear'; tasks=@('dim:minecraft:the_end'); icon='minecraft:end_stone'; crate='rare'
     t='&d&lUn End transformé'; st='Nullscape et End''s Phantasm'
     d=@('Après le dragon, l''End s''ouvre… et il est bien différent de l''End vanilla :',
         '',
         '- &dNullscape&r sculpte les îles extérieures : falaises, arches, gouffres et &efailles&r spectaculaires ;',
         '- &dEnd''s Phantasm&r ajoute de nouveaux biomes, créatures, minerais et outils ;',
         '- les structures de &eMoog&r, de Dungeons and Taverns et de Structory peuplent les îles.',
         '',
         'N''oublie pas : c''est aussi là que se trouve la &epierre de l''End&r nécessaire à la &dlévitite&r des dirigeables !') }
  @{ k='dreaming'; x=1.5; y=1.5; deps=@('end'); tasks=@('adv:phantasm:find_dreaming_den'); crate='commune'
     t='Le Repaire des Rêves'; st='End''s Phantasm'
     d=@('Le &dRepaire des Rêves&r est un biome onirique de l''End, avec ses arbres de &epream&r et ses baies.') }
  @{ k='crystal'; x=3; y=1.5; deps=@('end'); tasks=@('adv:phantasm:get_crystal'); crate='rare'
     t='Les cristaux de l''End'; st='Des outils cristallins'
     d=@('Mine des &dÉclats de Cristal&r dans l''End. Ils servent à fabriquer les &eoutils cristallins&r, dont l''efficacité &aaugmente avec ton expérience&r.') }
  @{ k='acid'; x=4.5; y=1.5; deps=@('end'); tasks=@('adv:phantasm:find_acidburnt_abysses'); crate='commune'
     t='Les Abysses Acides'; st='Attention où tu marches'
     d=@('Les &aAbysses Acides&r sont un biome dangereux de l''End. Garde tes distances avec l''acide !') }
  @{ k='underisland'; x=1.5; y=3; deps=@('dreaming'); tasks=@('adv:phantasm:find_underisland'); crate='rare'
     t='L''Île du Dessous'; st='Sous le Repaire des Rêves'
     d=@('Sous le Repaire des Rêves se cache une &eîle souterraine&r. Aventure-toi dessous !') }
  @{ k='crystaltools'; x=3; y=3; deps=@('crystal'); tasks=@('adv:phantasm:get_crystal_tools'); crate='rare'
     t='La panoplie cristalline'; st='Tous les outils de cristal'
     d=@('Fabrique &etous les outils cristallins&r : épée, pioche, hache, pelle et houe.') }
  @{ k='choral'; x=4.5; y=3; deps=@('acid'); tasks=@('adv:phantasm:find_choral_riff'); crate='rare'
     t='La Faille Chorale'; st='Tout au fond'
     d=@('Descends la &eFaille Chorale&r, un gouffre de l''End. Ses flèches chorales charment les ennemis (à l''arc) ou créent une onde répulsive (à l''arbalète).') }
  @{ k='endcity'; x=3; y=4.5; deps=@('underisland','crystaltools','choral'); tasks=@('struct:minecraft:end_city'); crate='rare'
     t='Une Cité de l''End'; st='Et ses élytres'
     d=@('Les &eCités de l''End&r cachent des shulkers, du butin et parfois un &enavire&r avec des &eélytres&r.') }
  @{ k='megaship'; x=1.5; y=4.5; deps=@('endcity'); tasks=@('struct:mes:mega_ship'); crate='rare'; optional=$true
     t='Un méga-vaisseau'; st='Les structures de Moog'
     d=@('Un gigantesque &evaisseau&r échoué dans l''End. Explore-le de fond en comble !') }
  @{ k='endcastle'; x=4.5; y=4.5; deps=@('endcity'); tasks=@('struct:nova_structures:end_castle'); crate='rare'; optional=$true
     t='Le château de l''End'; st='Dungeons and Taverns'
     d=@('Un &echâteau&r perdu au milieu des îles de l''End, avec son phare.') }
  @{ k='endmaster'; x=3; y=6; size=2; shape='hexagon'; deps=@('endcity'); tasks=@('minecraft:dragon_head'); crate='legendaire'; xp=1000
     t='&d&lMaître de l''End'; st='Un trophée pour ton salon'
     d=@('Récupère une &etête de dragon&r, à la proue des navires de l''End, pour prouver que l''End n''a plus de secret pour toi !') }
)
