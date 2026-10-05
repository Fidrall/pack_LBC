$Chapter = @{ file = 'create_addons'; title = '&e&lCreate : les addons'; subtitle = 'Pétrole, forage, logistique et décoration'; group = '1A00000000000002'; order = 8; icon = 'createdieselgenerators:diesel_engine' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='Clique pour valider'; icon='create:wrench'
     t='&e&lAller plus loin avec Create'; st='Les addons du pack'
     d=@('Ce chapitre présente les &eaddons de Create&r qui n''ont pas leur propre chapitre : moteurs diesel, forage de gisements, logistique des liquides, décoration, jetpack…',
         '',
         'Toutes les quêtes sont libres : pioche ce qui t''intéresse !') }
  # --- Diesel
  @{ k='oil'; x=-3; y=1.5; deps=@('intro'); tasks=@('createdieselgenerators:oil_scanner'); crate='commune'
     t='&8Trouver du pétrole'; st='Create: Diesel Generators'
     d=@('Le &8pétrole brut&r se cache sous certains chunks. Utilise le &eScanner de Pétrole&r pour trouver les chunks qui en contiennent.',
         '',
         'Une fois trouvé, construis une &epompe à balancier&r (roulement, manivelle et tête de pompe) au-dessus pour l''extraire.') }
  @{ k='pumpjack'; x=-3; y=3; deps=@('oil'); tasks=@('createdieselgenerators:crude_oil_bucket'); crate='rare'
     t='Du pétrole brut'; st='La pompe à balancier'
     d=@('La &epompe à balancier&r extrait le pétrole brut en continu. Regarde le Ponder pour la construire.') }
  @{ k='distill'; x=-3; y=4.5; deps=@('pumpjack'); tasks=@('createdieselgenerators:distillation_controller'); crate='rare'
     t='La tour de distillation'; st='Raffiner le pétrole'
     d=@('Une &etour de distillation&r (réservoirs + contrôleur, chauffée) sépare le pétrole brut en &ediesel&r, &eessence&r et autres produits.') }
  @{ k='bio'; x=-4.5; y=3; deps=@('oil'); tasks=@('createdieselgenerators:biodiesel_bucket'); crate='commune'
     t='Le biodiesel'; st='Un carburant renouvelable'
     d=@('Pas de pétrole près de chez toi ? Fabrique du &abiodiesel&r à partir d''huile végétale (graines pressées) et d''éthanol (fermenté dans la Cuve de Fermentation).') }
  @{ k='engine'; x=-3; y=6; size=1.5; deps=@('distill','bio'); tasks=@('createdieselgenerators:diesel_engine'); crate='rare'
     t='&6Le Moteur Diesel'; st='Beaucoup de puissance, peu de place'
     d=@('Le &6Moteur Diesel&r brûle du carburant liquide pour produire beaucoup de rotation.',
         '',
         'Il existe en version &egrande&r et &eénorme&r pour les usines les plus gourmandes. Un &eturbo&r augmente sa puissance, un &esilencieux&r le rend plus discret.',
         '',
         '&7Parfait aussi à bord d''un grand dirigeable !') }
  # --- Ore excavation
  @{ k='veinfinder'; x=0; y=1.5; deps=@('intro'); tasks=@('createoreexcavation:vein_finder'); crate='commune'
     t='&6Les gisements de minerai'; st='Create Ore Excavation'
     d=@('Sous le monde se cachent des &egisements&r de minerai infinis. Le &eDétecteur de Gisement&r indique s''il y en a un dans le chunk où tu te trouves.',
         '',
         'L''&eAtlas des Gisements&r garde la trace de ceux que tu as trouvés.') }
  @{ k='drilling'; x=0; y=3; deps=@('veinfinder'); tasks=@('createoreexcavation:drilling_machine','createoreexcavation:drill'); crate='rare'
     t='La Foreuse'; st='Des minerais à l''infini'
     d=@('Place une &eForeuse&r équipée d''une &etête de forage&r au-dessus d''un gisement et fais-la tourner : elle extrait des minerais &ben continu, sans jamais épuiser le gisement&r.',
         '',
         'Les têtes en &ediamant&r et en &eNetherite&r sont plus rapides et durent plus longtemps. L''&eExtracteur&r fait de même pour les gisements de liquides.',
         '',
         '&7Pense à la placer dans un de tes 5 chunks forcés pour qu''elle tourne en ton absence.') }
  # --- Logistique
  @{ k='jar'; x=3; y=1.5; deps=@('intro'); tasks=@('create_factory_logistics:jar_packager'); crate='commune'
     t='Les liquides en colis'; st='Create: Factory Logistics'
     d=@('&eFactory Logistics&r étend le réseau de colis de Create aux &bliquides&r : l''&eEmballeur à Bocaux&r met les liquides en bocaux, que le réseau transporte comme des colis.',
         '',
         'La &eJauge de Liquide&r fonctionne comme la Jauge d''Usine, mais pour les liquides.') }
  @{ k='vaults'; x=3; y=3; deps=@('jar'); tasks=@('create_vibrant_vaults:basic_shipping_container'); crate='commune'
     t='Conteneurs et coffres-forts colorés'; st='Create: Vibrant Vaults'
     d=@('&eVibrant Vaults&r ajoute des &econteneurs d''expédition&r, des coffres-forts verticaux et des versions colorées des blocs de logistique : pratique pour organiser un grand entrepôt… ou la soute d''un dirigeable !') }
  # --- Décoration
  @{ k='deco'; x=4.5; y=1.5; deps=@('intro'); tasks=@('createdeco:andesite_catwalk'); crate='commune'
     t='&7Create Deco'; st='Passerelles, lampes et portes'
     d=@('&eCreate Deco&r ajoute des passerelles, grilles, lampes, portes et coques métalliques dans le style de Create. Parfait pour habiller tes usines et tes vaisseaux.') }
  @{ k='prism'; x=4.5; y=3; deps=@('deco'); tasks=@('createprism:andesite_glass_casing'); crate='commune'
     t='Carters en verre'; st='Create: Prismatic Shine'
     d=@('Des &ecarters en verre&r et des &ecarters lumineux&r pour voir tes mécanismes tourner… ou éclairer ton usine.') }
  # --- Divers
  @{ k='jetpack'; x=1.5; y=4.5; deps=@('drilling'); tasks=@('create_jetpack:jetpack'); crate='rare'
     t='Le Jetpack à air comprimé'; st='Create Jetpack'
     d=@('Ce &ejetpack&r fonctionne avec l''&bair comprimé&r d''un réservoir dorsal de Create : le même que pour la plongée !',
         '',
         'La version en &eNetherite&r résiste au feu et va plus loin.') }
  @{ k='roost'; x=-1.5; y=4.5; deps=@('drilling'); tasks=@('create_integrated_farming:fishing_net'); crate='commune'
     t='Fermes intégrées'; st='Create: Integrated Farming'
     d=@('Perchoirs à poules (et autres volailles), filets de pêche (même dans la lave !) et &eAspirateur à Récoltes&r : de quoi automatiser les fermes avec Create.') }
  @{ k='dyes'; x=0; y=6; deps=@('roost','jetpack'); tasks=@('create_dragons_plus:red_dye_bucket'); crate='commune'; optional=$true
     t='Teintures liquides'; st='Create: Dragons Plus'
     d=@('&eDragons Plus&r ajoute des &eteintures liquides&r pour teindre en masse avec un ventilateur, des réservoirs fragiles, et d''autres petits outils pratiques.') }
)
