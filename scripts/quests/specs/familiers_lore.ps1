# Quetes de progres d'Alshanex's Familiars, fusionnees dans le chapitre des familiers (repris de l'ancien pack) par merge-into-chapter.ps1.
# Usage : run-spec familiers_lore, puis merge-into-chapter.ps1 -Source familiers_lore -Target familiers. Ids repris de magie_addons (progression conservee).
# Ancrages dans le chapitre d'origine : ile des origines 32A6059C63E5BFC3, miroir de verite 594C7C998C98F2EC, intro 627A25524F94FB34.
$Chapter = @{ file = 'familiers_lore'; title = 'Familiers (progres)'; group = '1A00000000000004'; order = 99; icon = 'alshanex_familiars:familiar_tome' }
$Quests = @(
  @{ k='af_memory'; x=-13; y=7.5; deps=@('32A6059C63E5BFC3'); tasks=@('adv:alshanex_familiars:alshanex_familiars/memory_fragment'); crate='commune'; optional=$true; icon='alshanex_familiars:memory_fragment'
     t='Un goût de chez soi'; st='Un fragment de mémoire'; d=@('Donne une &ebaie de cristal&r à un familier : il te montre un &efragment de mémoire&r.') }
  @{ k='af_island'; x=-11.5; y=7.5; deps=@('af_memory'); tasks=@('adv:alshanex_familiars:alshanex_familiars/origin_island'); crate='rare'; optional=$true; icon='alshanex_familiars:ritual_core'
     t='Là où tout a commencé'; st='L''île des origines'; d=@('Suis les fragments de mémoire jusqu''à l''&eîle des origines&r, où se font les rituels.') }
  @{ k='af_soul'; x=-10; y=7.5; deps=@('af_island'); tasks=@('adv:alshanex_familiars:alshanex_familiars/bottle_soul'); crate='rare'; optional=$true; icon='alshanex_familiars:pet_soul'
     t='Un esprit en bouteille'; st='Capturer une âme'; d=@('Capture une &eâme de familier&r dans une fiole vide.') }
  @{ k='af_reinc'; x=-8.5; y=7.5; deps=@('af_soul'); tasks=@('adv:alshanex_familiars:alshanex_familiars/reincarnation'); crate='rare'; optional=$true; icon='alshanex_familiars:lightning_mage_shard'
     t='La réincarnation'; st='Créer un familier'; d=@('Utilise un &eéclat de familier&r pour en créer un.') }
  @{ k='af_impostor'; x=-10; y=5.75; deps=@('594C7C998C98F2EC'); tasks=@('adv:alshanex_familiars:alshanex_familiars/impostor'); crate='rare'; optional=$true; icon='alshanex_familiars:truth_mirror'
     t='Imposteur !'; st='Démasquer un illusionniste'; d=@('Révèle un &efamilier illusionniste&r déguisé avec le miroir de vérité.') }
  @{ k='af_all'; x=5.75; y=7.5; size=1.5; shape='hexagon'; deps=@('627A25524F94FB34'); hideLines=$true; tasks=@('adv:alshanex_familiars:alshanex_familiars/anthropologist'); crate='legendaire'; optional=$true; icon='alshanex_familiars:familiar_tome'
     t='&d&lAnthropologue'; st='Tous les familiers'; d=@('Apprivoise &etous les types de familiers&r.') }
)
