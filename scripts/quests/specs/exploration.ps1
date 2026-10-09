$Chapter = @{ file = 'exploration'; title = '&a&lExploration'; subtitle = 'Un monde immense à découvrir'; group = '1A00000000000001'; order = 1; icon = 'explorerscompass:explorerscompass' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='Clique pour valider'; icon='minecraft:filled_map'
     t='&a&lPartir à l''aventure'; st='Un monde plus grand, plus haut, plus profond'
     d=@('Le monde de ce serveur est généré par &eTerralith&r et &eTectonic&r : des continents immenses, des océans profonds et des montagnes très hautes.',
         '',
         'Des &edizaines de mods de structures&r y ont caché des villages, donjons, ruines, tours, forteresses, navires… Chaque expédition peut rapporter un trésor.',
         '',
         'Ce chapitre te donne les outils pour explorer, puis te lance quelques défis de découverte.') }
  # --- Outils
  @{ k='explorer'; x=-1.5; y=1.5; deps=@('intro'); tasks=@('explorerscompass:explorerscompass'); crate='rare'
     t='&6La Boussole de l''Explorateur'; st='Trouver n''importe quelle structure'
     d=@('La &6Boussole de l''Explorateur&r peut localiser &bn''importe quelle structure&r du pack.',
         '',
         'Fais un clic droit pour ouvrir la liste, choisis une structure, et la boussole pointe vers la plus proche.',
         '',
         '&7La recherche peut prendre quelques secondes pour les structures rares : patience !') }
  @{ k='nature'; x=-3; y=1.5; deps=@('explorer'); tasks=@('naturescompass:naturescompass'); crate='commune'
     t='La Boussole de la Nature'; st='Trouver n''importe quel biome'
     d=@('La &eBoussole de la Nature&r fait la même chose pour les &abiomes&r. Pratique pour trouver un biome précis de Terralith, une jungle, un désert…') }
  @{ k='journeymap'; x=1.5; y=1.5; deps=@('intro'); tasks=@('@check'); checkTitle='Clique pour valider'; icon='minecraft:map'; crate='commune'
     t='La carte JourneyMap'; st='Ne jamais se perdre'
     d=@('&eJourneyMap&r dessine la carte au fur et à mesure que tu explores. Ouvre la grande carte avec &6J&r.',
         '',
         '- Crée des &epoints de passage&r pour retenir tes découvertes.',
         '- Un point est créé automatiquement à &cchaque mort&r.',
         '',
         '&cAttention :&r par défaut, la touche de création de point de passage est &6B&r, comme celle du sac à dos. Change l''une des deux dans les options !') }
  @{ k='lootr'; x=3; y=1.5; deps=@('journeymap'); tasks=@('@check'); checkTitle='Compris !'; icon='minecraft:chest'; crate='commune'
     t='Lootr : un butin pour chacun'; st='Pas de jaloux en multijoueur'
     d=@('Grâce à &eLootr&r, les coffres des structures ont un &abutin différent pour chaque joueur&r.',
         '',
         'Si un ami a déjà pillé un donjon, &ale coffre est toujours plein pour toi&r ! Un coffre déjà ouvert par toi est marqué différemment.',
         '',
         '&7Impossible de casser ces coffres pour les récupérer : le butin reste pour tout le monde.') }
  @{ k='waystones'; x=0; y=1.5; deps=@('intro'); tasks=@('waystones:warp_dust*4'); crate='commune'
     t='&eLes Waystones'; st='Des points de téléportation'
     d=@('Les &eWaystones&r se trouvent dans le monde (y compris dans certains villages). &bActive-les en passant&r pour pouvoir t''y téléporter plus tard.',
         '',
         'Sur ce serveur, elles sont assez espacées et &ela téléportation coûte de l''XP&r selon la distance. Pour les longs voyages, préfère les dirigeables !',
         '',
         'La &ePoudre de Warp&r sert à fabriquer des parchemins de retour et des pierres de téléportation.') }
  @{ k='comforts'; x=-1.5; y=3; deps=@('explorer'); tasks=@('comforts:sleeping_bag_white'); crate='commune'
     t='Dormir en expédition'; st='Sac de couchage et hamac'
     d=@('Le &eSac de Couchage&r permet de dormir la nuit &asans changer ton point de réapparition&r : parfait en expédition.',
         '',
         'Le &eHamac&r (accroché entre deux blocs avec des cordes et clous) permet de faire une sieste la journée.') }
  @{ k='corpse'; x=0; y=3; deps=@('waystones'); tasks=@('@check'); checkTitle='Compris !'; icon='minecraft:skeleton_skull'; crate='commune'
     t='Mourir sans tout perdre'; st='Ton corps t''attend'
     d=@('Quand tu meurs, ton inventaire reste dans ton &ecorps&r, à l''endroit de ta mort. Retourne le chercher pour tout récupérer !',
         '',
         'La touche &6J&r de Corpse (à vérifier dans les commandes si elle est en conflit avec JourneyMap) affiche l''historique de tes morts et leurs coordonnées.',
         '',
         '&7Le point de passage de mort de JourneyMap aide aussi à retrouver ton corps.') }
  @{ k='tome'; x=1.5; y=3; deps=@('journeymap'); tasks=@('akashictome:tome'); crate='commune'
     t='Le Tome Akashique'; st='Tous les livres en un'
     d=@('Combine tous les &elivres de guide&r des mods (Patchouli, etc.) dans le &eTome Akashique&r : un seul livre au lieu de dix dans ton inventaire.',
         '',
         'Accroupi + clic droit pour choisir le livre à ouvrir.') }
  @{ k='archeo'; x=3; y=3; deps=@('lootr'); tasks=@('betterarcheology:iron_brush'); crate='commune'
     t='&6L''archéologie avancée'; st='Better Archeology'
     d=@('&eBetter Archeology&r ajoute des pinceaux améliorés (fer, diamant, Netherite), des fossiles à reconstituer, des vases à butin et des artefacts aux pouvoirs spéciaux.',
         '',
         'Cherche les &ecamps d''archéologues&r, les &ecatacombes&r et les ruines ensevelies.') }
  @{ k='fossils'; x=4.5; y=3; deps=@('archeo'); tasks=@('adv:betterarcheology:fossil_found'); crate='rare'; optional=$true
     t='Paléontologue'; st='Trouver un fossile'
     d=@('Des fossiles d''animaux sont enfouis dans le monde. Reconstitue-les pour décorer ton musée !') }

  # --- Défis de découverte
  @{ k='discover'; x=0; y=4.5; size=1.5; shape='hexagon'; deps=@('explorer','waystones'); tasks=@('@check'); checkTitle='C''est parti !'; icon='minecraft:compass'
     t='&a&lLe carnet de l''explorateur'; st='Des défis de découverte'
     d=@('Voici une sélection de &estructures remarquables&r à trouver. Chaque quête se valide automatiquement quand tu entres dans la structure.',
         '',
         'Utilise la Boussole de l''Explorateur si tu es bloqué… ou explore au hasard, c''est plus amusant !') }
  @{ k='village'; x=-4.5; y=6; deps=@('discover'); tasks=@('struct:#minecraft:village'); crate='commune'
     t='Un village'; st='Villages améliorés et gardes'
     d=@('Les villages de ce pack sont plus grands et plus vivants : &eCTOV&r en crée de nouveaux par biome, &eTowns and Towers&r en ajoute d''autres, et des &egardes&r les défendent.',
         '',
         'Tu peux équiper les gardes : donne-leur une armure et une arme (clic droit accroupi).') }
  @{ k='skyvillage'; x=-1.5; y=6; deps=@('discover'); tasks=@('struct:skyvillages:skyvillage'); crate='rare'
     t='Un village dans le ciel'; st='Au-dessus des nuages'
     d=@('Certains villages flottent dans le ciel ! Il faudra un dirigeable, un jetpack… ou beaucoup d''échelles pour les atteindre.') }
  @{ k='airship'; x=1.5; y=6; deps=@('discover'); tasks=@('struct:create_structures_arise:pillagersteampunkairship'); crate='rare'
     t='Le dirigeable des pillards'; st='Des pillards qui volent ?'
     d=@('Les pillards ont construit un &edirigeable steampunk&r avec la technologie de Create. Aborde-le et pille-le !',
         '',
         '&7Create: Structures Arise ajoute 28 structures sur le thème de Create, avec du butin Create.') }
  @{ k='illagerfort'; x=3; y=6; deps=@('discover'); tasks=@('struct:dungeons_arise:illager_fort'); crate='rare'
     t='Un fort des illagers'; st='When Dungeons Arise'
     d=@('&eWhen Dungeons Arise&r ajoute d''immenses structures pleines d''ennemis et de trésors. Le &efort des illagers&r en est un bon exemple.',
         '',
         'Viens à plusieurs et bien équipé !') }
  @{ k='magetower'; x=4.5; y=6; deps=@('discover'); tasks=@('struct:terralith:mage_tower'); crate='commune'
     t='Une tour de mage'; st='Terralith'
     d=@('&eTerralith&r cache aussi ses propres structures, comme ces &etours de mage&r perdues dans la nature.') }
  @{ k='catacombs'; x=-4.5; y=7.5; deps=@('village'); tasks=@('struct:betterarcheology:catacombs'); crate='rare'
     t='Des catacombes'; st='Sous terre, les morts dorment'
     d=@('Ces &ecatacombes&r sont pleines de vases à butin et de secrets archéologiques.') }
  @{ k='lostsoul'; x=-3; y=6; deps=@('discover'); tasks=@('struct:philipsruins:lost_soul_city'); crate='rare'
     t='La cité des âmes perdues'; st='Philips'' Ruins'
     d=@('Une cité en ruine, hantée par les âmes perdues. Qui sait ce qu''il reste dans ses coffres ?') }
  @{ k='stronghold'; x=0; y=7.5; deps=@('discover'); tasks=@('struct:betterstrongholds:stronghold'); crate='rare'
     t='Un fort'; st='Là où se cache le portail de l''End'
     d=@('Les &eforts&r (améliorés par YUNG''s Better Strongholds) cachent le &eportail de l''End&r. Tu devras en trouver un pour y placer tes yeux de l''End !',
         '',
         'Voir le chapitre &aLa Route de l''End&r.') }
  @{ k='mansion'; x=1.5; y=7.5; deps=@('airship'); tasks=@('struct:nova_structures:illager_manor'); crate='rare'
     t='Le manoir des illagers'; st='Dungeons and Taverns'
     d=@('Un immense &emanoir&r occupé par les illagers, avec ses évocateurs… qui lâchent parfois l''Œil Magique !') }
  @{ k='ancientcity'; x=3; y=7.5; deps=@('illagerfort'); tasks=@('struct:minecraft:ancient_city'); crate='rare'
     t='Une Cité Antique'; st='Silence…'
     d=@('Au fond des &eAbîmes&r se cachent les &eCités Antiques&r. Avance accroupi : le &cWarden&r n''est jamais loin.',
         '',
         'C''est aussi là que se trouve le portail vers &0Deeper and Darker&r, et les fragments de savoir Eldritch d''Iron''s Spells.') }
  @{ k='tavern'; x=4.5; y=7.5; deps=@('magetower'); tasks=@('struct:explorify:tavern'); crate='commune'
     t='Une taverne'; st='Une pause bien méritée'
     d=@('Les &etavernes&r sont des haltes accueillantes pour les voyageurs. Il y en a de plusieurs mods différents !') }
  @{ k='explorer_master'; x=0; y=9; size=2.5; shape='gear'; deps=@('catacombs','lostsoul','stronghold','mansion','ancientcity','tavern'); tasks=@('@check'); checkTitle='Je suis un grand explorateur'; icon='explorerscompass:explorerscompass'; crate='legendaire'; xp=1500
     t='&6&lGrand Explorateur'; st='Le carnet est complet'
     d=@('Tu as découvert toutes les merveilles de ce carnet. Le monde n''a presque plus de secrets pour toi…',
         '',
         '… presque. Il reste des centaines de structures à découvrir, et des dimensions entières à explorer !',
         '',
         '&6&lBravo, Grand Explorateur !&r') }
)
