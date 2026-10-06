# Fusionne les quetes d'un chapitre genere (spec) dans un chapitre existant importe de l'ancien pack.
# Usage : merge-into-chapter.ps1 -Source artifacts_relics -Target artifacts
# Relancable : les quetes d'une fusion precedente (ids/<Source>.json) sont retirees avant d'inserer les nouvelles.
param([string]$Source, [string]$Target)
$q = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -Path "$q\Snbt.cs"
$enc = New-Object Text.UTF8Encoding($false)
$base = Join-Path (Split-Path -Parent (Split-Path -Parent $q)) 'config\ftbquests\quests\chapters'
$src = Join-Path $base "$Source.snbt"; $dst = Join-Path $base "$Target.snbt"
$ids = (Get-Content "$q\ids\$Source.json" -Raw | ConvertFrom-Json).PSObject.Properties | ForEach-Object { $_.Value }
$s = [IO.File]::ReadAllText($src)
$a = $s.IndexOf("`tquests: [`n") + "`tquests: [`n".Length; $b = $s.LastIndexOf("`t]`n}")
$newQuests = $s.Substring($a, $b - $a).TrimEnd("`n")
$t = [IO.File]::ReadAllText($dst) -replace "`r`n", "`n"
# retirer une fusion precedente
$t = [regex]::Replace($t, '(?s)\n\t\t\{\n(?:(?!\n\t\t\}).)*?\n\t\t\}', { param($m) $id = [regex]::Match($m.Value, '\n\t\t\tid: "([0-9A-F]{16})"').Groups[1].Value; if ($ids -contains $id) { '' } else { $m.Value } })
$qi = $t.IndexOf("`n`tquests: [")
if ($qi -lt 0) { throw "quests introuvable dans $Target" }
$end = $t.IndexOf("`n`t]", $qi + 1)
$t = $t.Substring(0, $end) + "`n" + $newQuests + $t.Substring($end)
[void][Snbt]::Parse($t)
[IO.File]::WriteAllText($dst, $t, $enc)
Remove-Item $src
"$Source fusionne dans $Target"
