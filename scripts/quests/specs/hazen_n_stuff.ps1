$Chapter = @{ file = 'hazen_n_stuff'; title = '&6&lHazen ''n Stuff'; subtitle = 'Armes, armures et sorts pour les mages'; group = '1A00000000000004'; order = 3; icon = 'hazennstuff:deus_essence' }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); crate='commune'
     t='&6&lHazen ''n Stuff'; st='Une extension d''Iron''s Spells'
     d=@('&6Hazen ''n Stuff&r ajoute &d39 sorts&r, des dizaines d''&earmes&r et de &esets d''armure de mage&r, et des &bcristaux&r qui renforcent mana, vie et esprit.',
         '',
         'Tape &d@hazennstuff&r dans JEI pour tout voir.') }
  @{ k='steel'; x=2; y=-1; deps=@('intro'); tasks=@('hazennstuff:steel_ingot*4'); crate='commune'
     t='L''Acier'; st='Le métal de base'
     d=@('L''&eacier&r sert à presque tout : runes, cristaux, lingots plus rares.') }
  @{ k='runes'; x=2; y=1; deps=@('intro'); tasks=@('hazennstuff:melee_rune','hazennstuff:health_rune'); crate='commune'
     t='Nouvelles runes'; st='Mêlée et Vie'
     d=@('Les runes de Hazen se font avec une &erune vierge&r d''Iron''s et un objet de « focus ».',
         '',
         'Combinées à un &eorbe d''amélioration&r, elles donnent les orbes de Mêlée et de Vie.') }
  @{ k='orbs'; x=4; y=1; deps=@('runes'); tasks=@('hazennstuff:melee_upgrade_orb','hazennstuff:health_upgrade_orb'); crate='rare'
     t='Orbes d''amélioration'; st='Pour les cristaux et l''équipement' }
  @{ k='mana1'; x=6; y=-2; deps=@('orbs'); tasks=@('hazennstuff:ruptured'); crate='commune'; t='Cristal de mana fissuré'; st='Rune et essence arcaniques, améthyste' }
  @{ k='mana2'; x=8; y=-2; deps=@('mana1'); tasks=@('hazennstuff:refined'); crate='rare'; t='Cristal de mana raffiné' }
  @{ k='mana3'; x=10; y=-2; deps=@('mana2','zenalite'); tasks=@('hazennstuff:reinforced'); crate='epique'; t='Cristal de mana renforcé'; st='Demande de la Zénalite et du Pyrium' }
  @{ k='mana4'; x=12; y=-2; deps=@('mana3','divine'); tasks=@('hazennstuff:radiance'); crate='legendaire'; t='&dCristal de mana radieux' }
  @{ k='life1'; x=6; y=0; deps=@('orbs'); tasks=@('hazennstuff:shattered'); crate='commune'; t='Cristal de vie brisé'; st='Rune de vie, quartz rose, melon scintillant' }
  @{ k='life2'; x=8; y=0; deps=@('life1'); tasks=@('hazennstuff:sacred'); crate='rare'; t='Cristal de vie sacré' }
  @{ k='life3'; x=10; y=0; deps=@('life2','zenalite'); tasks=@('hazennstuff:strengthened'); crate='epique'; t='Cristal de vie fortifié' }
  @{ k='life4'; x=12; y=0; deps=@('life3','divine'); tasks=@('hazennstuff:singularity'); crate='legendaire'; t='&dCristal de vie singulier' }
  @{ k='spirit1'; x=6; y=2; deps=@('orbs','dreadstone'); tasks=@('hazennstuff:abstract'); crate='commune'; t='Cristal d''esprit abstrait'; st='Rune de mêlée, pierre d''effroi, épée en diamant' }
  @{ k='spirit2'; x=8; y=2; deps=@('spirit1'); tasks=@('hazennstuff:advanced'); crate='rare'; t='Cristal d''esprit avancé' }
  @{ k='spirit3'; x=10; y=2; deps=@('spirit2','zenalite'); tasks=@('hazennstuff:abomination'); crate='epique'; t='Cristal d''esprit abominable' }
  @{ k='spirit4'; x=12; y=2; deps=@('spirit3','divine'); tasks=@('hazennstuff:absolute'); crate='legendaire'; t='&dCristal d''esprit absolu' }
  @{ k='dreadstone'; x=0; y=4; deps=@('intro'); shape='hexagon'; tasks=@('hazennstuff:dreadstone*4'); crate='commune'
     t='Pierre d''effroi'; st='Overworld, sous la couche 0'
     d=@('Le minerai de &ePierre d''effroi&r se trouve dans tout l''Overworld, entre &ey=-64 et y=0&r.') }
  @{ k='dreadsteel'; x=0; y=5.5; deps=@('dreadstone','steel'); tasks=@('hazennstuff:dreadsteel_ingot'); crate='commune'; t='Acier d''effroi' }
  @{ k='chloro'; x=1.5; y=4; deps=@('intro'); shape='hexagon'; tasks=@('hazennstuff:chlorophyte_chunk*4'); crate='commune'
     t='Chlorophyte'; st='Dans les jungles'
     d=@('Le minerai de &aChlorophyte&r n''apparaît que sous les &ajungles&r. Fais fondre les morceaux pour obtenir des lingots.') }
  @{ k='chloro2'; x=1.5; y=5.5; deps=@('chloro'); tasks=@('hazennstuff:chlorophyte_ingot*4'); crate='rare'; t='Lingots de Chlorophyte'; st='Pour l''armure de Chlorophyte' }
  @{ k='solar'; x=3; y=4; deps=@('intro'); shape='hexagon'; tasks=@('hazennstuff:solar_core'); crate='rare'
     t='Noyau solaire'; st='Dans le Nether'
     d=@('Le minerai de &6Noyau solaire&r se trouve dans la netherrack et la blackstone du &cNether&r.') }
  @{ k='zenalite_ore'; x=4.5; y=4; deps=@('intro'); shape='hexagon'; tasks=@('hazennstuff:raw_zenalite*4'); crate='rare'
     t='Zénalite brute'; st='Les îles extérieures de l''End'
     d=@('Le minerai de &5Zénalite&r n''apparaît que dans les &5îles extérieures de l''End&r, pas sur l''île centrale.') }
  @{ k='zenalite'; x=4.5; y=5.5; deps=@('zenalite_ore'); tasks=@('hazennstuff:zenalite_ingot*4'); crate='epique'
     t='&5Lingots de Zénalite'; st='Il faut une étoile du Nether'
     d=@('La zénalite brute doit être « bénie » avec un &efragment d''étoile du Nether&r (une étoile du Nether donne plusieurs fragments), puis cuite au haut fourneau.',
         '',
         'C''est le matériau clé des cristaux de rang 3.') }
  @{ k='wanderer'; x=6; y=5.5; deps=@('zenalite_ore'); tasks=@('kill:hazennstuff:void_wanderer'); crate='epique'
     t='Le Vagabond du Vide'; st='Un errant des îles de l''End'
     d=@('Le &5Vagabond du Vide&r, le &5Reclus&r et le &5Serviteur de l''Ender&r rôdent dans les îles extérieures de l''End.',
         '',
         'Le Vagabond lâche de la &dPoussière d''étoile&r, nécessaire à l''&eOr cosmique&r.') }
  @{ k='cosmic'; x=7.5; y=5.5; deps=@('wanderer','zenalite'); tasks=@('hazennstuff:cosmic_gold_ingot'); crate='epique'; t='Or cosmique' }
  @{ k='rosegold'; x=3; y=7; deps=@('intro'); tasks=@('hazennstuff:rose_gold_ingot*2','hazennstuff:hallowed_ingot'); crate='rare'
     t='Or rose et Lingot sacré'; st='Grâce aux perles divines d''Iron''s' }
  @{ k='divine'; x=10; y=4; deps=@('zenalite'); tasks=@('hazennstuff:deus_essence','hazennstuff:divine_mold'); crate='epique'
     t='&eEssence divine'; st='Le dernier ingrédient'
     d=@('L''&eEssence Deus&r vient d''un &eéclat d''âme divin&r d''Iron''s Spells. Avec le &eMoule divin&r, elle permet le rang 4 des cristaux.') }
  @{ k='flamebearer'; x=12; y=4; deps=@('divine'); tasks=@('kill:hazennstuff:pyromus'); crate='legendaire'
     t='&cLes serviteurs du Porte-Flamme'; st='Pyromus, Aegis et Aptos'
     d=@('Trois champions du &cPorte-Flamme&r : &cPyromus&r, &cAegis&r et &cAptos&r. Ils lâchent du &6Pyrium&r et des reliques uniques (bague, médaillon, lame du Légat).') }
  @{ k='terraprisma'; x=14; y=0; size=2; shape='gear'; deps=@('mana4','life4','spirit4'); tasks=@('hazennstuff:terraprisma'); crate='legendaire'
     t='&d&lTerraprisma'; st='L''arme ultime'
     d=@('Le &dTerraprisma&r invoque des épées de lumière qui combattent à tes côtés.',
         '',
         'Bravo, tu maîtrises Hazen ''n Stuff !') }
)
