# Epic Knights, fusionne dans le chapitre Simply Swords par merge-into-chapter.ps1 (epic_knights.snbt est temporaire).
# Bloc sous la grille de Simply Swords (y >= 5).
$Chapter = @{ file = 'epic_knights'; title = 'Epic Knights'; group = '1A00000000000004'; order = 99; icon = 'magistuarmory:knight_chestplate' }
function Ek($k, $x, $y, $item, $t, $st, $d, $crate = 'commune') { @{ k = $k; x = $x; y = $y; deps = @('ek_intro'); hideLines = $true; tasks = @("magistuarmory:$item"); crate = $crate; optional = $true; t = $t; st = $st; d = $d } }
$Quests = @(
  @{ k='ek_intro'; x=-6; y=5.5; size=1.5; shape='gear'; tasks=@('@check'); icon='magistuarmory:knight_chestplate'; crate='commune'
     t='&7&lEpic Knights'; st='Armures et armes médiévales'
     d=@('&7Epic Knights&r ajoute des dizaines d''&earmures médiévales&r (chevalier, gothique, maximilienne, croisé…), des &earmes&r (épées bâtardes, hallebardes, masses, lances de joute, arbalète lourde) et des &eboucliers&r.',
         '',
         'Les armes ont leurs propres attaques grâce à Better Combat, et les casques se décorent de plumes, de couronnes ou de cornes.',
         '',
         'La plupart existent en plusieurs métaux. Tape &d@magistuarmory&r dans JEI pour tout voir.') }
  (Ek 'ek_steel' -4.5 5 'steel_ingot' 'L''acier' 'Le métal des chevaliers' @('L''&eacier&r sert aux meilleures armes et armures d''Epic Knights.'))
  (Ek 'ek_sword' -3 5 'steel_bastardsword' 'L''épée bâtarde' 'À une ou deux mains' @('Une &eépée bâtarde&r en acier, polyvalente.'))
  (Ek 'ek_halberd' -1.5 5 'steel_concavehalberd' 'La hallebarde' 'Frapper de loin' @('Une &earme d''hast&r qui frappe à bonne distance.'))
  (Ek 'ek_mace' 0 5 'steel_morgenstern' 'L''étoile du matin' 'Contre les armures' @('Une &emasse à pointes&r, efficace contre les ennemis en armure.'))
  (Ek 'ek_lance' 1.5 5 'steel_chivalrylance' 'La lance de joute' 'La charge à cheval' @('La &elance&r fait d''énormes dégâts en chargeant à cheval.') 'rare')
  (Ek 'ek_shield' 3 5 'steel_heatershield' 'L''écu' 'Le bouclier du chevalier' @('Un &eécu&r en acier. Il existe aussi des rondaches, des pavois, des boucliers en amande…'))
  (Ek 'ek_crossbow' 4.5 5 'heavy_crossbow' 'L''arbalète lourde' 'Lente mais redoutable' @('Une &earbalète lourde&r, plus lente à recharger mais bien plus puissante.') 'rare')
  (Ek 'ek_longbow' 6 5 'longbow' 'L''arc long' 'Tirer loin' @('Un &earc long&r qui tire plus loin et plus fort.'))
  (Ek 'ek_knight' -4.5 6.5 'knight_chestplate' 'L''armure de chevalier' 'La plus classique' @('L''&earmure de chevalier&r complète.') 'rare')
  (Ek 'ek_gothic' -3 6.5 'gothic_chestplate' 'L''armure gothique' 'Élégante et solide' @('Une &earmure gothique&r aux lignes fines.') 'rare')
  (Ek 'ek_maximilian' -1.5 6.5 'maximilian_chestplate' 'L''armure maximilienne' 'Cannelée de partout' @('L''&earmure maximilienne&r, l''une des plus protectrices.') 'epique')
  (Ek 'ek_crusader' 0 6.5 'crusader_chestplate' 'L''armure de croisé' 'Pour partir en croisade' @('L''&earmure de croisé&r, à porter avec un grand heaume.') 'rare')
  (Ek 'ek_jousting' 1.5 6.5 'jousting_chestplate' 'L''armure de joute' 'Pour les tournois' @('L''&earmure de joute&r, à porter avec la lance.') 'epique')
  (Ek 'ek_barding' 3 6.5 'barding' 'Le caparaçon' 'Une armure pour ton cheval' @('Un &ecaparaçon&r protège ton &echeval&r au combat.') 'rare')
  (Ek 'ek_plume' 4.5 6.5 'big_plume_decoration' 'Le panache' 'Décorer son casque' @('Ajoute un &epanache&r, une couronne ou des cornes à ton casque.'))
)
