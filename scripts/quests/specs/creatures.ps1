$Chapter = @{ file = 'creatures'; title = '&c&lBoss et créatures'; subtitle = 'Mowzie''s, Illager Invasion, Friends and Foes, Critters'; group = '1A00000000000003'; order = 2; icon = 'mowziesmobs:wrought_helmet' }
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
  @{ k='imbuing'; x=4.5; y=3; deps=@('invoker'); tasks=@('illagerinvasion:imbuing_table'); crate='rare'
     t='La Table d''Imprégnation'; st='Dépasser les limites des enchantements'
     d=@('La &eTable d''Imprégnation&r permet d''&aaméliorer un livre enchanté au-delà de son niveau maximum&r, avec des matériaux rares des illagers.',
         '',
         'Regarde ses recettes dans JEI.') }
  @{ k='horn'; x=4.5; y=1.5; deps=@('illagers'); tasks=@('illagerinvasion:horn_of_sight'); crate='commune'; optional=$true
     t='Le Cor de Vision'; st='Voir à travers les murs'
     d=@('Souffler dans le &eCor de Vision&r fait briller les créatures autour de toi : parfait pour repérer les illagers cachés.') }

  # --- Friends and Foes (droite)
  @{ k='fnf'; x=6; y=0; size=1.5; deps=@('intro'); tasks=@('@check'); checkTitle='Clique pour valider'; icon='minecraft:copper_block'
     t='&aFriends and Foes'; st='Les créatures oubliées des votes'
     d=@('&aFriends and Foes&r ajoute les créatures des votes de Mojang qui n''ont jamais été ajoutées au jeu : golem de cuivre, Glare, Moobloom, Mauler, Iceologer, Wildfire, Rascal, Crabe, Tuff Golem…') }
  @{ k='coppergolem'; x=7.5; y=0; deps=@('fnf'); tasks=@('@check'); checkTitle='Golem de cuivre construit !'; crate='commune'
     t='Le Golem de Cuivre'; st='Un petit assistant'
     d=@('Construis un &eGolem de Cuivre&r (regarde la recette de sa tête dans JEI). Il appuie sur les boutons en cuivre au hasard.',
         '',
         'Comme le cuivre, il s''oxyde avec le temps… et finit par se figer !') }
  @{ k='crab'; x=7.5; y=1.5; deps=@('fnf'); tasks=@('friendsandfoes:crab_claw'); crate='commune'
     t='La pince de crabe'; st='Une portée plus longue'
     d=@('Les &eCrabes&r vivent sur les plages. Leur &epince&r augmente ta portée pour poser et casser des blocs : très pratique pour construire !') }
  @{ k='wildfire'; x=6; y=1.5; deps=@('fnf'); tasks=@('kill:friendsandfoes:wildfire'); icon='friendsandfoes:wildfire_crown'; crate='rare'
     t='Le Wildfire'; st='Le gardien des bastions'
     d=@('Le &cWildfire&r est un puissant blaze protégé par des boucliers, qui vit dans les &ebastions&r du Nether.',
         '',
         'Il lâche des fragments de sa &eCouronne de Wildfire&r, un casque qui protège du feu.') }
  @{ k='totems'; x=6; y=3; deps=@('wildfire'); tasks=@('friendsandfoes:totem_of_freezing','friendsandfoes:totem_of_illusion'); crate='rare'
     t='Les totems'; st='Iceologer et Illusionniste'
     d=@('L''&bIceologer&r, un illager des glaces, lâche le &eTotem de Gel&r. L''&dIllusionniste&r lâche le &eTotem d''Illusion&r.',
         '',
         'Ces totems s''activent quand tu es blessé : le premier gèle les attaquants, le second te rend invisible et crée des leurres.') }

  # --- Critters and Companions (bas)
  @{ k='critters'; x=3; y=5; size=1.5; deps=@('intro'); tasks=@('@check'); checkTitle='Clique pour valider'; icon='crittersandcompanions:acorn'
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
  @{ k='silk'; x=4.5; y=5; deps=@('critters'); tasks=@('crittersandcompanions:silk*4'); crate='commune'
     t='La soie d''araignée sauteuse'; st='Une laisse et un grappin'
     d=@('L''&earaignée sauteuse&r lâche de la &esoie&r, qui permet de fabriquer une &elaisse en soie&r et un &egrappin&r.') }
  @{ k='pearl'; x=3; y=6.5; deps=@('critters'); tasks=@('crittersandcompanions:pearl'); crate='commune'
     t='Les perles des loutres'; st='Un collier précieux'
     d=@('Les &eloutres&r des rivières ouvrent les palourdes (qu''on pêche en rivière) pour y trouver des &eperles&r.',
         '',
         'Les perles servent à fabriquer un &ecollier de perles&r.') }
  @{ k='koi'; x=1.5; y=6.5; deps=@('critters'); tasks=@('crittersandcompanions:koi_fish_bucket'); crate='commune'; optional=$true
     t='Un bassin de koïs'; st='Ça porte bonheur'
     d=@('Les &ecarpes koï&r vivent dans les rivières et se récupèrent dans un seau. Un groupe de koïs donne de la &achance&r aux joueurs proches.',
         '',
         'Parfait pour décorer un jardin japonais !') }
  @{ k='octopus'; x=4.5; y=6.5; deps=@('critters'); tasks=@('crittersandcompanions:dumbo_octopus_bucket'); crate='commune'; optional=$true
     t='La pieuvre Dumbo'; st='Une amie des profondeurs'
     d=@('La &epieuvre Dumbo&r vit dans les océans profonds. Quand tu te noies près d''elle, elle t''offre une &bbulle d''air&r !') }
)
