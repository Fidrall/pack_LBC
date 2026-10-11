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
  # --- Reliques des mages (Reliquified Iron's Spells) : meme tirage que les reliques, dans les coffres des structures
  @{ k = 'ri_intro'; x = 1.5; y = 12; size = 1.5; shape = 'gear'; deps = @('relics_intro'); tasks = @('@check'); icon = 'reliquified_irons_spells_and_spellbooks:hat_of_omniscience'; crate = 'commune'
     t = '&d&lLes reliques des mages'; st = 'Reliquified Iron''s Spells'
     d = @('&dReliquified Iron''s Spells&r ajoute &e24 reliques&r liées à la magie : poupée vaudou, chapeau d''omniscience, épées scellées, griffes d''ombre…',
           '',
           'Elles se trouvent comme les autres reliques, dans les &ecoffres des structures&r, et montent en niveau de la même façon.',
           '',
           'Ces quêtes sont &7facultatives&r.') }
)
$ri = @(@('bloody_voodoo_doll', 'Poupée vaudou ensanglantée'), @('cardiac_trap', 'Piège cardiaque'), @('cloak_of_the_bloody_feather', 'Cape à la plume sanglante'), @('dimension_key', 'Clé dimensionnelle'), @('dragon_blood_vial', 'Fiole de sang de dragon'), @('echo_glove', 'Gant d''écho'), @('ender_bow', 'Arc de l''Ender'), @('flask_of_the_red_mist', 'Flasque de brume rouge'),
  @('galaxy_devourer_diadem', 'Diadème du dévoreur de galaxies'), @('hat_of_omniscience', 'Chapeau d''omniscience'), @('immaterial_disperser', 'Disperseur immatériel'), @('living_flesh', 'Chair vivante'), @('lunar_sextant', 'Sextant lunaire'), @('mask_of_hunger', 'Masque de la faim'), @('mirror_of_transgression', 'Miroir de transgression'), @('pulsar_mantle', 'Manteau du pulsar'),
  @('ring_of_blades', 'Anneau de lames'), @('ring_of_elusiveness', 'Anneau d''insaisissabilité'), @('sealed_claymore', 'Claymore scellée'), @('sealed_rapier', 'Rapière scellée'), @('sealed_sword', 'Épée scellée'), @('shadow_claws', 'Griffes d''ombre'), @('sinner_crown', 'Couronne du pécheur'), @('slicer', 'Trancheur'))
$i = 0
foreach ($r in $ri) {
  $Quests += @{ k = "ri_$($r[0])"; x = -4.5 + ($i % 8) * 1.5; y = 13.5 + [Math]::Floor($i / 8) * 1.5; deps = @('ri_intro'); hideLines = $true; tasks = @("reliquified_irons_spells_and_spellbooks:$($r[0])"); crate = 'rare'; optional = $true; t = $r[1]; st = 'Relique des mages' }
  $i++
}
