$Chapter = @{ file = 'gateways'; title = '&5&lPortails de l''éternité'; subtitle = 'Gateways to Eternity : vagues de monstres, butin à la clé'; group = '1A00000000000003'; order = 5; icon = 'gateways:gate_pearl[gateways:gateway=pack_lbc:defi_seigneurs]' }
function P($id) { "gateways:gate_pearl[gateways:gateway=pack_lbc:$id]" }
$Quests = @(
  @{ k='intro'; x=0; y=0; size=2; shape='gear'; tasks=@('@check'); checkTitle='Clique pour valider'; icon=(P 'nuit_sans_fin')
     t='&5&lPortails de l''éternité'; st='Ouvre un portail, tiens bon jusqu''à la dernière vague'
     d=@('Une &eperle de portail&r se fabrique à l''établi (recettes dans JEI). Utilise-la sur le sol : un &eportail&r s''ouvre et des &cvagues de monstres&r en sortent.',
         '',
         'Chaque vague tuée lâche le butin de ses monstres. Survis à la dernière pour obtenir la &erécompense finale&r du portail.',
         '',
         '&6Règles :&r reste à moins de &e100 blocs&r du portail, et ne dépasse pas ton nombre de &cvies&r. En cas d''échec, le portail explose (sans casser de blocs) et les monstres disparaissent.',
         '',
         'Viens bien équipé, et à plusieurs pour les derniers portails.') }
  @{ k='nuit'; x=0; y=2.5; deps=@('intro'); tasks=@((P 'nuit_sans_fin')); icon=(P 'nuit_sans_fin'); crate='commune'; xp=100
     t='&9La Nuit sans fin'; st='Le premier portail'
     d=@('&eRecette :&r chair putréfiée, poudre à canon, ficelle, os et une perle de l''Ender.',
         '',
         'Quatre vagues de &ezombies, squelettes, araignées, creepers&r et &esorcières&r, de plus en plus résistants. &a3 vies&r.',
         '',
         '&6Récompense :&r butin de donjon et de l''expérience. Un bon entraînement avant les portails suivants.') }
  @{ k='sabbat'; x=-2.5; y=4; deps=@('nuit'); tasks=@((P 'sabbat_citrouilles')); icon=(P 'sabbat_citrouilles'); crate='rare'; xp=200
     t='&6Le Sabbat des citrouilles'; st='Born in Chaos'
     d=@('&eRecette :&r lanternes-citrouilles, lingots d''or et un œil de l''Ender.',
         '',
         'Les citrouilles de &eBorn in Chaos&r : Mr et Mrs Pumpkin, Señor Pumpkin, cogneurs… et &cSir Pumpkinhead&r à la dernière vague. &a3 vies&r.',
         '',
         '&6Récompense :&r deux objets &9rares&r d''Apotheosis et trois gemmes.') }
  @{ k='morts'; x=0; y=4; deps=@('nuit'); tasks=@((P 'morts_sans_repos')); icon=(P 'morts_sans_repos'); crate='rare'; xp=200
     t='&2Les Morts sans repos'; st='Born in Chaos'
     d=@('&eRecette :&r blocs d''os, sable des âmes et un œil de l''Ender.',
         '',
         'Zombies en décomposition, esprits errants, invocateurs d''os… et le &cBonescaller suprême&r pour finir. &a3 vies&r.',
         '',
         '&6Récompense :&r quatre gemmes et un objet &9rare&r d''Apotheosis.') }
  @{ k='gardiens'; x=2.5; y=4; deps=@('nuit'); tasks=@((P 'gardiens_sorcellerie')); icon=(P 'gardiens_sorcellerie'); crate='rare'; xp=200
     t='&dLes Gardiens de la sorcellerie'; st='Iron''s Spells'
     d=@('&eRecette :&r essence arcanique, lapis-lazuli, encre commune et un œil de l''Ender.',
         '',
         'Cultistes, chasseurs de mages, pyromanciens, cryomanciens, nécromanciens… et deux &carchévocateurs&r à la dernière vague. &a3 vies&r.',
         '',
         '&6Récompense :&r du butin magique et un &etome de la citadelle&r.') }
  @{ k='echo'; x=-1.25; y=5.5; deps=@('sabbat', 'morts', 'gardiens'); minDeps=1; tasks=@((P 'echo_profondeurs')); icon=(P 'echo_profondeurs'); crate='epique'; xp=400
     t='&3L''Écho des profondeurs'; st='Le Deep Dark déchaîné'
     d=@('&eRecette :&r éclats d''écho, cristal d''âme (Deeper and Darker), catalyseurs de sculk et un œil de l''Ender.',
         '',
         'Les créatures du sculk, des &cstalkers&r… puis le &4Warden&r en personne. Seulement &c2 vies&r.',
         '',
         '&6Récompense :&r butin de cité antique et un trésor du temple de l''Otherside.') }
  @{ k='citadelle'; x=1.25; y=5.5; deps=@('sabbat', 'morts', 'gardiens'); minDeps=1; tasks=@((P 'citadelle_ender')); icon=(P 'citadelle_ender'); crate='epique'; xp=400
     t='&5La Citadelle de l''Ender'; st='L''End et Cataclysm'
     d=@('&eRecette :&r carapaces de shulker, chorus éclaté et un œil de l''Ender.',
         '',
         'Endermen, endermaptères et shulkers, puis les &cgolems de l''Ender&r de Cataclysm. Seulement &c2 vies&r.',
         '',
         '&6Récompense :&r trésor de cité de l''End, trois gemmes de grande pureté et un objet &5épique&r.') }
  @{ k='defi'; x=0; y=7; deps=@('echo', 'citadelle'); minDeps=1; tasks=@((P 'defi_seigneurs')); icon=(P 'defi_seigneurs'); crate='legendaire'; xp=800
     t='&6&lLe Défi des Seigneurs'; st='Le portail ultime'
     d=@('&eRecette :&r lingots d''ignitium et de witherite (Cataclysm), blocs de diamant et une étoile du Nether.',
         '',
         'Revenants enflammés, chevaliers du chaos, &cKobolédiateur&r, &cWadjet&r, &cVoleur de vie&r, archévocateurs… et le &4Prowler&r pour conclure. Seulement &c2 vies&r.',
         '',
         '&6Récompense :&r deux objets &6mythiques&r, trois gemmes parfaites et un &etrophée unique&r.') }
  @{ k='trophee'; x=0; y=8.5; deps=@('defi'); tasks=@('minecraft:nether_star[minecraft:rarity=epic]'); icon='minecraft:nether_star'; crate='legendaire'; xp=1000; shape='diamond'; size=1.5
     t='&6&lLe Trophée des Seigneurs'; st='Preuve de ta victoire'
     d=@('Ferme le &eDéfi des Seigneurs&r jusqu''à la dernière vague et rapporte le &6Trophée du Défi des Seigneurs&r.',
         '',
         'Il n''existe pas d''autre moyen de l''obtenir : garde-le bien en évidence.') }
)
