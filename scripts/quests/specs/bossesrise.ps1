$Chapter = @{ file = 'bossesrise'; title = '&6&lLes Souverains'; subtitle = 'Bosses''Rise : cinq combats à la Souls'; group = '1A00000000000003'; order = 4; icon = 'block_factorys_bosses:dragon_skull' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='Clique pour valider'; icon='block_factorys_bosses:dragon_skull'
     t='&6&lLes Souverains'; st='Cinq boss, cinq arènes'
     d=@('&eBosses''Rise&r ajoute cinq boss à phases, chacun dans son &earène&r, avec ses gardes et sa musique.',
         '',
         'Observe leurs attaques avant de foncer : chaque phase change le combat. Ta &eroulade&r (touche &6R&r) est ton meilleur allié pour esquiver.',
         '',
         'Les &ecartes&r de leurs arènes tombent parfois sur les autres boss. La &eBoussole de l''Explorateur&r les trouve aussi.') }
  # --- Skor, le yeti
  @{ k='yeti'; x=-4; y=2; deps=@('intro'); tasks=@('kill:block_factorys_bosses:yeti'); icon='block_factorys_bosses:ice_gauntlet'; crate='rare'; xp=300
     t='&bSkor, le Yéti'; st='Dans les plaines enneigées'
     d=@('Son &erepaire&r se cache dans les plaines et les étendues enneigées. Attention aux pics de glace et aux blocs de glace qu''il projette.') }
  @{ k='yeti_loot'; x=-4; y=3.5; deps=@('yeti'); optional=$true; tasks=@('block_factorys_bosses:ice_gauntlet'); crate='epique'
     t='Le gantelet de Skor'; st='Le froid dans le poing' }
  # --- Sirok, le ver des sables
  @{ k='sandworm'; x=-2; y=2; deps=@('intro'); tasks=@('kill:block_factorys_bosses:sandworm'); icon='block_factorys_bosses:sandworm_gauntlet'; crate='rare'; xp=300
     t='&eSirok, le Ver des sables'; st='Sous les dunes'
     d=@('Son &enid&r est enfoui dans le désert. Il surgit du sable et crache du poison : ne reste pas immobile.') }
  @{ k='sandworm_loot'; x=-2; y=3.5; deps=@('sandworm'); optional=$true; tasks=@('block_factorys_bosses:sandworm_gauntlet'); crate='epique'
     t='Le gantelet de Sirok'; st='La force des sables' }
  # --- Nerakyss, le Kraken
  @{ k='kraken'; x=0; y=2; deps=@('intro'); tasks=@('kill:block_factorys_bosses:kraken'); icon='block_factorys_bosses:kraken_tooth'; crate='epique'; xp=500
     t='&3Nerakyss, le Kraken'; st='Au large, sur le navire pirate'
     d=@('Un &enavire pirate&r croise au-dessus des océans profonds. Débarrasse-toi de l''équipage… puis du Kraken et de ses tentacules.',
         '',
         'Les &ecanons&r du navire peuvent servir. Viens en bateau, ou en sous-marin !') }
  @{ k='kraken_loot'; x=0; y=3.5; deps=@('kraken'); optional=$true; tasks=@('block_factorys_bosses:kraken_trident'); crate='epique'
     t='Le trident du Kraken'; st='L''arme des abysses' }
  # --- Helvar, le chevalier des enfers
  @{ k='knight'; x=2; y=2; deps=@('intro'); tasks=@('kill:block_factorys_bosses:underworld_knight'); icon='block_factorys_bosses:knight_sword'; crate='epique'; xp=500
     t='&cHelvar, le Chevalier des enfers'; st='Dans le Nether'
     d=@('Son &earène&r se dresse dans les déserts du Nether et les vallées des âmes, gardée par des chevaliers squelettes du Wither.') }
  @{ k='knight_loot'; x=2; y=3.5; deps=@('knight'); optional=$true; tasks=@('block_factorys_bosses:knight_chestplate'); crate='epique'
     t='L''armure de chevalier'; st='Digne de Helvar' }
  # --- Ashlord, le dragon infernal
  @{ k='dragon'; x=4; y=2; deps=@('intro'); tasks=@('kill:block_factorys_bosses:infernal_dragon'); icon='block_factorys_bosses:dragon_bone'; crate='legendaire'; xp=800
     t='&4Ashlord, le Dragon infernal'; st='Au sommet de sa tour'
     d=@('Une &etour&r rare se dresse dans les plaines, les savanes, les jungles et les marais. Au sommet attend &4Ashlord&r, gardé par ses squelettes enflammés.',
         '',
         'Le plus dur des cinq : prépare tes meilleures armures et des potions de résistance au feu.') }
  @{ k='dragon_loot'; x=4; y=3.5; deps=@('dragon'); optional=$true; tasks=@('block_factorys_bosses:dragon_bones_chestplate'); crate='legendaire'
     t='L''armure en os de dragon'; st='Forgée dans ses restes' }
  # --- Fin
  @{ k='master'; x=0; y=5.5; size=2; shape='hexagon'; deps=@('yeti', 'sandworm', 'kraken', 'knight', 'dragon'); hideLines=$true; tasks=@('@check'); checkTitle='Les cinq sont tombés'; icon='block_factorys_bosses:dragon_skull'; crate='legendaire'; xp=1000
     t='&6&lTueur de Souverains'; st='Les cinq boss vaincus'
     d=@('Skor, Sirok, Nerakyss, Helvar et Ashlord sont tombés. Ta réputation te précède !') }
)
