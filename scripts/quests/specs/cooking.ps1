$Chapter = @{ file = 'cooking'; title = '&6&lCuisine et agriculture'; subtitle = 'Farmer''s Delight, Create et de bons petits plats'; group = '1A00000000000001'; order = 2; icon = 'farmersdelight:cooking_pot' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='J''ai faim !'; icon='farmersdelight:cooking_pot'
     t='&6&lÀ table !'; st='Manger varié pour vivre plus longtemps'
     d=@('Dans ce pack, la cuisine est bien plus qu''un détail : avec &eSpice of Life&r, chaque &anouvel aliment&r goûté te rapproche d''un &ccœur supplémentaire&r (jusqu''à 10 cœurs en plus).',
         '',
         '&eFarmer''s Delight&r ajoute des cultures, des outils de cuisine et des dizaines de recettes. Les addons de Create (Garnished, Bitterballen, Central Kitchen…) permettent d''en &6automatiser&r une grande partie.') }
  @{ k='knife'; x=-1.5; y=1.5; deps=@('intro'); tasks=@('farmersdelight:flint_knife'); crate='commune'
     t='Le couteau'; st='L''outil du cuisinier'
     d=@('Le &ecouteau&r coupe les aliments sur la planche à découper, récolte la paille dans les hautes herbes, et fait une arme correcte.',
         '',
         'Il existe en silex, fer, or, diamant et Netherite.') }
  @{ k='board'; x=-3; y=1.5; deps=@('knife'); tasks=@('farmersdelight:cutting_board'); crate='commune'
     t='La planche à découper'; st='Couper, trancher, émincer'
     d=@('Pose un aliment sur la &eplanche à découper&r et frappe-le avec le bon outil : couteau pour la viande et les légumes, hache pour le bois, pioche pour certains blocs…',
         '',
         'Regarde toutes ses recettes dans JEI (touche U sur la planche).') }
  @{ k='crops'; x=1.5; y=1.5; deps=@('intro'); tasks=@('farmersdelight:cabbage','farmersdelight:tomato','farmersdelight:onion','farmersdelight:rice'); crate='commune'
     t='Les nouvelles cultures'; st='Chou, tomate, oignon et riz'
     d=@('On trouve les &eplantes sauvages&r de Farmer''s Delight dans la nature : récolte-les pour obtenir des graines.',
         '',
         '- le &eriz&r se cultive &bdans l''eau&r ;',
         '- les &etomates&r poussent sur un tuteur (corde) ;',
         '- le &echou&r et l''&eoignon&r comme des cultures classiques.') }
  @{ k='richsoil'; x=3; y=1.5; deps=@('crops'); tasks=@('farmersdelight:rich_soil'); crate='commune'
     t='La Terre Riche'; st='Des cultures qui poussent toutes seules'
     d=@('Le &eCompost Organique&r posé au soleil devient de la &eTerre Riche&r. Labourée et hydratée, elle fait pousser les cultures deux fois plus vite et ne se piétine pas.') }
  @{ k='stove'; x=0; y=3; deps=@('knife','crops'); tasks=@('farmersdelight:stove'); crate='commune'
     t='Le fourneau de cuisine'; st='La base de la cuisine'
     d=@('Le &efourneau&r chauffe ce qui est posé dessus. On peut aussi y griller directement des aliments.') }
  @{ k='pot'; x=0; y=4.5; size=1.5; deps=@('stove'); tasks=@('farmersdelight:cooking_pot'); crate='rare'
     t='&6La Marmite'; st='Soupes, ragoûts et plats'
     d=@('Pose la &6Marmite&r sur une source de chaleur (fourneau, feu de camp, Brûleur à Blaze…) et mets-y les ingrédients : elle prépare soupes, ragoûts, pâtes, risottos…',
         '',
         'Il faut un &ebol&r (ou un autre contenant) pour récupérer le plat. Les plats cuisinés rassasient beaucoup et donnent souvent des &abonus&r (Réconfort, Nourrissant…).') }
  @{ k='skillet'; x=-1.5; y=4.5; deps=@('stove'); tasks=@('farmersdelight:skillet'); crate='commune'
     t='La Poêle'; st='Cuire… et assommer'
     d=@('La &ePoêle&r posée sur une source de chaleur cuit les aliments un par un. Tenue en main, elle cuit ce que tu as dans l''autre main… et fait une arme redoutable !') }
  @{ k='feast'; x=0; y=6; deps=@('pot'); tasks=@('farmersdelight:roast_chicken_block'); crate='rare'
     t='Un festin !'; st='Pour toute l''équipe'
     d=@('Les &efestins&r (poulet rôti, jambon glacé, pâté du berger…) se posent sur une table et se partagent en plusieurs portions avec un bol.',
         '',
         'Parfait pour nourrir toute l''équipe après une expédition !') }
  @{ k='fryer'; x=-3; y=6; deps=@('pot'); tasks=@('create_bic_bit:mechanical_fryer'); crate='commune'
     t='La Friteuse Mécanique'; st='Create: Bitterballen'
     d=@('&eCreate: Bitterballen&r ajoute une &eFriteuse Mécanique&r et de la cuisine néerlandaise : frites, bitterballen, stroopwafels, fromages affinés…',
         '',
         'Encore des aliments différents à goûter pour Spice of Life !') }
  @{ k='automate'; x=1.5; y=6; deps=@('pot'); tasks=@('create:blaze_burner'); crate='rare'
     t='Cuisiner avec Create'; st='Automatiser la cuisine'
     d=@('Grâce à &eCreate: Central Kitchen&r, les machines de Create savent utiliser les recettes de Farmer''s Delight :',
         '',
         '- le &eDéployeur&r avec un couteau remplace la planche à découper ;',
         '- les recettes de marmite se font dans un &ebassin&r chauffé avec un Mélangeur ;',
         '- un &eBrûleur à Blaze&r peut chauffer la marmite.',
         '',
         'Une vraie cuisine industrielle pour nourrir tout le serveur !') }
  @{ k='garnished'; x=3; y=6; deps=@('automate'); tasks=@('garnished:crushed_salt'); crate='commune'; optional=$true
     t='Create Garnished'; st='Des noix et encore des noix'
     d=@('&eGarnished&r ajoute plein de noix, de sauces et de plats à fabriquer avec Create. Il a son propre chapitre dans le groupe Create !') }
  @{ k='spice'; x=0; y=7.5; size=2; shape='hexagon'; deps=@('feast','fryer','automate'); tasks=@('@check'); checkTitle='J''ai goûté à tout !'; icon='solcarrot:food_book'; crate='epique'
     t='&c&lGastronome'; st='Spice of Life : 60 aliments'
     d=@('Ouvre ton &eLivre de Cuisine&r (Spice of Life) pour voir combien d''aliments différents tu as mangés.',
         '',
         'Rappel des paliers : &75, 10, 20, 30, 45, 60, 80, 105, 135 et 170 aliments&r, chacun donne +1 cœur.',
         '',
         'Valide cette quête quand tu as atteint &a60 aliments différents&r (+6 cœurs) !') }
  @{ k='spice2'; x=0; y=9; size=2; shape='gear'; deps=@('spice'); tasks=@('@check'); checkTitle='170 aliments !'; icon='minecraft:golden_apple'; crate='legendaire'; xp=1500
     t='&6&lGrand Chef'; st='Spice of Life : 170 aliments'
     d=@('Le défi ultime des gourmets : manger &6170 aliments différents&r pour obtenir tous les cœurs de Spice of Life.',
         '',
         'Il faudra goûter aux plats de Farmer''s Delight, de Garnished, de Bitterballen, et à la nourriture des autres dimensions (Aether, Twilight Forest…).',
         '',
         '&6&lChapeau, Grand Chef !&r') }
)
