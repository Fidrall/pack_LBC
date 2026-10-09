$Chapter = @{ file = 'apotheosis'; title = '&5&lApotheosis'; subtitle = 'Butin RPG, gemmes et enchantement avancé'; group = '1A00000000000004'; order = 2; icon = 'apotheosis:gem' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='Clique pour valider'; icon='apotheosis:gem'
     t='&5&lLe butin façon RPG'; st='Raretés, affixes et gemmes'
     d=@('Avec &5Apotheosis&r, l''équipement que tu trouves peut avoir une &erareté&r : &7Commun&r, &aPeu commun&r, &9Rare&r, &5Épique&r ou &6Mythique&r.',
         '',
         'Chaque rareté ajoute des &aaffixes&r (bonus de statistiques) et des &bemplacements de gemmes&r. Les objets Mythiques ont même une capacité unique.',
         '',
         'Où trouver ce butin ? Dans les &ecoffres des structures&r, et surtout sur les &cmonstres élites&r et les &cboss d''Apotheosis&r, qui apparaissent de temps en temps dans le monde (ils brillent et sont annoncés).') }
  @{ k='tiers'; x=-2; y=0; deps=@('intro'); tasks=@('@check'); checkTitle='Compris !'; icon='minecraft:nether_star'
     t='Les Niveaux du Monde'; st='Ctrl + T'
     d=@('Apotheosis a des &6Niveaux du Monde&r : Havre, Frontière, Ascension, Sommet et Apogée. Ouvre le menu avec &aCtrl + T&r.',
         '',
         'Tu débloques les niveaux supérieurs de deux façons : en portant un équipement complet (casque, plastron, jambières, bottes et arme) d''une certaine rareté, ou en terminant les &equêtes de palier&r juste à gauche.',
         '',
         'Débloquer un niveau ne l''active pas : c''est toi qui choisis quand monter, dans le menu &aCtrl + T&r. Et tu peux &aredescendre&r à tout moment vers un niveau déjà débloqué.',
         '',
         'Plus le niveau est élevé, plus les monstres sont dangereux… et meilleur est le butin. &cChaque joueur choisit son niveau&r : mettez-vous d''accord en équipe avant de monter !') }
  # --- Echelle des niveaux du monde : debloque (succes Apotheosis) sans activer
  @{ k='tier_frontier'; x=-4.5; y=0; deps=@('tiers'); tasks=@('dim:minecraft:the_nether'); icon='minecraft:netherrack'; grantAdv=@('apotheosis:progression/frontier'); crate='commune'
     t='&aNiveau : Frontière'; st='Entrer dans le Nether'
     d=@('Ton premier pas dans le Nether prouve que tu es prêt à affronter un monde plus dangereux.',
         '',
         'Récompense : le niveau &aFrontière&r est &edébloqué&r. Active-le quand tu veux avec &aCtrl + T&r.',
         '',
         'À partir de ce niveau, des &cEnvahisseurs&r (mini-boss d''Apotheosis) peuvent apparaître.') }
  @{ k='tier_boss_naga'; x=-6; y=1.5; deps=@('tier_frontier'); tasks=@('kill:twilightforest:naga'); size=0.75; optional=$true
     t='Vaincre la Naga'; st='Un des premiers boss' }
  @{ k='tier_boss_deadking'; x=-6; y=2.25; deps=@('tier_frontier'); tasks=@('kill:mowziesmobs:ferrous_wroughtnaut'); size=0.75; optional=$true
     t='Vaincre le Wroughtnaut'; st='Un des premiers boss' }
  @{ k='tier_boss_elder'; x=-6; y=3; deps=@('tier_frontier'); tasks=@('kill:minecraft:elder_guardian'); size=0.75; optional=$true
     t='Vaincre un Gardien Ancien'; st='Un des premiers boss' }
  @{ k='tier_ascent'; x=-4.5; y=2.25; deps=@('tier_boss_naga','tier_boss_deadking','tier_boss_elder'); minDeps=1; tasks=@('@check'); checkTitle='Débloquer Ascension'; icon='minecraft:iron_sword'; grantAdv=@('apotheosis:progression/ascent'); crate='rare'
     t='&9Niveau : Ascension'; st='Vaincre un premier boss'
     d=@('Tu as vaincu un premier boss (la &eNaga&r, le &eWroughtnaut&r ou un &eGardien Ancien&r) : tu es prêt pour l''étape suivante.',
         '',
         'Récompense : le niveau &9Ascension&r est &edébloqué&r. Active-le quand tu veux avec &aCtrl + T&r.') }
  @{ k='tier_summit'; x=-4.5; y=3.75; deps=@('tier_ascent'); tasks=@('kill:minecraft:wither'); icon='minecraft:wither_skeleton_skull'; grantAdv=@('apotheosis:progression/summit'); crate='epique'
     t='&5Niveau : Sommet'; st='Vaincre le Wither'
     d=@('Le Wither est tombé. Le monde va devenir bien plus hostile… si tu le décides.',
         '',
         'Récompense : le niveau &5Sommet&r est &edébloqué&r. Active-le quand tu veux avec &aCtrl + T&r.') }
  @{ k='tier_pinnacle'; x=-4.5; y=5.25; size=1.5; deps=@('tier_summit'); tasks=@('kill:minecraft:ender_dragon'); icon='minecraft:dragon_head'; grantAdv=@('apotheosis:progression/pinnacle'); crate='legendaire'
     t='&6&lNiveau : Apogée'; st='Vaincre l''Ender Dragon'
     d=@('La fin de toutes choses… ou le vrai début. Le niveau &6Apogée&r est le plus dangereux, avec le meilleur butin.',
         '',
         'Récompense : le niveau &6Apogée&r est &edébloqué&r, mais &cpas activé&r. Monte quand toute l''équipe est prête, avec &aCtrl + T&r. Tu peux toujours redescendre.') }
  @{ k='salvage'; x=0; y=1.5; deps=@('intro'); tasks=@('apotheosis:salvaging_table'); crate='commune'
     t='La Table de Récupération'; st='Recycler l''équipement inutile'
     d=@('Elle démonte les objets à affixes et les gemmes pour récupérer des &ematériaux de rareté&r (ferraille mystérieuse, tissu usé, éclats de cristal lumineux…) et de la &epoudre de gemme&r.',
         '',
         'Ne jette plus jamais un objet à affixes : recycle-le !') }
  @{ k='gem'; x=-1.5; y=3; deps=@('salvage'); tasks=@('apotheosis:gem'); crate='commune'
     t='&bTa première gemme'; st='Des bonus à insérer'
     d=@('Les &bgemmes&r se trouvent sur les monstres et dans les coffres. Chaque type donne des bonus différents selon l''objet où on l''insère.',
         '',
         'Insère-les sur la &eTable de Forgeron&r, dans un objet qui a un emplacement libre.') }
  @{ k='cutting'; x=-3; y=3; deps=@('gem'); tasks=@('apotheosis:gem_cutting_table'); crate='rare'
     t='La Table de Taille de Gemmes'; st='Améliorer ses gemmes'
     d=@('Combine deux gemmes identiques (et de la poudre de gemme) pour monter leur &erareté&r et leurs bonus.') }
  @{ k='sigils'; x=-1.5; y=4.5; deps=@('gem'); tasks=@('apotheosis:sigil_of_socketing'); crate='rare'
     t='Les Sceaux'; st='Emplacements, retrait et plus'
     d=@('Les &eSceaux&r servent à modifier l''équipement sur la table de forgeron :',
         '',
         '- &eSceau d''Emplacement&r : ajoute un emplacement de gemme ;',
         '- &eSceau de Retrait&r : retire les gemmes sans les détruire ;',
         '- &eSceau d''Amélioration&r, de &eSuprématie&r, de &eRenaissance&r… pour les objets les plus avancés.',
         '',
         'Les sceaux rares se trouvent dans les &5caisses épiques et légendaires&r du livre de quêtes !') }
  @{ k='reforge'; x=1.5; y=3; deps=@('salvage'); tasks=@('apotheosis:simple_reforging_table'); crate='rare'
     t='La Table de Reforge'; st='Monter la rareté'
     d=@('La &eTable de Reforge Simple&r relance les affixes et monte la rareté d''un objet jusqu''à &9Rare&r, avec des matériaux de rareté et de la poudre de gemme.',
         '',
         'La &eTable de Reforge&r avancée va jusqu''à &5Épique&r et &6Mythique&r.') }
  @{ k='reforge2'; x=3; y=3; deps=@('reforge'); tasks=@('apotheosis:reforging_table'); crate='epique'
     t='La Table de Reforge avancée'; st='Vers le mythique'
     d=@('Transforme ton meilleur équipement en objet &6Mythique&r, avec une capacité unique !') }
  @{ k='augment'; x=1.5; y=4.5; deps=@('reforge'); tasks=@('apotheosis:augmenting_table'); crate='rare'
     t='La Table d''Augmentation'; st='Optimiser ses affixes'
     d=@('Elle permet de &arelancer un affixe précis&r ou d''&amaximiser ses valeurs&r. Parfait pour peaufiner ton équipement final.') }
  # --- Enchantement
  @{ k='enchtable'; x=0; y=6; size=1.5; deps=@('salvage'); tasks=@('minecraft:enchanting_table'); crate='commune'
     t='&dL''enchantement d''Apotheosis'; st='Eterna, Quanta et Arcana'
     d=@('La table d''enchantement fonctionne différemment : les &ebibliothèques&r autour d''elle donnent trois statistiques.',
         '',
         '- &aEterna&r : le niveau maximum des enchantements ;',
         '- &cQuanta&r : la part de hasard (plus de puissance, mais moins prévisible) ;',
         '- &dArcana&r : la chance d''obtenir des enchantements rares et multiples.',
         '',
         'Chaque type de bibliothèque change ces statistiques. Survole-les pour voir leurs bonus.',
         '',
         '&7Tu peux aussi enchanter avec les machines de Create: Enchantment Industry : à toi de choisir !') }
  @{ k='hellshelf'; x=-1.5; y=7.5; deps=@('enchtable'); tasks=@('apothic_enchanting:hellshelf'); crate='commune'
     t='La Bibliothèque Infernale'; st='Plus de puissance'
     d=@('Faite avec des matériaux du Nether, elle augmente fortement l''&aEterna&r et la &cQuanta&r.') }
  @{ k='seashelf'; x=0; y=7.5; deps=@('enchtable'); tasks=@('apothic_enchanting:seashelf'); crate='commune'
     t='La Bibliothèque Marine'; st='Plus de variété'
     d=@('Faite avec des matériaux de l''océan, elle augmente l''&aEterna&r et l''&dArcana&r.') }
  @{ k='deepshelf'; x=1.5; y=7.5; deps=@('enchtable'); tasks=@('apothic_enchanting:deepshelf'); crate='rare'
     t='La Bibliothèque des Abysses'; st='Les enchantements les plus hauts'
     d=@('Faite avec des matériaux des Abîmes (et plus tard du sculk), elle permet d''atteindre les niveaux d''enchantement les plus élevés.') }
  @{ k='endshelf'; x=0; y=9; deps=@('hellshelf','seashelf','deepshelf'); tasks=@('apothic_enchanting:endshelf'); crate='rare'
     t='La Bibliothèque de l''End'; st='Le sommet'
     d=@('Les bibliothèques de l''End et leurs versions draconiques permettent d''atteindre le niveau d''enchantement maximum. Combine-les pour obtenir la table parfaite !') }
  @{ k='library'; x=-3; y=7.5; deps=@('hellshelf'); tasks=@('apothic_enchanting:library'); crate='rare'
     t='La Bibliothèque d''Enchantements'; st='Stocker tous tes livres'
     d=@('Elle absorbe tes livres enchantés et les stocke sous forme de points. Tu peux ensuite en ressortir n''importe quel enchantement au niveau voulu, et les combiner sans coût.',
         '',
         'La &eBibliothèque de l''Ender&r stocke des enchantements de plus haut niveau.') }
  @{ k='tomes'; x=3; y=7.5; deps=@('deepshelf'); tasks=@('apothic_enchanting:weapon_tome'); crate='commune'
     t='Les Tomes'; st='Des livres spécialisés'
     d=@('Les &eTomes&r (d''arme, de casque, d''arc…) s''enchantent comme un objet de ce type, puis se transforment en livre enchanté. Pratique pour viser les enchantements d''un type d''objet précis.') }
  @{ k='breath'; x=-3; y=9; deps=@('library'); tasks=@('apothic_enchanting:infused_breath'); crate='rare'; optional=$true
     t='Le Souffle Infusé'; st='L''infusion d''objets'
     d=@('Certaines recettes d''Apotheosis se font en &eenchantant un objet&r au lieu de le fabriquer : l''&einfusion&r. Le Souffle Infusé en est un exemple.',
         '',
         'Regarde les recettes d''infusion dans JEI.') }
  # --- Générateurs
  @{ k='spawner'; x=4.5; y=1.5; deps=@('intro'); tasks=@('minecraft:spawner'); crate='rare'
     t='&6Les générateurs de monstres'; st='Des fermes sur mesure'
     d=@('Avec une pioche &eToucher de soie&r, tu peux &arécupérer les générateurs de monstres&r trouvés dans les donjons.',
         '',
         'Ils peuvent ensuite être &eaméliorés&r : plus rapides, plus de monstres, fonctionnement sans joueur à proximité ou sans lumière… Regarde les objets d''amélioration (runes) dans JEI.',
         '',
         'Parfait pour une ferme à XP ou à butin. &7Attention à ne pas surcharger le serveur avec trop de monstres !&r') }
  @{ k='rune'; x=4.5; y=3; deps=@('spawner'); tasks=@('apotheosis:spawner_rune'); crate='commune'
     t='Les runes de générateur'; st='Améliorer un générateur'
     d=@('Les &erunes&r s''appliquent sur un générateur pour modifier son comportement. Chaque rune a son effet : délai, portée, nombre de monstres, silence…') }
  @{ k='final'; x=0; y=10.5; size=2.5; shape='gear'; deps=@('reforge2','augment','endshelf','sigils'); tasks=@('@check'); checkTitle='Mon équipement est mythique'; icon='apotheosis:sigil_of_supremacy'; crate='legendaire'; xp=1500
     t='&6&lÉquipement légendaire'; st='L''objectif final du chapitre'
     d=@('Obtiens (ou forge) une &6pièce d''équipement Mythique&r, avec ses gemmes et ses enchantements au maximum.',
         '',
         'Valide la quête quand tu as ton équipement parfait. &6&lTu es une légende !&r') }
)
