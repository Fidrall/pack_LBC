# Restaure les images des quetes de l'ancien pack (chargees autrefois par KubeJS)
# -> resource pack config/paxi/resourcepacks/pack_lbc_quests (charge par Paxi)
# -> re-insere les balises {image:...} dans les textes francais (tr/*.fr*.txt)
$q = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent (Split-Path -Parent $q)
Add-Type -Path "$q\Snbt.cs"
$enc = New-Object Text.UTF8Encoding($false)
$old = "C:\Users\Antho\curseforge\minecraft\Instances\Create Chronicles The Endventure"
$rp = Join-Path $root 'config\paxi\resourcepacks\pack_lbc_quests'
$tex = "$rp\assets\pack_lbc\textures\quests"
New-Item -ItemType Directory -Force $tex | Out-Null
[IO.File]::WriteAllText("$rp\pack.mcmeta", '{ "pack": { "pack_format": 34, "description": "Images des quetes" } }', $enc)

$lang = [Snbt]::Parse([IO.File]::ReadAllText("$old\config\ftbquests\quests\lang\en_us.snbt"))
$copied = @{}
function MapImg([string]$res) {
  $parts = $res.Split(':', 2); $ns = $parts[0]; $path = $parts[1]
  if ($ns -ne 'kubejs') { return $null }
  if (-not $path.StartsWith('textures/')) { $path = "textures/$path.png" }
  $src = Join-Path "$old\kubejs\assets\kubejs" ($path -replace '/', '\')
  if (-not (Test-Path $src)) { return $null }
  $name = ($path -replace '^textures/', '' -replace '/', '_')
  Copy-Item $src "$tex\$name" -Force
  $copied[$name] = 1
  return "pack_lbc:textures/quests/$name"
}
$frFiles = Get-ChildItem "$q\tr" -Filter '*.fr*.txt'
$frText = @{}; foreach ($f in $frFiles) { $frText[$f.FullName] = [IO.File]::ReadAllText($f.FullName, [Text.Encoding]::UTF8) }
$done = 0
foreach ($kv in $lang) {
  if ($kv.Key -notmatch '^quest\.([0-9A-F]{16})\.quest_desc$') { continue }
  if (-not ($kv.Value -is [SL])) { continue }
  $qid = $matches[1]
  $lines = New-Object System.Collections.Generic.List[string]
  foreach ($x in $kv.Value) { $lines.Add([Snbt]::Unq([string]$x)) }
  if (-not ($lines | Where-Object { $_ -match '\{image:kubejs' })) { continue }
  # fragment francais de cette quete
  $target = $null; foreach ($p in $frText.Keys) { if ($frText[$p].Contains("quest.$qid.quest_desc: [")) { $target = $p; break } }
  if (-not $target) { continue }
  # images par section ({@pagebreak})
  $secs = New-Object System.Collections.Generic.List[object]
  $secs.Add((New-Object System.Collections.Generic.List[string]))
  foreach ($l in $lines) {
    if ($l -eq '{@pagebreak}') { $secs.Add((New-Object System.Collections.Generic.List[string])); continue }
    $m = [regex]::Match($l, '\{image:([^ }]+)([^}]*)\}')
    if ($m.Success) { $new = MapImg $m.Groups[1].Value; if ($new) { $secs[$secs.Count - 1].Add('{image:' + $new + $m.Groups[2].Value + '}') } }
  }
  $t = $frText[$target]; $key = "quest.$qid.quest_desc: ["
  $i = $t.IndexOf($key); $j = $t.IndexOf("`n]", $i)
  $body = $t.Substring($i + $key.Length, $j - $i - $key.Length)
  if ($body.Contains('{image:')) { continue }
  $frLines = @($body -split "`r?`n" | Where-Object { $_.Trim() -ne '' } | ForEach-Object { $_.Trim() })
  $out = New-Object System.Collections.Generic.List[string]; $si = 0
  foreach ($fl in $frLines) {
    if ($fl -eq '"{@pagebreak}"' -and $si -lt $secs.Count) { foreach ($im in $secs[$si]) { $out.Add('""'); $out.Add('"' + $im + '"') }; $si++ }
    $out.Add($fl)
  }
  while ($si -lt $secs.Count) { foreach ($im in $secs[$si]) { $out.Add('""'); $out.Add('"' + $im + '"') }; $si++ }
  $frText[$target] = $t.Substring(0, $i + $key.Length) + "`n" + (($out | ForEach-Object { "  $_" }) -join "`n") + $t.Substring($j)
  $done++
}
foreach ($p in $frText.Keys) { [IO.File]::WriteAllText($p, $frText[$p], $enc) }
"quetes avec images restaurees: $done ; images copiees: $($copied.Count)"
$copied.Keys | Sort-Object
