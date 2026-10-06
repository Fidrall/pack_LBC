# Quetes Relics, fusionnees dans le chapitre Artefacts par merge-into-chapter.ps1 (le fichier artifacts_relics.snbt est temporaire)
$Chapter = @{ file = 'artifacts_relics'; title = 'Reliques'; group = '1A00000000000003'; order = 99; icon = 'relics:ring_of_the_seven_deadly_sins' }
function RelicQ($k, $x, $y, $item, $t, $st) { @{ k = $k; x = $x; y = $y; deps = @('relics_intro'); tasks = @("relics:$item"); crate = 'rare'; optional = $true; t = $t; st = $st } }
$Quests = @(
  @{ k = 'relics_intro'; x = 1.5; y = 5.5; size = 2; shape = 'gear'; tasks = @('@check'); icon = 'relics:ring_of_the_seven_deadly_sins'; crate = 'commune'
     t = '&6&lLes Reliques'; st = 'Des objets qui grandissent avec toi'
     d = @('Les &6Reliques&r se trouvent dans les &ecoffres des structures&r. Elles se portent dans les emplacements d''accessoires (touche &eG&r).',
           '',
           '&n&aFonctionnement :&r',
           '- utilise une relique pour lui faire gagner de l''&eexpérience&r ;',
           '- chaque niveau donne des &epoints&r à dépenser dans son &earbre d''améliorations&r (clic droit dans l''inventaire sur la relique) ;',
           '- ses capacités se &edévoilent&r par un petit jeu de recherche : relie les étoiles pour former la constellation.',
           '',
           'Les quêtes ci-dessous sont &7facultatives&r : chaque relique trouvée rapporte une caisse.') }
  (RelicQ 'r_reflective' -4.5 7 'reflective_necklace' 'Collier réfléchissant' 'Cou')
  (RelicQ 'r_jellyfish' -3 7 'jellyfish_necklace' 'Collier de méduse' 'Cou')
  (RelicQ 'r_kinetic' -1 7 'kinetic_belt' 'Ceinture cinétique' 'Ceinture')
  (RelicQ 'r_hunting' 0.5 7 'hunting_belt' 'Ceinture de chasse' 'Ceinture')
  (RelicQ 'r_springy' 2.5 7 'springy_boot' 'Botte à ressort' 'Pieds')
  (RelicQ 'r_roller' 4 7 'roller_skate' 'Patin à roulettes' 'Pieds')
  (RelicQ 'r_glassboot' 5.5 7 'cut_glass_boot' 'Botte de verre taillé' 'Pieds')
  (RelicQ 'r_leafy' -4.5 8.5 'leafy_mantle' 'Cape de feuillage' 'Dos')
  (RelicQ 'r_midnight' -3 8.5 'midnight_mantle' 'Cape de minuit' 'Dos')
  (RelicQ 'r_glitchy' -1.5 8.5 'glitchy_mantle' 'Cape détraquée' 'Dos')
  (RelicQ 'r_ghostly' 0 8.5 'ghostly_mantle' 'Cape spectrale' 'Dos')
  (RelicQ 'r_chorus' 2 8.5 'chorus_staff' 'Bâton de chorus' 'Main')
  (RelicQ 'r_piglin' 3.5 8.5 'piglin_mask' 'Masque de piglin' 'Tête')
  (RelicQ 'r_flute' 5 8.5 'rider_flute' 'Flûte du cavalier' 'Pour les montures')
  (RelicQ 'r_petbone' 6.5 8.5 'pet_bone' 'Os de compagnon' 'Pour les animaux')
  (RelicQ 'r_sins' -4.5 10 'ring_of_the_seven_deadly_sins' 'Anneau des sept péchés' 'Bague')
  (RelicQ 'r_sacrifice' -3 10 'sphere_of_self_sacrifice' 'Sphère du sacrifice' 'Charme')
  (RelicQ 'r_clot' -1.5 10 'clot_of_time' 'Caillot du temps' 'Charme')
  (RelicQ 'r_tooth' 0 10 'golden_tooth' 'Dent en or' 'Charme')
  (RelicQ 'r_chef' 1.5 10 'chef_hat' 'Toque de chef' 'Tête')
  (RelicQ 'r_disperser' 3 10 'experience_disperser' 'Disperseur d''expérience' 'Charme')
  (RelicQ 'r_shield' 4.5 10 'shield_of_retaliation' 'Bouclier de représailles' 'Main secondaire')
  @{ k = 'r_bottle'; x = 6.5; y = 10; deps = @('relics_intro'); tasks = @('relics:relic_experience_bottle'); crate = 'commune'; optional = $true
     t = 'Bouteille d''expérience de relique'; st = 'Pour faire progresser plus vite'
     d = @('Une &ebouteille d''expérience&r qui se donne directement à une relique. Pratique pour monter en niveau celles qui s''utilisent rarement.') }
)
