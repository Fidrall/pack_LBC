# pack_LBC

Pack Create + exploration pour serveur multijoueur éternel.
Minecraft **1.21.1** · NeoForge **21.1.252** · géré avec [packwiz](https://packwiz.infra.link).

## Joueurs : installation (une seule fois)

1. Installer [Prism Launcher](https://prismlauncher.org) et y connecter son compte Microsoft.
2. Dans Prism : **Ajouter une instance → Importer** → choisir `pack_LBC-prism.zip`.
3. Lancer l'instance. Au premier lancement, les mods se téléchargent (quelques minutes).

Ensuite, chaque lancement met le pack à jour automatiquement.
RAM conseillée : 6 à 8 Go (Prism : Modifier l'instance → Paramètres → Mémoire).

## Règles de construction

- **conserver** (voir `modlist.txt`) : Create, ses addons, le vanilla. On peut construire avec.
- **jetable** : boss, mobs, dimensions. On en profite, mais pas de base construite avec leurs blocs,
  et on ne s'installe pas dans leurs dimensions : ils peuvent disparaître lors d'un changement de version.

## Mainteneur

| Action | Commande (depuis ce dossier) |
|---|---|
| Ajouter un mod Modrinth | `..\tools\packwiz.exe mr add <slug>` puis l'ajouter dans `modlist.txt` |
| Ajouter un mod CurseForge | `..\tools\packwiz.exe cf add --addon-id <id>` |
| Retirer un mod | `..\tools\packwiz.exe remove <nom>` (⚠ jamais un mod « conserver » sur un monde existant) |
| Mettre à jour les mods | `..\tools\packwiz.exe update --all` (Sodium, Iris, Reese's et Terralith sont figés) |
| Tester en local | `..\tools\packwiz.exe serve` + instance `pack_LBC-prism-test.zip` |
| Générer le pack serveur | `.\scripts\build-server.ps1` → `build\server` |
| Générer le zip Prism | `.\scripts\build-prism-instance.ps1` |

Après chaque modification : incrémenter `version` dans `pack.toml`, commit + push.
Les joueurs sont mis à jour au prochain lancement ; le serveur après `build-server.ps1` + synchro WinSCP + redémarrage.

**Toujours** faire une sauvegarde du monde avant une mise à jour, et tester les grosses mises à jour sur une copie.
