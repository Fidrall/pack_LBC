$Chapter = @{ file = 'aeronautics'; title = '&b&lDirigeables et Aéronautique'; subtitle = 'Construis, pilote et fais voler tes propres vaisseaux'; group = '1A00000000000002'; order = 1; icon = 'aeronautics:andesite_propeller' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='Clique pour valider'; icon='aeronautics:andesite_propeller'
     t='&b&lPrendre son envol'; st='Le cœur du pack : les vaisseaux volants'
     d=@('&bCreate Aeronautics&r te permet de construire de vrais &evaisseaux avec une physique réaliste&r : dirigeables, montgolfières, avions, hélicoptères, et même des véhicules à roues.',
         '',
         'Tout ce que tu construis a un &6poids&r, un &6centre de gravité&r, de la &6portance&r et de la &6poussée&r. Un vaisseau mal équilibré penchera, tombera ou tournera sur lui-même : il faudra tester et ajuster !',
         '',
         'Ce chapitre te guide pas à pas : faire bouger ta première construction, gonfler ton premier ballon, te propulser, puis piloter, et enfin maîtriser la lévitite et les propulseurs.',
         '',
         '&aAstuce :&r le &6Ponder&r (touche W en survolant un bloc) montre des animations pour presque tous les blocs de ce chapitre. N''hésite pas à t''en servir !',
         '',
         '&7Les vaisseaux sont aussi le meilleur moyen de voyager loin sur ce serveur : les waystones et les téléporteurs coûtent cher sur les longues distances.') }

  # --- Premiers pas
  @{ k='assembler'; x=0; y=2; size=1.5; deps=@('intro'); tasks=@('simulated:physics_assembler'); crate='commune'
     t='&6L''Assembleur Physique'; st='Le point de départ de tout vaisseau'
     d=@('L''&6Assembleur Physique&r transforme un groupe de blocs en &econstruction simulée&r : un objet physique qui peut voler, flotter, tomber ou rouler.',
         '',
         '&n&aComment faire :&r',
         '1) Colle les blocs de ta construction ensemble avec de la &eColle au Miel&r ou de la &eSuper Colle&r.',
         '2) Pose l''Assembleur contre la construction.',
         '3) Maintiens le clic droit et tire le levier : la construction s''assemble !',
         '',
         'Une fois assemblée, la construction n''a plus besoin de l''Assembleur, et &bn''importe quel Assembleur&r peut la désassembler.',
         '',
         'Tu peux toujours interagir avec les blocs d''une construction assemblée : ouvrir les coffres, utiliser les machines, marcher dessus…') }
  @{ k='honeyglue'; x=1.5; y=2; deps=@('assembler'); tasks=@('simulated:honey_glue'); crate='commune'
     t='La Colle au Miel'; st='La colle idéale pour les vaisseaux'
     d=@('La &eColle au Miel&r est une alternative pratique à la Super Colle, faite pour les constructions simulées.',
         '',
         'Clique deux coins pour créer une zone collée, puis utilise &aCtrl + molette&r pour l''agrandir ou la réduire. Maintiens &aAlt&r pour placer un coin en l''air.',
         '',
         'Contrairement à la Super Colle, elle &cne crée pas de liaisons indésirables&r sur les constructions complexes.',
         '',
         'Elle se fabrique en remplissant une plaque de fer avec du miel, grâce à un Bec Verseur.') }
  @{ k='goggles'; x=-1.5; y=2; deps=@('assembler'); tasks=@('aeronautics:aviators_goggles'); crate='commune'
     t='Les Lunettes d''Aviateur'; st='Des infos en plus pour les pilotes'
     d=@('Comme les Lunettes d''Ingénieur, elles affichent des informations sur les blocs : contrainte, capacité, contenu…',
         '',
         'Elles montrent en plus la &bpoussée et le flux d''air des hélices&r et les données des ballons. Indispensable pour régler un vaisseau !') }
  @{ k='diagram'; x=-3; y=2; deps=@('goggles'); tasks=@('simulated:contraption_diagram'); crate='commune'
     t='Le Diagramme de Construction'; st='Comprendre pourquoi ça ne vole pas'
     d=@('Fais un clic droit sur une construction simulée avec le &eDiagramme&r pour voir toutes les forces qui s''exercent dessus : &6poids, portance, poussée&r…',
         '',
         'Ton vaisseau penche ou refuse de décoller ? Le diagramme te dira pourquoi.') }
  @{ k='nameplate'; x=3; y=2; deps=@('honeyglue'); tasks=@('simulated:white_nameplate'); crate='commune'
     t='Baptiser son vaisseau'; st='Tout vaisseau mérite un nom'
     d=@('La &ePlaque de Nom&r affiche le nom de ta construction simulée.',
         '',
         'Pratique pour reconnaître les vaisseaux de chaque équipe !') }

  # --- Ballons
  @{ k='envelope'; x=-1.5; y=3.5; deps=@('assembler'); tasks=@('aeronautics:white_envelope*16'); crate='commune'
     t='&eLes Enveloppes'; st='La toile de ton ballon'
     d=@('Les &eEnveloppes&r forment le ballon de ton dirigeable. Elles enferment un volume qui produit de la &bportance&r quand il est rempli d''air chaud.',
         '',
         '&n&aRègles importantes :&r',
         '- L''air chaud remplit le ballon &bdu haut vers le bas&r.',
         '- Il doit être &bétanche&r : pas de trou !',
         '- Les blocs à l''intérieur du ballon &créduisent le volume&r utile.',
         '- Un axe peut traverser le ballon s''il est recouvert d''enveloppe (axe enveloppé).',
         '',
         'Fais un clic droit avec de la teinture pour les colorer.') }
  @{ k='burner'; x=-3; y=3.5; deps=@('envelope'); tasks=@('aeronautics:adjustable_burner'); crate='rare'
     t='&6Le Brûleur à Air Chaud'; st='Ta première source de portance'
     d=@('Placé sous un ballon, le &6Brûleur à Air Chaud&r le remplit progressivement d''air chaud quand il reçoit un &csignal de redstone&r.',
         '',
         '- Son panneau règle le débit maximum.',
         '- La &cforce du signal&r règle le débit : un signal plus faible = moins de portance.',
         '- Plusieurs brûleurs peuvent remplir le même ballon.',
         '- La portance est limitée par la &btaille du ballon&r.',
         '',
         '&n&aMonter et descendre :&r plus tu montes, plus l''air est rare et plus la portance diminue. Le vaisseau se stabilise quand portance et poids s''équilibrent : en changeant la portance, tu changes d''altitude !',
         '',
         '&7Un objet infusé d''âme change la couleur de la flamme, juste pour le style.') }
  @{ k='balloon'; x=-3; y=5; size=1.5; shape='hexagon'; deps=@('burner'); tasks=@('@check'); checkTitle='Mon ballon a décollé !'; crate='rare'
     t='&b&lTa première montgolfière'; st='Défi : décoller du sol'
     d=@('&n&aDéfi :&r construis une petite montgolfière et fais-la décoller !',
         '',
         '&7Un exemple simple :&r',
         '1) Une plateforme de quelques blocs, avec un siège.',
         '2) Au centre, un Brûleur à Air Chaud relié à un levier.',
         '3) Au-dessus, un ballon d''enveloppes fermé de tous les côtés, avec une ouverture juste au-dessus du brûleur.',
         '4) Colle tout avec la Colle au Miel, assemble avec l''Assembleur Physique, et active le brûleur.',
         '',
         'Si ça ne monte pas : agrandis le ballon, ajoute un brûleur ou allège la plateforme.',
         '',
         'Valide la quête quand tu as réussi à décoller.') }
  @{ k='steamvent'; x=-4.5; y=3.5; deps=@('burner'); tasks=@('aeronautics:steam_vent'); crate='rare'
     t='La Bouche de Vapeur'; st='De la portance à la vapeur'
     d=@('La &eBouche de Vapeur&r remplit aussi les ballons, mais avec de la &bvapeur&r.',
         '',
         'Comme un Moteur à Vapeur, elle a besoin de &cchaleur&r, d''&beau&r et d''une &6chaudière&r assez grande. Elle s''active avec la redstone, et plusieurs bouches peuvent partager un ballon.',
         '',
         'Plus complexe, mais idéale pour les très gros dirigeables.') }
  @{ k='altitude'; x=-4.5; y=5; deps=@('balloon'); tasks=@('simulated:altitude_sensor'); crate='commune'
     t='Le Capteur d''Altitude'; st='Savoir à quelle hauteur on vole'
     d=@('Il émet un signal de redstone selon l''&baltitude&r : plus tu montes, plus le signal est fort (réglable dans son interface).',
         '',
         'Relie-le à tes brûleurs pour créer un &apilote automatique d''altitude&r !') }

  # --- Propulsion simple
  @{ k='propbearing'; x=1.5; y=3.5; deps=@('assembler'); tasks=@('aeronautics:propeller_bearing'); crate='commune'
     t='&6Le Roulement d''Hélice'; st='Transformer la rotation en poussée'
     d=@('Le &6Roulement d''Hélice&r se fixe au bloc devant lui et transforme un ensemble de voiles en &bhélice qui pousse&r.',
         '',
         '- Il faut au moins &e2 blocs de type voile&r pour faire une hélice valide.',
         '- &bPlus il y a de voiles, plus l''hélice est efficace.&r',
         '- Inverser le sens de rotation (ou utiliser une clé) inverse la poussée.',
         '- Une hélice qui avance vite pousse moins fort, car l''air bouge déjà.',
         '- Comme les brûleurs, la poussée &cdiminue avec l''altitude&r.',
         '',
         'Les Lunettes affichent la poussée et le flux d''air de chaque hélice.') }
  @{ k='propeller'; x=3; y=3.5; deps=@('propbearing'); tasks=@('aeronautics:andesite_propeller'); crate='commune'
     t='Des hélices toutes faites'; st='Pas envie de construire la tienne ?'
     d=@('L''&eHélice en Andésite&r et l''&eHélice en Bois&r sont des hélices prêtes à l''emploi.',
         '',
         'Elles se montent directement sur un roulement d''hélice. On passe de l''une à l''autre dans la table de fabrication, c''est juste une question de style.') }
  @{ k='gyromech'; x=3; y=5; deps=@('propbearing'); tasks=@('simulated:gyroscopic_mechanism'); crate='rare'
     t='Le Mécanisme Gyroscopique'; st='Une pièce de précision'
     d=@('Le &eMécanisme Gyroscopique&r s''obtient par &6assemblage séquencé&r à partir d''une plaque de fer (regarde la recette dans JEI).',
         '',
         'Il sert à fabriquer les hélices intelligentes et les roulements gyroscopiques, qui gardent ton vaisseau stable.') }
  @{ k='smartprop'; x=4.5; y=5; deps=@('gyromech'); tasks=@('aeronautics:smart_propeller'); crate='commune'
     t='L''Hélice Intelligente'; st='Elle s''oriente toute seule'
     d=@('Elle produit de la poussée quand elle tourne, et &bs''incline d''elle-même&r sur un axe pour essayer de pointer vers le haut.',
         '',
         'Une clé inverse le sens de sa poussée.') }
  @{ k='gyrobearing'; x=1.5; y=5; deps=@('gyromech'); tasks=@('aeronautics:gyroscopic_propeller_bearing'); crate='rare'
     t='Le Roulement Gyroscopique'; st='Pour les hélicoptères'
     d=@('Un roulement d''hélice qui &bgarde son hélice droite&r : parfait pour les &ehélicoptères&r, que les roulements normaux rendent instables.',
         '',
         'Tourné vers le bas, il peut aussi &astabiliser une construction trop lourde en haut&r.',
         '',
         'Un signal de redstone remet son inclinaison à zéro.') }
  @{ k='firstflight'; x=0; y=6.5; size=2; shape='hexagon'; deps=@('balloon','propbearing'); tasks=@('@check'); checkTitle='Mon dirigeable avance !'; crate='epique'
     t='&b&lTon premier dirigeable'; st='Défi : voler et se diriger'
     d=@('&n&aDéfi :&r ajoute des hélices à ta montgolfière pour en faire un vrai &bdirigeable&r !',
         '',
         '- Une ou deux hélices à l''arrière pour avancer.',
         '- De quoi les faire tourner : une manivelle pour commencer, puis un moteur (voir plus bas).',
         '- Garde le &6centre de gravité&r au milieu, sinon le vaisseau penchera.',
         '',
         'Pour tourner, fais varier la vitesse d''une hélice de gauche et d''une hélice de droite, ou utilise un gouvernail avec des Voiles Symétriques.',
         '',
         'Valide quand ton dirigeable vole et avance. Bravo, pilote !') }

  # --- Piloter
  @{ k='engine'; x=-3; y=8; deps=@('firstflight'); tasks=@('simulated:red_portable_engine'); crate='rare'
     t='&6Le Moteur Portable'; st='De la rotation à bord'
     d=@('Le &6Moteur Portable&r produit de la rotation en &cbrûlant du combustible&r : parfait pour faire tourner tes hélices en vol, sans roue à eau ni moulin.',
         '',
         '- Il peut tourner dans les deux sens.',
         '- On peut l''alimenter automatiquement en combustible.',
         '- Avec un &eGâteau de Blaze&r, il passe en surchauffe pour plus de puissance.',
         '',
         'Il se fabrique avec un &eAssemblage Moteur&r (assemblage séquencé), et se décline en plusieurs couleurs.') }
  @{ k='wheel'; x=-1.5; y=8; deps=@('firstflight'); tasks=@('simulated:steering_wheel'); crate='commune'
     t='&6Le Volant'; st='Prendre les commandes'
     d=@('Le &6Volant&r donne une rotation précise : maintiens le clic droit pour le saisir, puis bouge la souris pour tourner.',
         '',
         '- Accroupi, il tourne par crans de 45°.',
         '- Son panneau règle l''angle maximum.',
         '- Un comparateur peut lire son angle, ou savoir si quelqu''un le tient.',
         '',
         '&cAttention :&r les roulements reliés au volant doivent être réglés pour &cne pas se désassembler&r.',
         '',
         '&7Des planches changent son apparence.') }
  @{ k='throttle'; x=0; y=8; deps=@('firstflight'); tasks=@('simulated:throttle_lever'); crate='commune'
     t='&6La Manette des Gaz'; st='Doser la puissance'
     d=@('Une source de redstone &bprécise et compacte&r : clique et fais glisser pour régler la force du signal.',
         '',
         'Parfaite pour doser la puissance de tes brûleurs ou de tes propulseurs. Une clé inverse le signal.') }
  @{ k='typewriter'; x=1.5; y=8; deps=@('throttle'); tasks=@('simulated:linked_typewriter'); crate='rare'
     t='La Machine à Écrire Liée'; st='Un cockpit dans un bloc'
     d=@('Associe des fréquences de &eLiaison Redstone&r à ses touches : tu contrôles ton vaisseau au clavier, comme avec un tableau de bord.',
         '',
         'Pendant que tu l''utilises, elle prend le contrôle de tes touches de déplacement.') }
  @{ k='velocity'; x=-1.5; y=9.5; deps=@('wheel'); tasks=@('simulated:velocity_sensor'); crate='commune'
     t='Le Capteur de Vitesse'; st='Savoir à quelle vitesse on va'
     d=@('Il émet un signal de redstone selon la &bvitesse&r du vaisseau. La vitesse du signal maximum se règle sur son panneau.') }
  @{ k='gimbal'; x=0; y=9.5; deps=@('throttle'); tasks=@('simulated:gimbal_sensor'); crate='commune'
     t='Le Capteur Gyroscopique'; st='Rester à l''horizontale'
     d=@('Il émet un signal selon l''&binclinaison&r du vaisseau, vers le côté qui descend.',
         '',
         'Relié à des hélices ou des brûleurs, il permet de faire un &astabilisateur automatique&r.') }
  @{ k='navtable'; x=1.5; y=9.5; deps=@('typewriter'); tasks=@('simulated:navigation_table'); crate='rare'
     t='La Table de Navigation'; st='Le début du pilote automatique'
     d=@('Donne-lui un &eobjet de navigation&r (regarde le Ponder pour la liste) : elle émet un signal de redstone &bdans la direction de la destination&r.',
         '',
         'Le signal est plus faible quand tu ne regardes pas droit vers la cible.',
         '',
         'C''est la base d''un &apilote automatique&r et d''un indicateur de cap.') }
  @{ k='optical'; x=3; y=9.5; deps=@('navtable'); tasks=@('simulated:optical_sensor'); crate='commune'
     t='Le Capteur Optique'; st='Détecter les obstacles'
     d=@('Il envoie un rayon et émet un signal quand un bloc le coupe, d''autant plus fort que le bloc est proche.',
         '',
         'Utile comme &ealtimètre&r ou &edétecteur d''obstacles&r pour l''atterrissage.') }
  @{ k='sail'; x=-3; y=9.5; deps=@('engine'); tasks=@('simulated:white_symmetric_sail*4'); crate='commune'
     t='Les Voiles Symétriques'; st='Gouvernails et stabilisateurs'
     d=@('Les &eVoiles Symétriques&r ne produisent pas de portance, seulement de la &btraînée&r.',
         '',
         'Inclinées face au vent, elles freinent et font tourner le vaisseau : parfaites pour les &egouvernails&r et les &estabilisateurs&r.',
         '',
         'Elles s''assemblent facilement en moulins, et se teignent de toutes les couleurs.') }

  # --- Voyager et s'amarrer
  @{ k='docking'; x=0; y=11; deps=@('gimbal'); tasks=@('simulated:docking_connector*2'); crate='rare'
     t='&6L''Amarrage'; st='Se connecter à une base ou à un autre vaisseau'
     d=@('Les &6Connecteurs d''Amarrage&r fonctionnent par paires : déploie-les l''un vers l''autre, et une fois alignés ils se verrouillent en une &bliaison rigide&r.',
         '',
         'Une fois amarrés, &aobjets et liquides peuvent passer&r dans les deux sens : idéal pour ravitailler un vaisseau ou décharger une cargaison automatiquement.',
         '',
         'Rétracte l''un des deux pour se désamarrer.') }
  @{ k='rope'; x=1.5; y=11; deps=@('docking'); tasks=@('simulated:rope_winch','simulated:rope_coupling'); crate='commune'
     t='Cordes et treuils'; st='Remorquer et hisser'
     d=@('Un clic droit sur un &eTreuil&r et un &eConnecteur de Corde&r avec un &eRaccord de Corde&r les relie par une corde.',
         '',
         'Avec de la rotation, le treuil enroule ou déroule la corde : parfait pour hisser des charges ou remorquer un autre vaisseau.',
         '',
         'Des cisailles coupent la corde, et une clé permet de glisser le long.') }
  @{ k='waystone'; x=-1.5; y=11; deps=@('docking'); tasks=@('waystones:waystone'); crate='rare'
     t='Une waystone à bord'; st='Retrouver son vaisseau n''importe où'
     d=@('Grâce à &eWaystones: Sable&r, tu peux poser une &ewaystone sur ton vaisseau&r !',
         '',
         'Elle apparaît dans un groupe à part dans le menu des waystones, et te permet de &bte téléporter directement sur ton vaisseau&r, où qu''il soit.',
         '',
         'Pratique pour retrouver ton dirigeable garé loin de ta base.') }
  @{ k='cannon'; x=-3; y=11; deps=@('sail'); tasks=@('aeronautics:mounted_potato_cannon'); crate='commune'; optional=$true
     t='Le Canon à Patates Monté'; st='Pour défendre ton vaisseau'
     d=@('Une version bloc du Canon à Patates : il accepte les mêmes munitions et peut être rechargé automatiquement.',
         '',
         'Fais-le tourner pour le charger, puis donne-lui un signal de redstone pour tirer. Un signal continu = tir automatique.') }

  # --- Lévitite
  @{ k='endstone'; x=4.5; y=6.5; deps=@('firstflight'); tasks=@('aeronautics:end_stone_powder*16'); crate='rare'
     t='&dLa Poudre de Pierre de l''End'; st='Il va falloir aller dans l''End'
     d=@('La &dlévitite&r, le cristal qui fait flotter les vaisseaux, demande de la &epierre de l''End&r : c''est donc un objectif &cd''après l''Ender Dragon&r !',
         '',
         'Broie de la pierre de l''End avec des &6Roues de Broyage&r pour obtenir de la &dPoudre de Pierre de l''End&r.',
         '',
         'Pense à en ramener beaucoup de ton voyage dans l''End.') }
  @{ k='blend'; x=6; y=6.5; deps=@('endstone'); tasks=@('aeronautics:levitite_blend_bucket'); crate='rare'
     t='&dLe Mélange de Lévitite'; st='Un liquide pas comme les autres'
     d=@('Mélange 4 poudres de pierre de l''End, 2 pépites de zinc et de l''eau dans un &6bassin chauffé&r (Brûleur à Blaze) avec un &6Mélangeur Mécanique&r.',
         '',
         'Tu obtiens du &dMélange de Lévitite&r liquide.') }
  @{ k='levitite'; x=7.5; y=6.5; size=1.5; shape='hexagon'; deps=@('blend'); tasks=@('aeronautics:levitite*8'); crate='epique'
     t='&d&lLa Lévitite'; st='Le cristal qui défie la gravité'
     d=@('Verse le mélange dans un moule, puis &capplique de la chaleur&r : il se cristallise en &dLévitite&r. Une fois lancée, la réaction s''étend à tout le liquide.',
         '',
         '&cAttention :&r certains blocs utilisés comme moule sont détruits pendant la cristallisation, et la lévitite ne peut plus redevenir liquide.',
         '',
         '&n&aCe qu''elle fait :&r',
         '- Assez de lévitite sur un vaisseau le &bmaintient en l''air&r.',
         '- Mais elle &cne le fait pas monter&r : il faut d''autres forces (hélices, ballons, propulseurs).',
         '- À faible vitesse, elle &bfreine fortement&r les mouvements ; moins à grande vitesse.',
         '',
         'Idéale pour des vaisseaux stables… ou des îles flottantes !') }

  # --- Create Propulsion
  @{ k='platinum'; x=6; y=8; deps=@('firstflight'); tasks=@('createpropulsion:platinum_ingot*8'); crate='commune'
     t='&7Le Platine'; st='Le métal de Propulsion'
     d=@('Le &7Platine&r est le métal de base de &eCreate Propulsion&r.',
         '',
         'Son minerai se trouve sous terre (aussi en version ardoise des abîmes). Comme les autres minerais, broie-le et lave-le avec Create pour en tirer plus de lingots.',
         '',
         'Il sert à fabriquer le Carter en Platine, les réservoirs en platine (deux fois plus grands que ceux en cuivre) et les machines de propulsion.') }
  @{ k='resin'; x=7.5; y=8; deps=@('platinum'); tasks=@('createpropulsion:pine_resin*8'); crate='commune'
     t='La Résine de Pin'; st='Le début du carburant'
     d=@('Broie des &ebûches de sapin&r avec des Roues de Broyage : tu as 60 % de chance d''obtenir de la &eRésine de Pin&r.',
         '',
         'Une ferme à sapins automatique avec une scie mécanique te fournira tout le carburant dont tu as besoin.') }
  @{ k='turpentine'; x=9; y=8; deps=@('resin'); tasks=@('createpropulsion:turpentine_bucket'); crate='rare'
     t='&6La Térébenthine'; st='Le carburant des propulseurs'
     d=@('Mélange de la résine de pin avec de l''eau dans un bassin, avec un Mélangeur Mécanique : tu obtiens de la &6Térébenthine&r.',
         '',
         'C''est le carburant des propulseurs. Accroupis-toi en survolant le seau pour voir sa poussée et sa consommation.') }
  @{ k='thruster'; x=7.5; y=9.5; size=1.5; deps=@('turpentine'); tasks=@('createpropulsion:thruster'); crate='rare'
     t='&c&lLe Propulseur'; st='De la poussée brute'
     d=@('Le &cPropulseur&r pousse ton vaisseau dans une direction, comme un moteur de fusée.',
         '',
         '- Alimente-le en &6Térébenthine&r avec un tuyau.',
         '- Donne-lui un &csignal de redstone&r : la force du signal règle la puissance.',
         '',
         'Plus besoin d''hélices : les propulseurs permettent des vaisseaux &brapides&r et des &bavions&r. On peut même les assembler en propulseurs géants de 2×2×2 ou 3×3×3 !') }
  @{ k='vector'; x=9; y=9.5; deps=@('thruster'); tasks=@('createpropulsion:vector_thruster'); crate='rare'
     t='Le Propulseur Orientable'; st='Pousser et diriger à la fois'
     d=@('Un propulseur qui peut aussi &bs''orienter&r (lacet et tangage) pour diriger sa poussée.',
         '',
         'Chaque côté accepte un signal de redstone qui l''incline dans cette direction. La version &eà carburant liquide&r fonctionne à la térébenthine, la version normale à l''électricité (FE).') }
  @{ k='ion'; x=10.5; y=9.5; deps=@('vector'); tasks=@('createpropulsion:ion_thruster'); crate='rare'
     t='Le Propulseur Ionique'; st='Sans carburant, à l''électricité'
     d=@('Il fonctionne à l''&eélectricité (FE)&r au lieu du carburant. Alimente-le avec des câbles, un Alternateur de Crafts and Additions ou un Générateur à Corail.',
         '',
         'Plus besoin de faire le plein, mais il faut une bonne source d''énergie à bord.') }
  @{ k='wing'; x=6; y=9.5; deps=@('platinum'); tasks=@('createpropulsion:wing*4'); crate='commune'
     t='Les Ailes'; st='Pour les avions'
     d=@('Les &eAiles&r forment des surfaces aérodynamiques : elles produisent de la &bportance quand l''air passe dessus&r, selon la vitesse et l''angle.',
         '',
         'Les &eAiles Trempées&r sont une version renforcée, et les &eAiles Copycat&r prennent l''apparence de n''importe quel bloc.',
         '',
         'Avec des propulseurs, tu peux construire un vrai &bavion&r !') }
  @{ k='stirling'; x=4.5; y=9.5; deps=@('platinum'); tasks=@('createpropulsion:solid_burner','createpropulsion:stirling_engine'); crate='rare'
     t='Brûleur et Moteur Stirling'; st='Chaleur → rotation'
     d=@('Le &eBrûleur Solide&r (ou &eLiquide&r) produit de la chaleur avec du combustible.',
         '',
         'Placé dessous, il fait tourner le &eMoteur Stirling&r, qui produit de la rotation. Sans chaleur, le moteur ralentit puis s''arrête.',
         '',
         'Une autre façon d''alimenter tes vaisseaux en rotation.') }
  @{ k='tilt'; x=7.5; y=11; deps=@('thruster'); tasks=@('createpropulsion:tilt_adapter'); crate='commune'
     t='L''Adaptateur d''Inclinaison'; st='Incliner avec de la redstone'
     d=@('Il &bincline sa sortie de rotation&r selon un signal de redstone analogique : plus le signal est fort d''un côté, plus il penche de ce côté.',
         '',
         'La version avancée permet de régler l''angle maximum de chaque côté.') }

  # --- Offroad
  @{ k='wheelmount'; x=-4.5; y=8; deps=@('assembler'); tasks=@('offroad:wheel_mount*4'); crate='commune'
     t='&2Les véhicules terrestres'; st='Pas besoin de voler pour voyager'
     d=@('Le &2Support de Roue&r permet à une construction simulée de &2rouler&r.',
         '',
         '- Un signal de redstone par le dessus &cfreine&r la roue.',
         '- Un signal par le côté la fait &bbraquer&r de ce côté.',
         '',
         'Voitures, camions, chars… tout est possible !') }
  @{ k='tires'; x=-6; y=8; deps=@('wheelmount'); tasks=@('offroad:tire*4'); crate='commune'
     t='Les pneus'; st='Pour tous les terrains'
     d=@('Fais un clic droit sur un support de roue avec un pneu pour l''installer.',
         '',
         'Il en existe plusieurs tailles : &epetit, normal, grand et monstrueux&r.') }
  @{ k='borehead'; x=-6; y=9.5; deps=@('tires'); tasks=@('offroad:borehead_bearing','offroad:rockcutting_wheel'); crate='rare'
     t='&6Le tunnelier'; st='Creuser des tunnels à la machine'
     d=@('Le &6Roulement de Forage&r, équipé de &6Roues de Coupe&r et d''un rangement, devient une &6foreuse géante&r.',
         '',
         '- Les roues de coupe cassent les blocs &btout autour d''elles&r, et s''attachent toutes seules sans colle.',
         '- Il tourne à 1/4 de la vitesse reçue, et la vitesse de minage dépend de la rotation.',
         '- Plus il casse de blocs à la fois, plus il ralentit : plusieurs roulements compensent.',
         '- Les objets vont dans le rangement de la foreuse. Quand il est plein, elle s''arrête : vide-le directement depuis le roulement.',
         '',
         'Monte-le sur un véhicule à roues et tu as un &etunnelier&r !') }

  # --- Final
  @{ k='master'; x=7.5; y=12.5; size=2.5; shape='gear'; deps=@('levitite','ion','navtable','docking'); tasks=@('aeronautics:levitite*32','createpropulsion:vector_thruster*4','simulated:navigation_table','simulated:docking_connector*2'); crate='legendaire'; xp=2000
     t='&6&lMaître des Airs'; st='L''objectif final du chapitre'
     d=@('Tu maîtrises maintenant tout ce qu''il faut pour construire le vaisseau de tes rêves.',
         '',
         '&n&aDernier défi :&r réunis de quoi construire un &bvaisseau amiral&r : lévitite pour flotter, propulseurs orientables pour manœuvrer, table de navigation pour le pilote automatique et connecteurs pour s''amarrer.',
         '',
         'Ton vaisseau pourra devenir ta &6base volante&r : ferme, usine, entrepôt… tout peut voler !',
         '',
         '&6&lBravo, Maître des Airs !&r') }
)
