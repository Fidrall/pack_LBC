$Chapter = @{ file = 'alexs_caves'; title = '&3&lLes Grottes d''Alex'; subtitle = 'Six biomes cachés sous terre'; group = '1A00000000000003'; order = 3; icon = 'alexscaves:cave_codex' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='Clique pour valider'; icon='alexscaves:cave_book'
     t='&3&lLes Grottes d''Alex'; st='Ce qui dort sous nos pieds'
     d=@('&eAlex''s Caves&r ajoute &bsix grands biomes souterrains&r, chacun avec ses créatures, ses minerais et son équipement.',
         '',
         'Ils sont rares et profonds : on ne tombe pas dessus par hasard. Il faut d''abord trouver une &etablette de grotte&r dans un coffre, puis s''en servir pour fabriquer une carte.',
         '',
         '&7Le livre du mod (Cave Book) explique tout en détail.') }
  # --- Trouver les biomes
  @{ k='tablet'; x=0; y=1.5; deps=@('intro'); tasks=@('adv:alexscaves:alexscaves/cave_tablet'); icon='alexscaves:cave_tablet'; crate='commune'
     t='Une tablette de grotte'; st='La piste d''un biome'
     d=@('Chaque biome a sa tablette, cachée dans un type de coffre précis :',
         '',
         '- &bAbyssal Chasm&r : ruines sous-marines et trésors enfouis',
         '- &dCandy Cavity&r : cabanes de sorcière',
         '- &8Forlorn Hollows&r : manoirs',
         '- &cMagnetic Caves&r : bastions du Nether',
         '- &6Primordial Caves&r : fouilles archéologiques (pinceau)',
         '- &aToxic Caves&r : temples de la jungle') }
  @{ k='map'; x=-1.5; y=1.5; deps=@('tablet'); tasks=@('adv:alexscaves:alexscaves/cave_map'); icon='alexscaves:cave_map'; crate='rare'
     t='La carte des grottes'; st='Tablette + carte'
     d=@('Combine la tablette avec une carte pour obtenir une &ecarte de grotte&r. Elle cherche le biome le plus proche, puis te montre le chemin.',
         '',
         '&7La recherche peut prendre quelques secondes.') }
  @{ k='codex'; x=1.5; y=1.5; deps=@('tablet'); tasks=@('adv:alexscaves:alexscaves/cave_codex'); icon='alexscaves:cave_codex'; crate='commune'
     t='Le Codex des grottes'; st='Le guide se remplit en explorant'
     d=@('Le &eCave Codex&r débloque les pages du livre au fil de tes découvertes : créatures, blocs et objets de chaque biome.') }
  # --- Magnetic Caves
  @{ k='magnetic'; x=-4.5; y=3.5; size=1.5; deps=@('tablet'); tasks=@('adv:alexscaves:alexscaves/discover_magnetic_caves'); icon='alexscaves:scarlet_neodymium_ingot'; crate='rare'; xp=200
     t='&cMagnetic Caves'; st='Là où le fer flotte'
     d=@('Des grottes chargées de &cnéodyme écarlate&r et &9azur&r, deux métaux qui s''attirent ou se repoussent.',
         '',
         'Attention aux créatures faites de métal et d''électricité.') }
  @{ k='magnet'; x=-6; y=3.5; deps=@('magnetic'); tasks=@('adv:alexscaves:alexscaves/magnet'); icon='alexscaves:scarlet_magnet'; crate='commune'
     t='Aimants'; st='Attirer et repousser'
     d=@('Fabrique un &eaimant&r à partir du néodyme : il déplace les objets et les entités métalliques. La base de toute la technologie du biome.') }
  @{ k='magnetron'; x=-6; y=5; deps=@('magnet'); tasks=@('adv:alexscaves:alexscaves/defeat_magnetron'); icon='alexscaves:galena_gauntlet'; crate='epique'
     t='&cLe Magnetron'; st='Un amas de blocs vivant'
     d=@('Le &cMagnetron&r se construit un corps avec les blocs qui l''entourent. Vaincs-le pour en récupérer les composants.') }
  # --- Primordial Caves
  @{ k='primordial'; x=-2.5; y=3.5; size=1.5; deps=@('tablet'); tasks=@('adv:alexscaves:alexscaves/discover_primordial_caves'); icon='alexscaves:amber'; crate='rare'; xp=200
     t='&6Primordial Caves'; st='Un monde perdu'
     d=@('Une jungle souterraine où vivent encore des &6dinosaures&r. Certains se laissent apprivoiser, d''autres pas du tout.') }
  @{ k='tremorsaurus'; x=-2.5; y=5; deps=@('primordial'); tasks=@('adv:alexscaves:alexscaves/tame_tremorsaurus'); icon='alexscaves:primitive_club'; crate='epique'
     t='Apprivoiser un Tremorsaurus'; st='Une monture qui fait trembler le sol'
     d=@('Le &6Tremorsaurus&r est un prédateur redoutable. Apprivoisé, c''est une monture puissante.') }
  @{ k='primordial_armor'; x=-4; y=5; deps=@('primordial'); tasks=@('adv:alexscaves:alexscaves/primordial_armor'); icon='alexscaves:primordial_helmet'; crate='rare'
     t='Tenue préhistorique'; st='S''habiller comme les anciens'
     d=@('L''&earmure primordiale&r se fabrique avec les peaux des créatures du biome.') }
  @{ k='luxtructosaurus'; x=-2.5; y=6.5; deps=@('tremorsaurus'); tasks=@('adv:alexscaves:alexscaves/defeat_luxtructosaurus'); icon='alexscaves:extinction_spear'; crate='legendaire'; xp=500
     t='&4Le Luxtructosaurus'; st='Le géant des volcans'
     d=@('Un dinosaure titanesque fait de roche et de lave. C''est l''un des combats les plus durs du mod : prépare-toi bien.') }
  # --- Toxic Caves
  @{ k='toxic'; x=2.5; y=3.5; size=1.5; deps=@('tablet'); tasks=@('adv:alexscaves:alexscaves/discover_toxic_caves'); icon='alexscaves:uranium'; crate='rare'; xp=200
     t='&aToxic Caves'; st='Radioactif'
     d=@('Des grottes d''&auranium&r et d''acide. Sans protection, la &cradiation&r fait vite des dégâts.') }
  @{ k='hazmat'; x=4; y=5; deps=@('toxic'); tasks=@('adv:alexscaves:alexscaves/hazmat_armor'); icon='alexscaves:hazmat_mask'; crate='rare'
     t='La combinaison anti-radiation'; st='Indispensable'
     d=@('La &ecombinaison Hazmat&r complète protège de la radiation. À fabriquer avant de rester longtemps dans le biome.') }
  @{ k='raygun'; x=2.5; y=5; deps=@('toxic'); tasks=@('adv:alexscaves:alexscaves/raygun'); icon='alexscaves:raygun'; crate='epique'
     t='Le pistolet à rayons'; st='Science radioactive'
     d=@('Une arme qui tire un rayon d''énergie, alimentée à l''uranium.') }
  @{ k='tremorzilla'; x=2.5; y=6.5; deps=@('raygun', 'hazmat'); tasks=@('adv:alexscaves:alexscaves/tame_tremorzilla'); icon='alexscaves:tremorzilla_egg'; crate='legendaire'; xp=500
     t='&2Tremorzilla'; st='Le roi des monstres'
     d=@('Fais éclore un œuf de &2Tremorzilla&r et élève-le : un monstre gigantesque au rayon dévastateur, de ton côté.') }
  # --- Abyssal Chasm
  @{ k='abyssal'; x=4.5; y=3.5; size=1.5; deps=@('tablet'); tasks=@('adv:alexscaves:alexscaves/discover_abyssal_chasm'); icon='alexscaves:diving_helmet'; crate='rare'; xp=200
     t='&bAbyssal Chasm'; st='Les abysses sous l''océan'
     d=@('Un gouffre noir sous les océans profonds, peuplé de créatures lumineuses et des mystérieux &bDeep Ones&r.') }
  @{ k='diving'; x=6; y=3.5; deps=@('abyssal'); tasks=@('adv:alexscaves:alexscaves/diving_armor'); icon='alexscaves:diving_chestplate'; crate='rare'
     t='Scaphandre'; st='Respirer au fond'
     d=@('Le &escaphandre&r complet permet de rester longtemps sous l''eau et de supporter la pression des abysses.') }
  @{ k='deep_ones'; x=6; y=5; deps=@('diving'); tasks=@('adv:alexscaves:alexscaves/trade_with_deep_one'); icon='alexscaves:sea_staff'; crate='epique'
     t='Les Deep Ones'; st='Gagner leur confiance'
     d=@('Les &bDeep Ones&r se méfient des humains. Gagne leur confiance pour pouvoir commercer avec eux.') }
  @{ k='submarine'; x=4.5; y=5; deps=@('diving'); tasks=@('adv:alexscaves:alexscaves/ride_submarine'); icon='alexscaves:submarine'; crate='epique'
     t='Sous-marin'; st='Explorer les abysses en sécurité'
     d=@('Construis un &esous-marin&r pour explorer le gouffre sans craindre ses habitants.') }
  # --- Forlorn Hollows
  @{ k='forlorn'; x=-1; y=8; size=1.5; deps=@('tablet'); hideLines=$true; tasks=@('adv:alexscaves:alexscaves/discover_forlorn_hollows'); icon='alexscaves:shadow_silk'; crate='rare'; xp=200
     t='&8Forlorn Hollows'; st='Les ténèbres'
     d=@('Des cavernes plongées dans le noir, où rôdent des créatures qui fuient la lumière… ou qui la cherchent.') }
  @{ k='watcher'; x=-2.5; y=8; deps=@('forlorn'); tasks=@('adv:alexscaves:alexscaves/defeat_watcher'); icon='alexscaves:desolate_dagger'; crate='epique'
     t='&8Le Watcher'; st='Il te regarde'
     d=@('Le &8Watcher&r peut prendre le contrôle de ta vision. Vaincs-le avant qu''il ne te perde dans le noir.') }
  @{ k='dreadbow'; x=-2.5; y=9.5; deps=@('watcher'); tasks=@('adv:alexscaves:alexscaves/dreadbow'); icon='alexscaves:dreadbow'; crate='epique'
     t='L''arc de l''effroi'; st='Une arme des ténèbres'
     d=@('Le &5Dreadbow&r tire des flèches d''ombre. Une des armes les plus redoutées du mod.') }
  # --- Candy Cavity
  @{ k='candy'; x=1; y=8; size=1.5; deps=@('tablet'); hideLines=$true; tasks=@('adv:alexscaves:alexscaves/discover_candy_cavity'); icon='alexscaves:candy_cane'; crate='rare'; xp=200
     t='&dCandy Cavity'; st='Tout est en sucre'
     d=@('Un monde de bonbons, de chocolat et de pain d''épices. Mignon… en apparence.') }
  @{ k='gingerbread'; x=2.5; y=8; deps=@('candy'); tasks=@('adv:alexscaves:alexscaves/gingerbread_town'); icon='alexscaves:gingerbread_bricks'; crate='commune'
     t='La ville en pain d''épices'; st='Des voisins sucrés'
     d=@('Trouve une &dville en pain d''épices&r et ses habitants.') }
  @{ k='licowitch'; x=2.5; y=9.5; deps=@('gingerbread'); tasks=@('adv:alexscaves:alexscaves/licowitch_tower'); icon='alexscaves:sugar_staff'; crate='epique'
     t='La tour de la Licowitch'; st='Une sorcière en réglisse'
     d=@('La &5Licowitch&r garde sa tour et un coffre secret bien caché.') }
  # --- Fin
  @{ k='master'; x=0; y=11; size=2; shape='hexagon'; deps=@('magnetic', 'primordial', 'toxic', 'abyssal', 'forlorn', 'candy'); hideLines=$true; tasks=@('@check'); checkTitle='Les six biomes !'; icon='alexscaves:cave_map'; crate='legendaire'; xp=1000
     t='&3&lSpéléologue accompli'; st='Les six biomes découverts'
     d=@('Tu as visité les six biomes d''Alex''s Caves. Peu d''explorateurs peuvent en dire autant !') }
)
