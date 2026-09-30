$Chapter = @{ file = 'aether'; title = '&e&lL''Aether'; subtitle = 'Le paradis des îles flottantes'; group = '1A00000000000005'; order = 1; icon = 'aether:golden_parachute' }
$Quests = @(
  @{ k='portal'; x=0; y=0; size=2; shape='gear'; tasks=@('adv:aether:enter_aether'); icon='minecraft:glowstone'; crate='rare'
     t='&e&lDirection le ciel'; st='Un portail de pierre lumineuse'
     d=@('L''&eAether&r est une dimension d''&bîles flottantes&r au-dessus des nuages, avec ses propres ressources, créatures et donjons.',
         '',
         '&n&aConstruire le portail :&r comme un portail du Nether (cadre de 4×5), mais en &eblocs de pierre lumineuse&r. Verse ensuite un &bseau d''eau&r à l''intérieur pour l''activer.',
         '',
         '&cAttention au vide :&r tomber des îles te ramène dans l''Overworld… en tombant de très haut ! Garde un moyen de te rattraper (seau d''eau, cape de Valkyrie, parachute).') }
  @{ k='skyroot'; x=-2; y=0; deps=@('portal'); tasks=@('aether:skyroot_log*8'); crate='commune'
     t='Le bois de Ciel-Racine'; st='Tout recommencer là-haut'
     d=@('Le &eCiel-Racine&r est le bois de l''Aether.',
         '',
         'Ses outils sont faibles, mais ils ont un bonus : l''&epioche&r double les minerais, la &ehache&r double le bois, l''&eépée&r double le butin des créatures.') }
  @{ k='holystone'; x=-3.5; y=0; deps=@('skyroot'); tasks=@('aether:holystone*16'); crate='commune'
     t='La Pierre Sainte'; st='La pierre de l''Aether'
     d=@('La &ePierre Sainte&r est la pierre de l''Aether. Ses outils font parfois tomber des éclats d''&eAmbrosium&r.') }
  @{ k='ambrosium'; x=-2; y=1.5; deps=@('holystone'); tasks=@('aether:ambrosium_shard*8'); crate='commune'
     t='L''Ambrosium'; st='Le charbon du ciel'
     d=@('L''&eAmbrosium&r sert de combustible, de torche, et peut &aenchanter l''herbe de l''Aether&r pour faire pousser plus vite.',
         '',
         'C''est aussi le carburant de l''&eAutel&r.') }
  @{ k='altar'; x=-3.5; y=1.5; deps=@('ambrosium'); tasks=@('aether:altar'); crate='commune'
     t='L''Autel'; st='Enchanter à la mode de l''Aether'
     d=@('L''&eAutel&r « enchante » certains objets de l''Aether (comme la gravitite) et &arépare les outils&r, avec de l''Ambrosium comme carburant.',
         '',
         'Le &eCongélateur&r, lui, gèle l''eau, la glace et la lave avec de la Pierre de Glace.') }
  @{ k='zanite'; x=-2; y=3; deps=@('ambrosium'); tasks=@('aether:zanite_gemstone*8'); crate='commune'
     t='La Zanite'; st='La gemme bleue'
     d=@('La &eZanite&r se mine avec une pioche en Pierre Sainte.',
         '',
         'Ses outils et son épée ont une particularité : &bplus ils sont usés, plus ils sont efficaces&r !') }
  @{ k='gravitite'; x=-3.5; y=3; deps=@('zanite','altar'); tasks=@('aether:enchanted_gravitite*4'); crate='rare'
     t='&dLa Gravitite'; st='Le minerai qui défie la gravité'
     d=@('La &dGravitite&r se mine avec une pioche en zanite. Elle ne se fond pas : elle s''&eenchante sur l''Autel&r.',
         '',
         'Ses outils peuvent &bprojeter les blocs dans le ciel&r (clic droit), son épée envoie les ennemis en l''air, et l''armure complète permet de faire de grands bonds.',
         '',
         '&7La hache en gravitite est la seule à pouvoir couper les Chênes Dorés.') }
  @{ k='moa'; x=2; y=0; deps=@('portal'); tasks=@('adv:aether:incubate_moa'); crate='rare'
     t='&bÉlever un Moa'; st='Ta monture de l''Aether'
     d=@('Les &bMoas&r sont de grands oiseaux. Ils pondent parfois des &eŒufs de Moa&r.',
         '',
         'Place un œuf dans un &eIncubateur&r (alimenté en torches d''Ambrosium) : un bébé Moa éclot. Nourris-le avec des &eBaies Blanches&r pour qu''il grandisse, puis selle-le.',
         '',
         'Les Moas peuvent &bsauter en l''air plusieurs fois&r et planer : les meilleures montures pour explorer les îles ! Le &eBâton de la Nature&r leur dit de s''asseoir.',
         '',
         'Il existe plusieurs couleurs de Moas, dont le rare &0Moa Noir&r.') }
  @{ k='blackmoa'; x=3.5; y=0; deps=@('moa'); tasks=@('adv:aether:black_moa'); crate='rare'; optional=$true
     t='Le Moa Noir'; st='Le plus rare de tous'
     d=@('Le &0Moa Noir&r est le plus puissant des Moas : il peut sauter plus de fois que les autres.',
         '',
         'Son œuf ne s''obtient qu''en récompense d''un donjon. Bonne chance !') }
  @{ k='phyg'; x=2; y=1.5; deps=@('moa'); tasks=@('adv:aether:mount_phyg'); crate='commune'
     t='Quand les cochons volent'; st='Monter un Phyg'
     d=@('Les &eCochons Ailés&r (Phygs) et les &eVaches Volantes&r de l''Aether peuvent être sellés et montés.',
         '',
         'Oui, les cochons volent enfin !') }
  @{ k='lifeshard'; x=3.5; y=1.5; deps=@('phyg'); tasks=@('aether:life_shard'); crate='rare'
     t='Éclat de Vie'; st='Un cœur de plus, pour toujours'
     d=@('Un &cÉclat de Vie&r donne &cun cœur supplémentaire permanent&r quand on l''utilise.',
         '',
         'On en trouve dans les coffres des donjons. Avec Spice of Life, c''est l''autre moyen d''augmenter sa vie !') }
  @{ k='bronze'; x=0; y=2; size=1.5; deps=@('portal'); tasks=@('adv:aether:bronze_dungeon'); icon='aether:bronze_dungeon_key'; crate='rare'
     t='&6Le Donjon de Bronze'; st='Boss : le Glisseur'
     d=@('Le &6Donjon de Bronze&r est caché &esous terre&r, fait de grandes salles de pierre gravée. Méfie-toi des &eSentinelles&r, qui explosent comme des creepers.',
         '',
         'Son boss, le &6Glisseur&r, est un gros cube de pierre qui fonce sur toi. On ne peut le blesser qu''avec une &epioche&r : plus elle est bonne, plus tu fais de dégâts.',
         '',
         '&7Attention aux Mimiques : certains coffres sont des monstres !') }
  @{ k='silver'; x=0; y=3.5; size=1.5; deps=@('bronze'); tasks=@('adv:aether:silver_dungeon'); icon='aether:silver_dungeon_key'; crate='epique'
     t='&f&lLe Donjon d''Argent'; st='Boss : la Reine Valkyrie'
     d=@('Le &fDonjon d''Argent&r est un temple grec construit &esur de grands nuages&r : facile à repérer.',
         '',
         'Des &eValkyries&r y patrouillent. Pour affronter la &fReine Valkyrie&r, tu dois d''abord en battre assez pour réunir &e10 Médailles de Victoire&r.',
         '',
         'Elle fonce en frappant avec son épée et lance des éclairs. Ses récompenses : l''&earmure de Valkyrie&r, la Lance de Valkyrie (10 blocs de portée !) et la cape de Valkyrie (chute lente).') }
  @{ k='gold'; x=0; y=5; size=2; shape='hexagon'; deps=@('silver'); tasks=@('adv:aether:gold_dungeon'); icon='aether:gold_dungeon_key'; crate='legendaire'; xp=1500
     t='&6&lLe Donjon d''Or'; st='Boss final : l''Esprit du Soleil'
     d=@('Le &6Donjon d''Or&r est enfoui sous une grande île couverte de &eChênes Dorés&r.',
         '',
         'L''&6Esprit du Soleil&r ne peut pas être attaqué tout de suite : &eparle-lui plusieurs fois&r (clic droit) pour lancer le combat.',
         '',
         'Il fait pleuvoir le feu. Pour le blesser, &brenvoie ses boules de glace&r sur lui. Une bonne protection contre le feu est indispensable.',
         '',
         'Il donne l''&6armure de Phénix&r (qui devient armure d''Obsidienne dans l''eau).',
         '',
         '&6&lTu as conquis l''Aether !&r') }
  @{ k='accessories'; x=2; y=3.5; deps=@('bronze'); tasks=@('aether:regeneration_stone'); crate='rare'
     t='Les accessoires'; st='Gants, anneaux, capes…'
     d=@('L''Aether a ses propres emplacements d''&eaccessoires&r : gants, anneaux, pendentifs et capes.',
         '',
         'Parmi les meilleurs : la &ePierre de Régénération&r (soigne en continu), les &eBottes de Sentinelle&r (plus de dégâts de chute), la &eCape d''Invisibilité&r et le &eBouclier de Répulsion&r (renvoie les projectiles).',
         '',
         'On les trouve surtout dans les coffres des donjons.') }
  @{ k='weapons'; x=-2; y=5; deps=@('silver'); tasks=@('aether:hammer_of_kingbdogz'); crate='rare'; optional=$true
     t='Les armes légendaires'; st='Des trésors de donjon'
     d=@('Les donjons cachent des armes uniques : le &eMarteau de Kingbdogz&r (tire des projectiles), l''&eÉpée Vampire&r (vol de vie), l''&eÉpée de Foudre&r, l''&eArc Phénix&r (flèches enflammées), l''&eÉpée Sacrée&r…',
         '',
         'Chaque joueur voudra sa préférée !') }
)
