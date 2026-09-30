$Chapter = @{ file = 'twilight_forest'; title = '&2&lLa Forêt du Crépuscule'; subtitle = 'Twilight Forest : une dimension de contes et de boss'; group = '1A00000000000005'; order = 0; icon = 'twilightforest:naga_trophy' }
$Quests = @(
  @{ k='portal'; x=0; y=0; size=2; shape='gear'; tasks=@('adv:twilightforest:root'); icon='minecraft:diamond'; crate='rare'
     t='&2&lEntrer dans la Forêt du Crépuscule'; st='Un diamant, de l''eau et des fleurs'
     d=@('La &2Forêt du Crépuscule&r est une dimension pleine de biomes, de créatures et d''une longue série de &cboss&r à vaincre dans l''ordre.',
         '',
         '&n&aConstruire le portail :&r',
         '1) Creuse un bassin de &b2×2&r (ou plus grand) et remplis-le d''eau.',
         '2) Entoure-le de &efleurs ou de plantes&r (herbe haute, fleurs…) sur tous les côtés.',
         '3) Jette un &bdiamant&r dans l''eau : la foudre frappe et le portail s''ouvre !',
         '',
         '&cLa dimension est verrouillée par étapes :&r certains biomes sont protégés tant que tu n''as pas vaincu le boss précédent (brouillard, malédictions, froid…). Suis la progression de ce chapitre.',
         '',
         '&7Les boss sont renforcés sur ce serveur : venez à plusieurs !') }
  @{ k='magicmap'; x=-2; y=0; deps=@('portal'); tasks=@('twilightforest:magic_map_focus'); crate='commune'
     t='La Carte Magique'; st='Ne pas se perdre'
     d=@('Autour des &epiliers d''obsidienne&r vivent des &ecorbeaux&r : leurs plumes servent à fabriquer un &eFocus de Carte Magique&r, avec des baies-torches et de la pierre lumineuse.',
         '',
         'Le focus permet de fabriquer une &eCarte Magique&r, qui montre les biomes et les structures importantes autour de toi. Indispensable pour trouver les boss !') }
  @{ k='cicada'; x=-3.5; y=0; deps=@('magicmap'); tasks=@('adv:twilightforest:kill_cicada'); crate='commune'; optional=$true
     t='Le silence de la forêt'; st='Ces cigales sont insupportables'
     d=@('Les &ecigales&r de la Forêt du Crépuscule font un bruit épouvantable.',
         '',
         'Rends service à tout le monde : tues-en une.') }
  @{ k='naga'; x=0; y=2; size=1.5; deps=@('portal'); tasks=@('adv:twilightforest:progress_naga'); icon='twilightforest:naga_trophy'; crate='rare'
     t='&2Le Naga'; st='Boss 1 : la Cour du Naga'
     d=@('Le &2Naga&r est un grand serpent vert qui vit dans une &ecour entourée de haies&r, près du centre de la forêt.',
         '',
         '&n&aConseils :&r il charge en ligne droite et se protège en s''enroulant. Esquive ses charges (la roulade aide beaucoup !) et frappe-le quand il ralentit. Il perd des segments en prenant des dégâts.',
         '',
         'Ses &eÉcailles de Naga&r servent à fabriquer une armure.') }
  @{ k='nagaarmor'; x=1.5; y=2; deps=@('naga'); tasks=@('twilightforest:naga_chestplate','twilightforest:naga_leggings'); crate='commune'
     t='L''armure de Naga'; st='Faite d''écailles'
     d=@('Avec les écailles du Naga, fabrique un plastron et des jambières. Pas la meilleure armure, mais elle a du style et arrive déjà enchantée.') }
  @{ k='lich'; x=0; y=3.5; size=1.5; deps=@('naga'); tasks=@('adv:twilightforest:progress_lich'); icon='twilightforest:lich_trophy'; crate='rare'
     t='&5La Liche'; st='Boss 2 : la Tour de la Liche'
     d=@('La &5Liche&r t''attend au sommet de sa &etour&r.',
         '',
         '&n&aTrois phases :&r',
         '1) Protégée par des boucliers, elle lance des boules d''énergie : &brenvoie-les avec ton arme&r pour briser ses boucliers.',
         '2) Elle invoque des morts-vivants.',
         '3) Elle finit au corps à corps, en envoyant des sorts.',
         '',
         'Elle donne des &esceptres&r magiques très utiles.') }
  @{ k='scepters'; x=1.5; y=3.5; deps=@('lich'); tasks=@('adv:twilightforest:lich_scepters'); crate='commune'
     t='Les sceptres de la Liche'; st='De la magie à portée de main'
     d=@('&eSceptre du Crépuscule&r (boules d''énergie, se recharge avec des perles de l''Ender), &eSceptre de Vol de Vie&r (yeux d''araignée fermentés), &eSceptre Zombie&r (chair putréfiée), &eSceptre de Fortification&r (pommes dorées).',
         '',
         'Pour les recharger, combine-les avec leur ingrédient dans la table de fabrication.') }
  @{ k='minoshroom'; x=-1.5; y=5; size=1.5; deps=@('lich'); tasks=@('adv:twilightforest:progress_labyrinth'); icon='twilightforest:minoshroom_trophy'; crate='rare'
     t='&6Le Minoshroom'; st='Boss 3 : le Labyrinthe du Marais'
     d=@('Dans les &emarais&r, cherche une colline avec une entrée au sommet : c''est le &eLabyrinthe&r.',
         '',
         'Au fond t''attend le &6Minoshroom&r, qui charge et frappe fort. Il lâche du &eMeef Stroganoff&r : &amange-le&r pour débloquer la suite !',
         '',
         '&7Le marais empoisonne tant que tu n''as pas vaincu la Liche : prévois du lait ou une potion.') }
  @{ k='mazebreaker'; x=-3; y=5; deps=@('minoshroom'); tasks=@('twilightforest:mazebreaker_pickaxe'); crate='commune'; optional=$true
     t='La Pioche Brise-Labyrinthe'; st='Une trouvaille rare'
     d=@('Cette pioche, trouvée rarement dans les labyrinthes, casse les murs du labyrinthe sans s''abîmer (les autres pioches perdent 16 points de durabilité par bloc).') }
  @{ k='hydra'; x=-1.5; y=6.5; size=1.5; deps=@('minoshroom'); tasks=@('adv:twilightforest:progress_hydra'); icon='twilightforest:hydra_trophy'; crate='epique'
     t='&c&lL''Hydre'; st='Boss 4 : le Marais de Feu'
     d=@('L''&cHydre&r à plusieurs têtes vit dans le &eMarais de Feu&r, entre lave et feu.',
         '',
         '&n&aConseils :&r ses têtes crachent du feu et mordent. Frappe les têtes quand elles s''approchent : les attaques à distance sont peu efficaces. Une &eprotection contre le feu&r est indispensable.',
         '',
         'Elle lâche du &eSang Ardent&r pour fabriquer des outils et une armure ardents.') }
  @{ k='fiery'; x=-3; y=6.5; deps=@('hydra'); tasks=@('twilightforest:fiery_ingot*4'); crate='rare'
     t='L''équipement ardent'; st='Forgé dans le sang de l''Hydre'
     d=@('Avec le Sang Ardent et du fer, fabrique des &eLingots Ardents&r.',
         '',
         '- L''&eÉpée Ardente&r a Aura de feu II.',
         '- La &ePioche Ardente&r fait fondre les minerais.',
         '- L''&earmure ardente&r complète met le feu à ceux qui t''attaquent.') }
  @{ k='knights'; x=1.5; y=5; size=1.5; deps=@('lich'); tasks=@('adv:twilightforest:progress_knights'); icon='twilightforest:knight_phantom_trophy'; crate='epique'
     t='&8Les Chevaliers Fantômes'; st='Boss 5 : la Forêt Obscure'
     d=@('Dans la &8Forêt Obscure&r, une structure mène sous terre : le &eTombeau des Chevaliers&r.',
         '',
         'Pour y entrer, pose l''un des &etrophées de boss&r déjà obtenus sur le piédestal à proximité.',
         '',
         'À l''intérieur, affronte une &8troupe de Chevaliers Fantômes&r qui attaquent ensemble. Leurs coffres contiennent du &eMétal de Chevalier&r.') }
  @{ k='knightmetal'; x=3; y=5; deps=@('knights'); tasks=@('twilightforest:knightmetal_ingot*4'); crate='rare'
     t='Le Métal de Chevalier'; st='Un équipement solide'
     d=@('Le &eMétal de Chevalier&r permet de fabriquer une armure et des outils solides, ainsi que le redoutable &eBloc et Chaîne&r (un fléau).',
         '',
         'Les coffres des chevaliers contiennent parfois une &earmure fantôme&r.') }
  @{ k='urghast'; x=1.5; y=6.5; size=1.5; deps=@('knights'); tasks=@('adv:twilightforest:progress_ur_ghast'); icon='twilightforest:ur_ghast_trophy'; crate='epique'
     t='&4L''Ur-Ghast'; st='Boss 6 : la Tour Obscure'
     d=@('Dans la Forêt Obscure se dresse la &4Tour Obscure&r. Entre par les &eblocs réapparaissants&r à sa base, et monte jusqu''au dernier étage.',
         '',
         'L''&4Ur-Ghast&r, un ghast géant, t''y attend. Il pleure des &cLarmes de Feu&r.',
         '',
         '&n&aConseil :&r utilise les &epièges à ghast&r de la salle pour le ramener au sol et le rendre vulnérable.') }
  @{ k='yeti'; x=0; y=8; size=1.5; deps=@('urghast','hydra'); tasks=@('adv:twilightforest:progress_yeti'); icon='twilightforest:alpha_yeti_trophy'; crate='epique'
     t='&f&lLe Yéti Alpha'; st='Boss 7 : les Forêts Enneigées'
     d=@('Après l''Ur-Ghast, les &fForêts Enneigées&r s''ouvrent. Le froid y est mortel tant que le boss n''est pas vaincu !',
         '',
         'Le &fYéti Alpha&r vit dans une grotte de glace. Il lance des blocs de glace et attrape les joueurs : &ereste mobile&r et esquive.',
         '',
         'Sa fourrure permet de fabriquer une &earmure de yéti&r, et les petits yétis et loups d''hiver donnent la &efourrure arctique&r.') }
  @{ k='snowqueen'; x=0; y=9.5; size=1.5; deps=@('yeti'); tasks=@('adv:twilightforest:progress_glacier'); icon='twilightforest:snow_queen_trophy'; crate='epique'
     t='&b&lLa Reine des Neiges'; st='Boss 8 : le Palais de l''Aurore'
     d=@('Après le Yéti, le &bGlacier&r s''ouvre (avec ses manchots !). Au sommet du &ePalais de l''Aurore&r t''attend la &bReine des Neiges&r.',
         '',
         'Elle s''entoure de &ecristaux de glace&r qui la protègent : détruis-les, puis frappe-la quand elle descend.',
         '',
         'Elle lâche l''&eArc Triple&r ou l''&eArc Chercheur&r, et les coffres du palais cachent l''&eÉpée de Verre&r et l''&eArc de l''Ender&r.') }
  @{ k='trolls'; x=0; y=11; size=1.5; deps=@('snowqueen'); tasks=@('adv:twilightforest:progress_troll'); icon='twilightforest:lamp_of_cinders'; crate='epique'
     t='&6Les Hautes Terres et la Lampe de Cendres'; st='Étape 9 : les grottes des trolls'
     d=@('Dans les &6Hautes Terres&r, les &etrolls&r des grottes lâchent des &eHaricots Magiques&r, et leurs coffres donnent de la &eTerre Fertile&r.',
         '',
         'Plante les haricots dans la terre fertile sous un grand nuage : un &eharicot géant&r pousse jusqu''au royaume des &eGéants&r, qui gardent la &ePioche de Géant&r.',
         '',
         'Avec elle, casse l''&eObsidienne Géante&r dans les grottes des trolls pour trouver la &6Lampe de Cendres&r.') }
  @{ k='giants'; x=1.5; y=11; deps=@('trolls'); tasks=@('twilightforest:giant_pickaxe'); crate='rare'
     t='Le royaume des Géants'; st='Au sommet du haricot'
     d=@('Les Géants ressemblent à des joueurs… en beaucoup, beaucoup plus grands.',
         '',
         'Leurs outils géants cassent et construisent des blocs en 3×3×3 !') }
  @{ k='castle'; x=0; y=12.5; size=2.5; shape='gear'; deps=@('trolls'); tasks=@('adv:twilightforest:progression_end'); icon='twilightforest:violet_castle_door'; crate='legendaire'; xp=2000
     t='&6&lLe Château Final'; st='Au bout du voyage'
     d=@('Avec la &6Lampe de Cendres&r, brûle les &eronces&r des &eTerres Épineuses&r pour ouvrir le chemin.',
         '',
         'Au-delà se trouve le &6Plateau Final&r et son immense &echâteau&r, le terme de ton voyage dans la Forêt du Crépuscule.',
         '',
         '&6&lTu as conquis la Forêt du Crépuscule !&r') }
  @{ k='charms'; x=3.5; y=2; deps=@('portal'); tasks=@('twilightforest:charm_of_life_1'); crate='commune'
     t='Les breloques'; st='Pour ne pas tout perdre'
     d=@('Les &eBreloques de Vie&r empêchent une mort (elles sont consommées à la place), et les &eBreloques de Protection&r gardent une partie de ton inventaire à la mort.',
         '',
         'On les trouve dans les coffres de la forêt, et elles s''améliorent en en combinant plusieurs.') }
  @{ k='steeleaf'; x=3.5; y=3.5; deps=@('charms'); tasks=@('twilightforest:steeleaf_ingot*4','twilightforest:ironwood_ingot*4'); crate='commune'
     t='Feuille-d''Acier et Bois-de-Fer'; st='Les matériaux de la forêt'
     d=@('La &eFeuille-d''Acier&r se trouve dans les collines creuses et les coffres ; le &eBois-de-Fer&r se fabrique avec des racines de liane, du fer et de l''or.',
         '',
         'Leurs armures et outils arrivent &adéjà enchantés&r : parfaits en début de progression.') }
  @{ k='questram'; x=-3.5; y=2; deps=@('portal'); tasks=@('adv:twilightforest:quest_ram'); crate='rare'; optional=$true
     t='Le Bélier des Quêtes'; st='Un arc-en-ciel de laine'
     d=@('Trouve le &eBélier des Quêtes&r dans ses ruines, et apporte-lui de la laine des &e16 couleurs&r.',
         '',
         'Il récompense généreusement ceux qui l''aident. Indice : regarde au-dessus de ta tête dans les ruines.') }
  @{ k='trees'; x=3.5; y=6.5; deps=@('knights'); tasks=@('twilightforest:time_sapling','twilightforest:transformation_sapling','twilightforest:mining_sapling','twilightforest:sorting_sapling'); crate='epique'; optional=$true
     t='Les arbres magiques'; st='Quatre pousses rarissimes'
     d=@('Les coffres de la forêt cachent parfois des &epousses magiques&r :',
         '',
         '- l''&eArbre du Temps&r accélère ce qui pousse autour de lui ;',
         '- l''&eArbre de Transformation&r change les biomes en biomes de la forêt ;',
         '- l''&eArbre Mineur&r ramène des minerais ;',
         '- l''&eArbre de Tri&r range les objets dans les coffres proches.',
         '',
         'Réunis les quatre !') }
)
