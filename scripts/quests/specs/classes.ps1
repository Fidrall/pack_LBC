$Chapter = @{ file = 'classes'; title = '&d&lLes Classes'; subtitle = 'Choisis ta voie, équipe-toi, spécialise-toi'; group = '1A00000000000004'; order = 0; icon = 'wizards:staff_wizard' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='Clique pour valider'; icon='wizards:staff_wizard'
     t='&d&lLes Classes'; st='Mage, paladin, voleur, archer…'
     d=@('Ta &dclasse&r, c''est ton &eéquipement&r : une arme de classe donne ses sorts et ses compétences, une armure de classe renforce ses pouvoirs.',
         '',
         'Rien n''est figé : tu peux changer de classe en changeant d''équipement. Mais chaque classe a son propre &earbre de compétences&r, et c''est là que tu te spécialises.',
         '',
         '- Les &ebâtiments de classe&r (tour de mage, sanctuaire, caserne, champ de tir, bijouterie) apparaissent dans les villages. Leurs villageois vendent l''équipement de base.',
         '- L''équipement plus puissant se trouve dans les &ecoffres des structures&r et sur les &cboss&r.') }
  # --- Tronc commun
  @{ k='runes'; x=-3; y=1.5; deps=@('intro'); tasks=@('runes:crafting_altar'); crate='commune'
     t='L''autel des runes'; st='Les munitions des sorts'
     d=@('Les sorts les plus puissants consomment des &erunes&r : arcane, feu, givre, soin, foudre, âme.',
         '',
         'L''&eautel des runes&r les fabrique à moindre coût. Une &ebourse à runes&r portée en accessoire les fournit automatiquement.') }
  @{ k='binding'; x=-1.5; y=1.5; deps=@('intro'); tasks=@('spell_engine:spell_binding'); crate='commune'
     t='La table de liaison'; st='Lier des sorts'
     d=@('La &etable de liaison des sorts&r permet d''ajouter des sorts à un &elivre de sorts&r ou à une arme compatible, en échange d''expérience.') }
  @{ k='skills'; x=0; y=1.5; deps=@('intro'); tasks=@('@check'); checkTitle='J''ai ouvert mon arbre'; icon='minecraft:experience_bottle'; crate='commune'
     t='&eL''arbre de compétences'; st='Touche O'
     d=@('Ouvre ton &earbre de compétences&r avec la touche &6O&r.',
         '',
         'Tu gagnes des points en ramassant de l''expérience. Chaque classe a son arbre : spécialisation offensive ou défensive, sorts modifiés, effets passifs.',
         '',
         '&7Les choix comptent : on ne peut pas tout prendre.') }
  @{ k='jewelry'; x=1.5; y=1.5; deps=@('intro'); tasks=@('jewelry:jewelers_kit'); crate='commune'
     t='Bijoutier'; st='Bagues et colliers'
     d=@('Les &egemmes&r de Jewelry se trouvent sous terre (rubis, topaze, citrine, jade, saphir, tanzanite).',
         '',
         'Taillées et montées en &ebagues&r et &ecolliers&r, elles augmentent la puissance de sort, les critiques ou la vitesse d''incantation.') }
  @{ k='apotheosis'; x=3; y=1.5; deps=@('intro'); tasks=@('@check'); checkTitle='Compris !'; icon='apotheosis:gem'; crate='rare'
     t='&5La magie d''Apotheosis'; st='Affixes et gemmes de sort'
     d=@('L''équipement de classe peut recevoir des &5affixes&r comme le reste.',
         '',
         '- Sur les armures : &dpuissance d''une école de magie&r (arcane, feu, givre, soin, foudre, âme, terre, eau, air).',
         '- Sur les armes et bâtons : &dpuissance de sort&r, &dcritique&r et &dvitesse d''incantation&r.',
         '- Deux gemmes : la &eGemme de l''archimage&r et la &eGemme de célérité&r.') }
  # --- Mage
  @{ k='mage'; x=-7.5; y=3; deps=@('intro'); hideLines=$true; tasks=@('wizards:staff_wizard'); crate='commune'
     t='&9Mage'; st='Arcane, feu ou givre'
     d=@('Le &9bâton de mage&r est le premier pas. Choisis ensuite ton école avec une robe et une arme dédiées.') }
  @{ k='mage_arcane'; x=-8.5; y=4.5; deps=@('mage'); optional=$true; tasks=@('wizards:arcane_robe_chest'); crate='rare'
     t='Mage des arcanes'; st='Projectiles et téléportation' }
  @{ k='mage_fire'; x=-7.5; y=4.5; deps=@('mage'); optional=$true; tasks=@('wizards:fire_robe_chest'); crate='rare'
     t='Mage du feu'; st='Brûler et exploser' }
  @{ k='mage_frost'; x=-6.5; y=4.5; deps=@('mage'); optional=$true; tasks=@('wizards:frost_robe_chest'); crate='rare'
     t='Mage du givre'; st='Ralentir et geler' }
  # --- Elementaliste
  @{ k='elem_aqua'; x=-5; y=3; deps=@('intro'); hideLines=$true; optional=$true; tasks=@('elemental_wizards_rpg:ocean_robe_chest'); crate='rare'
     t='&3Élémentaliste de l''eau'; st='Vagues et soins'
     d=@('Les &3élémentalistes&r maîtrisent l''eau, la terre ou l''air.') }
  @{ k='elem_terra'; x=-5; y=4.5; deps=@('intro'); hideLines=$true; optional=$true; tasks=@('elemental_wizards_rpg:mountain_robe_chest'); crate='rare'
     t='&6Élémentaliste de la terre'; st='Roche et défense' }
  @{ k='elem_wind'; x=-5; y=6; deps=@('intro'); hideLines=$true; optional=$true; tasks=@('elemental_wizards_rpg:hurricane_robe_chest'); crate='rare'
     t='&fÉlémentaliste de l''air'; st='Vitesse et tempêtes' }
  # --- Paladin
  @{ k='paladin'; x=-2.5; y=3; deps=@('intro'); hideLines=$true; tasks=@('paladins:iron_claymore'); crate='commune'
     t='&ePaladin'; st='Bouclier et lumière'
     d=@('Le &epaladin&r protège ses alliés et frappe avec une claymore ou un marteau.') }
  @{ k='paladin_armor'; x=-2.5; y=4.5; deps=@('paladin'); tasks=@('paladins:crusader_armor_chest'); crate='rare'
     t='Armure de croisé'; st='Tenir la ligne' }
  @{ k='paladin_nether'; x=-2.5; y=6; deps=@('paladin_armor'); tasks=@('paladins:netherite_crusader_armor_chest'); crate='epique'
     t='Croisé en netherite'; st='Le rempart' }
  # --- Pretre
  @{ k='priest'; x=0; y=3; deps=@('intro'); hideLines=$true; tasks=@('paladins:holy_wand'); crate='commune'
     t='&fPrêtre'; st='Soigner et bénir'
     d=@('Le &fprêtre&r soigne et renforce ses alliés : indispensable en groupe face aux boss.') }
  @{ k='priest_robe'; x=0; y=4.5; deps=@('priest'); tasks=@('paladins:priest_robe_chest'); crate='rare'
     t='Robe de prêtre'; st='La voix de la lumière' }
  @{ k='priest_nether'; x=0; y=6; deps=@('priest_robe'); tasks=@('paladins:netherite_prior_robe_chest'); crate='epique'
     t='Prieur en netherite'; st='Le sanctuaire ambulant' }
  # --- Guerrier
  @{ k='warrior'; x=2.5; y=3; deps=@('intro'); hideLines=$true; tasks=@('rogues:iron_double_axe'); crate='commune'
     t='&cGuerrier'; st='Frapper fort'
     d=@('Le &cguerrier&r encaisse et frappe : haches doubles, glaives, cris de guerre.') }
  @{ k='warrior_armor'; x=2.5; y=4.5; deps=@('warrior'); tasks=@('rogues:warrior_armor_chest'); crate='rare'
     t='Armure de guerrier'; st='Au cœur de la mêlée' }
  @{ k='warrior_nether'; x=2.5; y=6; deps=@('warrior_armor'); tasks=@('rogues:netherite_berserker_armor_chest'); crate='epique'
     t='Guerrier en netherite'; st='Inarrêtable' }
  # --- Voleur
  @{ k='rogue'; x=5; y=3; deps=@('intro'); hideLines=$true; tasks=@('rogues:iron_dagger'); crate='commune'
     t='&8Voleur'; st='Discrétion et coups critiques'
     d=@('Le &8voleur&r frappe vite, disparaît et revient dans le dos de sa cible.') }
  @{ k='rogue_armor'; x=5; y=4.5; deps=@('rogue'); tasks=@('rogues:rogue_armor_chest'); crate='rare'
     t='Tenue de voleur'; st='Dans l''ombre' }
  @{ k='rogue_nether'; x=5; y=6; deps=@('rogue_armor'); tasks=@('rogues:netherite_assassin_armor_chest'); crate='epique'
     t='Assassin en netherite'; st='Personne ne t''a vu' }
  # --- Berserker
  @{ k='berserker'; x=7.5; y=3; deps=@('intro'); hideLines=$true; tasks=@('berserker_rpg:iron_berserker_axe'); crate='commune'
     t='&4Berserker'; st='La rage du combat'
     d=@('Le &4berserker&r entre en transe : plus le combat dure, plus il frappe fort.') }
  @{ k='berserker_armor'; x=7.5; y=4.5; deps=@('berserker'); tasks=@('berserker_rpg:northling_chest'); crate='rare'
     t='Armure nordique'; st='Venu du froid' }
  @{ k='berserker_nether'; x=7.5; y=6; deps=@('berserker_armor'); tasks=@('berserker_rpg:netherite_northling_chest'); crate='epique'
     t='Berserker en netherite'; st='La fureur incarnée' }
  # --- Archer
  @{ k='archer'; x=-2.5; y=8; deps=@('intro'); hideLines=$true; tasks=@('archers:composite_longbow'); crate='commune'
     t='&aArcher'; st='Frapper de loin'
     d=@('L''&aarcher&r tire des flèches enchantées et pose des pièges. Arcs longs, arcs courts, arbalètes lourdes ou rapides.') }
  @{ k='archer_armor'; x=-2.5; y=9.5; deps=@('archer'); tasks=@('archers:archer_armor_chest'); crate='rare'
     t='Tenue d''archer'; st='Léger et précis' }
  @{ k='archer_nether'; x=-2.5; y=11; deps=@('archer_armor'); tasks=@('archers:netherite_ranger_armor_chest'); crate='epique'
     t='Rôdeur en netherite'; st='L''œil du faucon' }
  # --- Witcher
  @{ k='witcher'; x=0; y=8; deps=@('intro'); hideLines=$true; tasks=@('witcher_rpg:iron_witcher_sword'); crate='commune'
     t='&7Witcher'; st='Chasseur de monstres'
     d=@('Le &7witcher&r combat à l''épée et lance des &esignes&r. Il utilise huiles et potions contre les monstres.') }
  @{ k='witcher_school'; x=0; y=9.5; deps=@('witcher'); tasks=@('@check'); checkTitle='J''ai choisi mon école'; icon='witcher_rpg:cat_school_medallion'; crate='rare'
     t='Choisir son école'; st='Chat, Griffon, Ours ou Loup'
     d=@('Chaque &eécole de witcher&r a son armure et son style : le &eChat&r (agilité), le &eGriffon&r (signes), l''&eOurs&r (résistance), le &eLoup&r (équilibre).',
         '',
         'Les armures s''améliorent ensuite avec des &ediagrammes&r de plus en plus rares.') }
  # --- Butin rare
  @{ k='bows'; x=2.5; y=8; deps=@('intro'); hideLines=$true; optional=$true; tasks=@('@check'); checkTitle='J''en ai trouvé un !'; icon='simplybows:ice_bow/ice_bow'; crate='epique'
     t='&bArcs uniques'; st='Simply Bows'
     d=@('Huit &barcs uniques&r aux effets spéciaux (glace, abeilles, vignes, écho…) se cachent dans les coffres des structures et sur les boss.') }
  @{ k='arsenal'; x=5; y=8; deps=@('intro'); hideLines=$true; optional=$true; tasks=@('@check'); checkTitle='J''en ai trouvé une !'; icon='arsenal:unique_claymore_1'; crate='epique'
     t='&6Armes uniques'; st='Arsenal'
     d=@('Les &6armes uniques&r d''Arsenal ont des effets spéciaux en touchant ou en lançant des sorts. On les trouve surtout sur les &cboss les plus durs&r.') }
  @{ k='armory'; x=7.5; y=8; deps=@('intro'); hideLines=$true; optional=$true; tasks=@('@check'); checkTitle='J''ai un set complet !'; icon='armory_rpgs:avatar_robe_chest'; crate='epique'
     t='&6Armures légendaires'; st='Armory'
     d=@('Les sets d''&6Armory&r sont les meilleures armures de classe. Ils tombent sur les boss de fin de jeu.') }
  # --- Fin
  @{ k='master'; x=0; y=12.5; size=2; shape='hexagon'; deps=@('paladin_nether', 'priest_nether', 'warrior_nether', 'rogue_nether', 'berserker_nether', 'archer_nether', 'mage_arcane', 'mage_fire', 'mage_frost'); minDeps=1; hideLines=$true; tasks=@('@check'); checkTitle='Ma classe est au sommet'; icon='minecraft:nether_star'; crate='legendaire'; xp=1000
     t='&d&lMaître de classe'; st='Une classe au sommet'
     d=@('Tu as amené une classe au plus haut niveau d''équipement. Reste à remplir ton arbre de compétences… et à essayer une autre voie !') }
)
