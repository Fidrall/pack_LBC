# Outils du livre de quetes (FTB Quests)

- `specs/*.ps1` : description des chapitres ecrits pour pack_LBC (une quete = une table PowerShell).
- `tr/*.fr*.txt` : textes francais (chapitres repris de l'ancien pack + generes).
- `ids/*.json` : identifiants stables des quetes generees (NE PAS supprimer : sinon la progression des joueurs est perdue).
- `run-spec.ps1 -Names "aeronautics,twilight_forest"` : regenere des chapitres puis `fr_fr.snbt`.
- `build-lang.ps1` : reassemble `config/ftbquests/quests/lang/fr_fr.snbt` a partir de `tr/`.
- `items.txt` / `structures.txt` : objets et structures du pack (validation). A regenerer si des mods changent.

Attention : dans les textes, `&` suivi d'un espace est interdit (codes couleur FTB). Ecrire "et".