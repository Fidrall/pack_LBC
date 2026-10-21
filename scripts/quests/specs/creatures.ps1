$Chapter = @{ file = 'creatures'; title = '&c&lBoss et créatures'; subtitle = 'Boss, monstres, dragons et compagnons'; group = '1A00000000000003'; order = 2; icon = 'mowziesmobs:wrought_helmet' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='Clique pour valider'; icon='minecraft:zombie_head'
     t='&c&lUn monde plus vivant… et plus dangereux'; st='Les créatures du pack'
     d=@('Le pack ajoute des dizaines de nouvelles créatures : certaines amicales, d''autres terrifiantes.',
         '',
         'Ce chapitre présente les &cboss&r qui ne sont pas dans l''Échelle des Boss (Mowzie''s Mobs, Illager Invasion…), et les &acréatures à découvrir et à apprivoiser&r.',
         '',
         'Toutes ces quêtes sont libres : fais-les dans l''ordre que tu veux !') }

  # --- Mowzie's Mobs (gauche)
  @{ k='mowzie'; x=-3; y=1.5; size=1.5; deps=@('intro'); tasks=@('@check'); checkTitle='Clique pour valider'; icon='mowziesmobs:sol_visage'
     t='&6Mowzie''s Mobs'; st='Des boss aux combats uniques'
     d=@('&6Mowzie''s Mobs&r ajoute des boss avec des animations et des combats très travaillés, chacun dans son propre repaire.',
         '',
         'Ils ne réapparaissent pas une fois vaincus : &asoyez tous là pour le combat !&r',
         '',
         'Sur ce serveur, ils sont renforcés (+25 % de vie, +15 % de dégâts).') }
  @{ k='wroughtnaut'; x=-4.5; y=3; deps=@('mowzie'); tasks=@('kill:mowziesmobs:ferrous_wroughtnaut'); icon='mowziesmobs:wrought_helmet'; crate='epique'
     t='&7Le Ferrous Wroughtnaut'; st='Le chevalier de fer des cavernes'
     d=@('Ce géant en armure garde une &esalle souterraine&r entourée de colonnes, dans les grottes.',
         '',
         '&n&aConseil :&r son armure est très résistante de face. &bEsquive ses coups de hache&r : quand il frappe dans le vide, il reste coincé un instant et expose son dos. C''est le moment de frapper !',
         '',
         'Il lâche sa &eHache Forgée&r et son &eCasque Forgé&r.') }
  @{ k='frostmaw'; x=-3; y=3; deps=@('mowzie'); tasks=@('kill:mowziesmobs:frostmaw'); icon='mowziesmobs:ice_crystal'; crate='epique'
     t='&b&lLe Frostmaw'; st='La bête des neiges'
     d=@('Un énorme singe des glaces qui &edort dans les biomes enneigés&r. Ne le réveille que si tu es prêt !',
         '',
         'Il souffle de la glace, bondit et fait trembler le sol. Garde tes distances pendant son souffle.',
         '',
         'Il lâche un &eCristal de Glace&r, qui permet de lancer toi-même un souffle glacé.') }
  @{ k='umvuthi'; x=-1.5; y=3; deps=@('mowzie'); tasks=@('kill:mowziesmobs:umvuthi'); icon='mowziesmobs:sol_visage'; crate='epique'
     t='&e&lUmvuthi'; st='Le seigneur du soleil'
     d=@('Dans la &esavane&r, les &eUmvuthana&r masqués vivent dans des villages fortifiés. Leur chef, &eUmvuthi&r, t''attend sur son trône.',
         '',
         'Il invoque ses guerriers et déchaîne la puissance du soleil. Élimine ses serviteurs avant de te concentrer sur lui.',
         '',
         'Il lâche le &eSol Visage&r, un masque légendaire qui permet d''invoquer la puissance du soleil. Les masques des Umvuthana peuvent aussi être portés.') }
  @{ k='sculptor'; x=-4.5; y=4.5; deps=@('wroughtnaut'); tasks=@('kill:mowziesmobs:sculptor'); icon='mowziesmobs:earthrend_gauntlet'; crate='epique'
     t='&6Le Sculpteur'; st='L''épreuve de la montagne'
     d=@('Le &6Sculpteur&r se trouve au sommet des &emontagnes&r. Pour l''atteindre, il faut relever son épreuve : grimper une colonne de pierre pendant qu''il la sculpte.',
         '',
         'Il donne le &eGantelet Fend-Terre&r et le &eBâton du Sculpteur&r, et permet d''obtenir l''armure de &eGéomancien&r.') }
  @{ k='naga'; x=-3; y=4.5; deps=@('frostmaw'); tasks=@('kill:mowziesmobs:naga'); icon='mowziesmobs:naga_fang'; crate='rare'
     t='La Naga des falaises'; st='Un serpent volant'
     d=@('Cette &eNaga&r (différente de celle de Twilight Forest) niche dans les &efalaises au bord de la mer&r et attaque en crachant du poison.',
         '',
         'Ses crocs servent à fabriquer une dague empoisonnée.') }
  @{ k='foliaath'; x=-1.5; y=4.5; deps=@('umvuthi'); tasks=@('mowziesmobs:foliaath_seed'); crate='commune'
     t='Les créatures de Mowzie''s'; st='Foliaath, Grottol, Lanternes…'
     d=@('Mowzie''s ajoute aussi des créatures plus petites :',
         '',
         '- les &2Foliaaths&r, des plantes carnivores cachées dans les jungles ;',
         '- le &bGrottol&r, une créature de cristal des grottes qui lâche des diamants (il faut une pioche pour le blesser) ;',
         '- les &eLanternes&r des forêts sombres, qui lâchent de la gelée lumineuse.',
         '',
         'Rapporte une graine de Foliaath : on peut la planter !') }

  # --- Illager Invasion (centre droite)
  @{ k='illagers'; x=3; y=1.5; size=1.5; deps=@('intro'); tasks=@('@check'); checkTitle='Clique pour valider'; icon='illagerinvasion:hallowed_gem'
     t='&4Illager Invasion'; st='Les illagers sont plus nombreux'
     d=@('&4Illager Invasion&r ajoute de nouveaux illagers : &eBasher&r (bouclier), &eProvoker&r, &eSorcier&r, &eNécromancien&r, &eInquisiteur&r, &eMarauder&r, &eAlchimiste&r, &eArchiviste&r… Ils participent aux raids et vivent dans de nouvelles structures.',
         '',
         'Combine-les avec les raids d''It Takes a Pillage, et les villages ont intérêt à être bien gardés !') }
  @{ k='invoker'; x=3; y=3; size=1.5; deps=@('illagers'); tasks=@('kill:illagerinvasion:invoker'); icon='illagerinvasion:hallowed_gem'; crate='epique'
     t='&5&lL''Invocateur'; st='Le boss des illagers'
     d=@('L''&5Invocateur&r est le chef des illagers. Il se trouve dans le &efort des illagers&r.',
         '',
         'Il se téléporte, invoque des crocs et des alliés, et se protège d''un bouclier. Frappe-le quand son bouclier tombe.',
         '',
         'Il lâche des objets rares, dont la &eGemme Sacrée&r.') }
  @{ k='imbuing'; x=3; y=4.5; deps=@('invoker'); tasks=@('illagerinvasion:imbuing_table'); crate='rare'
     t='La Table d''Imprégnation'; st='Dépasser les limites des enchantements'
     d=@('La &eTable d''Imprégnation&r permet d''&aaméliorer un livre enchanté au-delà de son niveau maximum&r, avec des matériaux rares des illagers.',
         '',
         'Regarde ses recettes dans JEI.') }
  @{ k='horn'; x=4.5; y=1.5; deps=@('illagers'); tasks=@('illagerinvasion:horn_of_sight'); crate='commune'; optional=$true
     t='Le Cor de Vision'; st='Voir à travers les murs'
     d=@('Souffler dans le &eCor de Vision&r fait briller les créatures autour de toi : parfait pour repérer les illagers cachés.') }

  # --- Friends and Foes (droite)
  @{ k='fnf'; x=7.5; y=0; size=1.5; deps=@('intro'); tasks=@('@check'); checkTitle='Clique pour valider'; icon='minecraft:copper_block'
     t='&aFriends and Foes'; st='Les créatures oubliées des votes'
     d=@('&aFriends and Foes&r ajoute les créatures des votes de Mojang qui n''ont jamais été ajoutées au jeu : golem de cuivre, Glare, Moobloom, Mauler, Iceologer, Wildfire, Rascal, Crabe, Tuff Golem…') }
  @{ k='coppergolem'; x=9; y=0; deps=@('fnf'); tasks=@('@check'); checkTitle='Golem de cuivre construit !'; crate='commune'
     t='Le Golem de Cuivre'; st='Un petit assistant'
     d=@('Construis un &eGolem de Cuivre&r (regarde la recette de sa tête dans JEI). Il appuie sur les boutons en cuivre au hasard.',
         '',
         'Comme le cuivre, il s''oxyde avec le temps… et finit par se figer !') }
  @{ k='crab'; x=9; y=1.5; deps=@('fnf'); tasks=@('friendsandfoes:crab_claw'); crate='commune'
     t='La pince de crabe'; st='Une portée plus longue'
     d=@('Les &eCrabes&r vivent sur les plages. Leur &epince&r augmente ta portée pour poser et casser des blocs : très pratique pour construire !') }
  @{ k='wildfire'; x=7.5; y=1.5; deps=@('fnf'); tasks=@('kill:friendsandfoes:wildfire'); icon='friendsandfoes:wildfire_crown'; crate='rare'
     t='Le Wildfire'; st='Le gardien des bastions'
     d=@('Le &cWildfire&r est un puissant blaze protégé par des boucliers, qui vit dans les &ebastions&r du Nether.',
         '',
         'Il lâche des fragments de sa &eCouronne de Wildfire&r, un casque qui protège du feu.') }
  @{ k='totems'; x=7.5; y=3; deps=@('wildfire'); tasks=@('friendsandfoes:totem_of_freezing','friendsandfoes:totem_of_illusion'); crate='rare'
     t='Les totems'; st='Iceologer et Illusionniste'
     d=@('L''&bIceologer&r, un illager des glaces, lâche le &eTotem de Gel&r. L''&dIllusionniste&r lâche le &eTotem d''Illusion&r.',
         '',
         'Ces totems s''activent quand tu es blessé : le premier gèle les attaquants, le second te rend invisible et crée des leurres.') }

  # --- Critters and Companions (bas)
  @{ k='critters'; x=0; y=6.5; size=1.5; deps=@('intro'); tasks=@('@check'); checkTitle='Clique pour valider'; icon='crittersandcompanions:acorn'
     t='&a&lCompagnons à apprivoiser'; st='Critters and Companions'
     d=@('&aCritters and Companions&r ajoute de petits animaux, dont beaucoup peuvent être &aapprivoisés&r :',
         '',
         '- &eFuret&r (lapin cru) : chasse les poulets et les lapins, et creuse pour trouver du butin.',
         '- &ePanda roux&r (baies sucrées) : fait fuir les monstres neutres agressifs.',
         '- &eAraignée sauteuse&r (ailes de libellule) : te protège.',
         '- &eLibellule&r (yeux d''araignée) : peut porter une armure.',
         '- &eLucane&r (baies), &eCharançon&r (glands), &eCloporte&r (champignons, peut porter un coffre), &eEscargot&r (feuilles), &eCoccinelle&r (soigne tes autres compagnons), &eShima enaga&r (graines).',
         '',
         'Valide cette quête quand tu as apprivoisé ton premier compagnon !') }
  @{ k='silk'; x=1.5; y=6.5; deps=@('critters'); tasks=@('crittersandcompanions:silk*4'); crate='commune'
     t='La soie d''araignée sauteuse'; st='Une laisse et un grappin'
     d=@('L''&earaignée sauteuse&r lâche de la &esoie&r, qui permet de fabriquer une &elaisse en soie&r et un &egrappin&r.') }
  @{ k='pearl'; x=-1.5; y=8; deps=@('critters'); tasks=@('crittersandcompanions:pearl'); crate='commune'
     t='Les perles des loutres'; st='Un collier précieux'
     d=@('Les &eloutres&r des rivières ouvrent les palourdes (qu''on pêche en rivière) pour y trouver des &eperles&r.',
         '',
         'Les perles servent à fabriquer un &ecollier de perles&r.') }
  @{ k='koi'; x=-1.5; y=6.5; deps=@('critters'); tasks=@('crittersandcompanions:koi_fish_bucket'); crate='commune'; optional=$true
     t='Un bassin de koïs'; st='Ça porte bonheur'
     d=@('Les &ecarpes koï&r vivent dans les rivières et se récupèrent dans un seau. Un groupe de koïs donne de la &achance&r aux joueurs proches.',
         '',
         'Parfait pour décorer un jardin japonais !') }
  @{ k='octopus'; x=1.5; y=8; deps=@('critters'); tasks=@('crittersandcompanions:dumbo_octopus_bucket'); crate='commune'; optional=$true
     t='La pieuvre Dumbo'; st='Une amie des profondeurs'
     d=@('La &epieuvre Dumbo&r vit dans les océans profonds. Quand tu te noies près d''elle, elle t''offre une &bbulle d''air&r !') }
  # --- Illagers : It Takes a Pillage, Guard Villagers
  @{ k='pillage_camp'; x=1.5; y=3; deps=@('illagers'); tasks=@('adv:takesapillage:adventure/pillager_camp'); crate='commune'; optional=$true
     t='Le camp des pillards'; st='It Takes a Pillage'
     d=@('&eIt Takes a Pillage&r ajoute des illagers (archers, escarmoucheurs, légionnaires), des &ecamps de pillards&r et des &ebastilles&r.') }
  @{ k='pillage_bastille'; x=1.5; y=4.5; deps=@('pillage_camp'); tasks=@('adv:takesapillage:adventure/bastille'); crate='rare'; optional=$true
     t='La bastille'; st='Une forteresse d''illagers'; d=@('Trouve une &ebastille&r, la forteresse des pillards.') }
  @{ k='guards'; x=4.5; y=3; deps=@('illagers'); tasks=@('adv:guardvillagers:adventure/recruit_guard'); crate='commune'; optional=$true
     t='Recrue !'; st='Guard Villagers'
     d=@('Donne une &eépée&r à un villageois sans métier : il devient &egarde&r et défend le village. Les gardes s''équipent de ce que tu leur donnes.') }
  # --- Born in Chaos
  @{ k='bic_root'; x=-3; y=11.5; size=1.5; shape='gear'; deps=@('intro'); hideLines=$true; tasks=@('adv:born_in_chaos_v1:bornin_chaos'); icon='born_in_chaos_v1:dark_metal_ingot'; crate='commune'
     t='&4&lBorn in Chaos'; st='Un monde plein de dangers'
     d=@('&4Born in Chaos&r ajoute des dizaines de monstres : esprits, épouvantails, clowns zombies, mouches à cadavres…',
         '',
         'Et des &cboss&r : le Missionnaire, le Suprême Appelle-os, le Seigneur Citrouille, Krampus…',
         '',
         'Le &emétal sombre&r qu''ils lâchent donne des armes et des armures puissantes.') }
  @{ k='bic_metal'; x=-4.5; y=11.5; deps=@('bic_root'); tasks=@('adv:born_in_chaos_v1:dark_metallurgy'); crate='commune'; optional=$true; icon='born_in_chaos_v1:pieceofdarkmetal'
     t='Le métal sombre'; st='Un morceau de chaos'; d=@('Récupère un &emorceau de métal sombre&r.') }
  @{ k='bic_ingot'; x=-6; y=11.5; deps=@('bic_metal'); tasks=@('adv:born_in_chaos_v1:dark_forging'); crate='commune'; optional=$true; icon='born_in_chaos_v1:dark_metal_ingot'
     t='La forge sombre'; st='Un lingot de métal sombre'; d=@('Fabrique un &elingot de métal sombre&r.') }
  @{ k='bic_knight'; x=-7.5; y=11.5; deps=@('bic_ingot'); tasks=@('adv:born_in_chaos_v1:chaos_knight'); crate='epique'; optional=$true; icon='born_in_chaos_v1:dark_metal_armor_helmet'
     t='Chevalier du chaos'; st='L''armure de métal sombre'; d=@('Porte une &earmure complète de métal sombre&r.') }
  @{ k='bic_weapon'; x=-6; y=13; deps=@('bic_ingot'); tasks=@('adv:born_in_chaos_v1:dark_blacksmith'); crate='rare'; optional=$true; icon='born_in_chaos_v1:sharpened_dark_metal_sword'
     t='Le forgeron sombre'; st='Une arme de métal sombre'; d=@('Fabrique une &earme de métal sombre&r.') }
  @{ k='bic_missioner'; x=-4.5; y=10; deps=@('bic_root'); tasks=@('adv:born_in_chaos_v1:dark_creator'); crate='rare'; optional=$true; icon='born_in_chaos_v1:missionary_hat_helmet'
     t='Le Missionnaire'; st='Un créateur de ténèbres'; d=@('Vaincs le &cMissionnaire&r.') }
  @{ k='bic_bonescaller'; x=-3; y=10; deps=@('bic_root'); tasks=@('adv:born_in_chaos_v1:dismantledto_bones'); crate='rare'; optional=$true; icon='born_in_chaos_v1:orbofthe_summoner'
     t='Le Suprême Appelle-os'; st='Un invocateur de squelettes'; d=@('Vaincs le &cSuprême Appelle-os&r.') }
  @{ k='bic_stalker'; x=-1.5; y=10; deps=@('bic_root'); tasks=@('adv:born_in_chaos_v1:fighting_nightmares'); crate='rare'; optional=$true; icon='born_in_chaos_v1:nightmare_stalker_skull'
     t='Combattre les cauchemars'; st='Le Traqueur de cauchemars'; d=@('Vaincs le &cTraqueur de cauchemars&r.') }
  @{ k='bic_pumpkin'; x=-1.5; y=11.5; deps=@('bic_root'); tasks=@('adv:born_in_chaos_v1:pumpkin_lord'); crate='epique'; optional=$true; icon='born_in_chaos_v1:lord_pumpkinheads_hat_helmet'
     t='La dernière nuit'; st='Le Seigneur Citrouille'; d=@('Vaincs le &6Seigneur Citrouille&r et sa monture.') }
  @{ k='bic_krampus'; x=-4.5; y=13; deps=@('bic_root'); tasks=@('adv:born_in_chaos_v1:wrong_santa'); crate='epique'; optional=$true; icon='born_in_chaos_v1:krampus_horn'
     t='Le mauvais Père Noël'; st='Krampus'; d=@('Fais assez de bêtises pour que &cKrampus&r vienne te chercher… puis vaincs-le.') }
  @{ k='bic_spider'; x=-3; y=13; deps=@('bic_root'); tasks=@('adv:born_in_chaos_v1:arachnophobes_nightmare'); crate='rare'; optional=$true; icon='born_in_chaos_v1:spider_mandible'
     t='Le cauchemar des arachnophobes'; st='La Mère des araignées'; d=@('Vaincs la &cMère des araignées&r.') }
  @{ k='bic_hound'; x=-1.5; y=13; deps=@('bic_root'); tasks=@('adv:born_in_chaos_v1:big_boy'); crate='rare'; optional=$true; icon='born_in_chaos_v1:fangofthe_hound_leader'
     t='Le chef de meute'; st='Le Chef des molosses'; d=@('Vaincs le &cChef des molosses&r.') }
  # --- Monstres revisites
  @{ k='mut_root'; x=3; y=9.5; deps=@('intro'); hideLines=$true; tasks=@('adv:mutantmonsters:root'); crate='commune'; optional=$true; icon='mutantmonsters:hulk_hammer'
     t='&2Les mutants'; st='Mutant Monsters'
     d=@('Zombies, squelettes, creepers et endermen &2mutants&r : rares, énormes et dangereux. Leurs restes donnent un marteau, une armure et la &ePotion de Chemical X&r.') }
  @{ k='mut_hulk'; x=4.5; y=9.5; deps=@('mut_root'); tasks=@('adv:mutantmonsters:hulk_smash'); crate='rare'; optional=$true; icon='mutantmonsters:hulk_hammer'
     t='Hulk écrase !'; st='Le marteau du mutant'; d=@('Tue un &ezombie mutant&r avec le &emarteau de Hulk&r (clic droit sur le sol : onde de choc).') }
  @{ k='mut_chem'; x=3; y=11; deps=@('mut_root'); tasks=@('adv:mutantmonsters:gunpowder_spice'); crate='rare'; optional=$true; icon='minecraft:gunpowder'
     t='Chemical X'; st='De la poudre et des épices'; d=@('Obtiens une &epotion de Chemical X&r : lancée sur un animal, elle le transforme en mutant…') }
  @{ k='rot_root'; x=6; y=9.5; deps=@('intro'); hideLines=$true; tasks=@('adv:rottencreatures:root'); crate='commune'; optional=$true; icon='minecraft:rotten_flesh'
     t='&2Pourris jusqu''à l''os'; st='Rotten Creatures'
     d=@('Des morts-vivants pour chaque biome : zombies gelés, brûlés, des marais, des marécages… et le terrible pirate &cBarbe-Morte&r.') }
  @{ k='rot_pirate'; x=7.5; y=9.5; deps=@('rot_root'); tasks=@('adv:rottencreatures:he_is_a_pirate'); crate='epique'; optional=$true; icon='rottencreatures:treasure_chest'
     t='C''est un pirate !'; st='Barbe-Morte et son trésor'; d=@('Vaincs &cBarbe-Morte&r et prends son trésor.') }
  @{ k='rot_all'; x=6; y=11; deps=@('rot_root'); tasks=@('adv:rottencreatures:kill_all_rot'); crate='rare'; optional=$true; icon='minecraft:rotten_flesh'
     t='Purification !'; st='Toutes les créatures pourries'; d=@('Tue &echaque type&r de créature pourrie.') }
  @{ k='isp_sickle'; x=3; y=13; deps=@('intro'); hideLines=$true; tasks=@('adv:infested_swarms_spiders:mantis_sickle_get'); crate='commune'; optional=$true; icon='infested_swarms_spiders:mantis_sickle'
     t='&6Essaims et araignées'; st='Infested Swarms and Spiders'
     d=@('Mantes, essaims d''abeilles, araignées de toutes sortes… Leurs restes donnent des armes (faucille de mante, poignard à dard) et des &egabarits&r pour des armures spéciales.') }
  @{ k='isp_template'; x=4.5; y=13; deps=@('isp_sickle'); tasks=@('adv:infested_swarms_spiders:insect_template_get'); crate='rare'; optional=$true; icon='infested_swarms_spiders:insect_template'
     t='Infesté !'; st='Un gabarit d''insecte'; d=@('Obtiens un &egabarit d''insecte&r pour fabriquer une armure spéciale.') }
  @{ k='isp_swarm'; x=3; y=14.5; deps=@('isp_sickle'); tasks=@('adv:infested_swarms_spiders:swarm_cell_get'); crate='rare'; optional=$true; icon='infested_swarms_spiders:swarm_cell_bee'
     t='L''essaim'; st='La cellule d''essaim'; d=@('Obtiens une &ecellule d''essaim&r.') }
  @{ k='variants'; x=6; y=13; deps=@('intro'); hideLines=$true; tasks=@('kill:variantsandventures:verdant','kill:variantsandventures:murk','kill:variantsandventures:thicket','kill:variantsandventures:gelid'); crate='rare'; optional=$true; icon='minecraft:skeleton_skull'
     t='&aUn bestiaire varié'; st='Variantes de biome'
     d=@('Dans ce pack, les monstres changent selon le biome :',
         '',
         '- &eVariants and Ventures&r : squelettes des jungles et des marais, zombies gelés…',
         '- &eEnderman Overhaul&r : une vingtaine d''endermen différents selon les biomes, avec leurs perles spéciales ;',
         '- &eCreeper Overhaul&r : un creeper différent pour chaque biome.',
         '',
         'Tue les quatre nouveaux monstres de Variants and Ventures : &everdant, vaseux, des fourrés et gelé&r.') }
  # --- Dragons (Wyrmroost)
  @{ k='wr_platinum'; x=11.5; y=0; deps=@('intro'); hideLines=$true; tasks=@('createpropulsion:platinum_ingot'); crate='commune'; optional=$true
     t='&c&lLes dragons de Wyrmroost'; st='Wyrmroost'
     d=@('&cWyrmroost&r peuple le monde de &cdragons&r, des petits drakes aux immenses wyvernes. Certains s''apprivoisent !',
         '',
         'Commence par le &eplatine&r (le même que celui de Create Propulsion) et les &egéodes&r, pour l''équipement de dragonnier.') }
  @{ k='wr_geode'; x=13; y=0; deps=@('wr_platinum'); tasks=@('wyrmroost:blue_geode'); crate='commune'; optional=$true
     t='Les géodes'; st='Bleues, rouges et violettes'; d=@('Les &egéodes&r se minent dans les montagnes et le Nether. Elles donnent outils, armes et armures.') }
  @{ k='wr_staff'; x=14.5; y=0; deps=@('wr_geode'); tasks=@('wyrmroost:dragon_staff'); crate='rare'; optional=$true
     t='Le bâton de dragonnier'; st='Commander ses dragons'; d=@('Le &ebâton de dragon&r donne des ordres à tes dragons apprivoisés.') }
  @{ k='wr_armor'; x=11.5; y=1.5; deps=@('wr_platinum'); tasks=@('wyrmroost:iron_dragon_armor'); crate='rare'; optional=$true
     t='Une armure pour dragon'; st='Protéger sa monture'; d=@('Une &earmure&r pour ton dragon, en fer, or, diamant, platine ou géode.') }
  @{ k='wr_drake'; x=13; y=1.5; deps=@('wr_armor'); tasks=@('wyrmroost:drake_chestplate'); crate='rare'; optional=$true
     t='L''armure de drake'; st='En écailles de dragon'; d=@('Une armure faite avec les écailles d''un &edrake&r.') }
  # --- Compagnons (Doggy Talents Next, Redomesticate, Petting)
  @{ k='dog_train'; x=11.5; y=3.5; deps=@('intro'); hideLines=$true; tasks=@('adv:doggytalents:dtn_core/train_dog'); crate='commune'; optional=$true; icon='doggytalents:training_treat'
     t='&6Les chiens de compagnie'; st='Doggy Talents Next'
     d=@('Donne une &efriandise de dressage&r à un loup apprivoisé : il devient un &echien&r qui apprend des &etalents&r (gardien, pêcheur, porteur, sauveteur…), qui a de la vie et qui peut s''équiper.') }
  @{ k='dog_summon'; x=13; y=3.5; deps=@('dog_train'); tasks=@('adv:doggytalents:dtn_core/summon_dog'); crate='commune'; optional=$true; icon='doggytalents:doggy_charm'
     t='Le charme canin'; st='Appeler son chien'; d=@('Utilise le &echarme canin&r pour faire venir ton chien.') }
  @{ k='dog_heal'; x=11.5; y=5; deps=@('dog_train'); tasks=@('adv:doggytalents:default/dog_recovered'); crate='commune'; optional=$true; icon='minecraft:golden_apple'
     t='Une guérison complète !'; st='Soigner son chien'; d=@('Un chien gravement blessé ne meurt pas : il reste à terre. Aide-le à &eguérir&r.') }
  @{ k='pet_bed'; x=15; y=3.5; deps=@('intro'); hideLines=$true; tasks=@('redomesticate:pet_bed_red'); crate='commune'; optional=$true
     t='&eLes animaux domestiques'; st='Redomesticate et Petting'
     d=@('Tous tes animaux apprivoisés gagnent des options :',
         '',
         '- &eRedomesticate&r : lits, tambour de commandement, collier, titre de propriété pour les donner à un autre joueur ;',
         '- &ePetting&r : certaines créatures sauvages s''apprivoisent avec une &efriandise dorée&r une fois affaiblies (moitié de leur vie). Clic droit pour assis/debout, &e²&r pour l''inventaire du familier, &eAlt+R&r pour le monter (selle obligatoire).') }
  @{ k='pet_drum'; x=16.5; y=3.5; deps=@('pet_bed'); tasks=@('redomesticate:drum'); crate='commune'; optional=$true
     t='Le tambour de commandement'; st='Donner des ordres à tous tes animaux'; d=@('Le &etambour&r donne un ordre (suivre, rester, se promener) à tous tes animaux autour de toi.') }
  @{ k='pet_whistle'; x=15; y=5; deps=@('pet_bed'); tasks=@('petting:collar'); crate='commune'; optional=$true
     t='Le collier'; st='Régler son familier'; d=@('Le &ecollier&r (cuir, teinture, pépite d''or) se met à un familier Petting : mode de combat (passif, défensif, agressif, errance, garde), distance de suivi, téléportation.',
         '',
         'Clic droit sur un lit avec le collier pour le lier : le familier qui le porte y réapparaît à sa mort.') }
)
