# Restaure les images decoratives des chapitres (bloc "images: [...]") depuis l'ancien pack.
# Les textures de mods absents (chalk, moonlight, fancymenu, multibeds, connectedglass, kubejs) sont copiees
# dans le resource pack config/paxi/resourcepacks/pack_lbc_quests (pack_lbc:textures/quests/...).
$q = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent (Split-Path -Parent $q)
Add-Type -AssemblyName System.IO.Compression.FileSystem
$enc = New-Object Text.UTF8Encoding($false)
$old = "C:\Users\Antho\curseforge\minecraft\Instances\Create Chronicles The Endventure"
$tex = Join-Path $root 'config\paxi\resourcepacks\pack_lbc_quests\assets\pack_lbc\textures\quests'
$present = @('minecraft', 'create', 'artifacts', 'curios', 'simplyswords')
# index des textures des mods de l'ancien pack
$jars = @{}
foreach ($j in Get-ChildItem "$old\mods" -Filter *.jar) { try { $z = [IO.Compression.ZipFile]::OpenRead($j.FullName) } catch { continue }; foreach ($e in $z.Entries) { if ($e.FullName -match '^assets/([^/]+)/textures/.+\.png$') { $jars[$e.FullName] = $j.FullName } }; $z.Dispose() }
function CopyTex($res) {
  $p = $res.Split(':', 2); $ns = $p[0]; $path = $p[1]
  if (-not $path.StartsWith('textures/')) { $path = "textures/$path" }
  if (-not $path.EndsWith('.png')) { $path = "$path.png" }
  $name = ($ns + '_' + ($path -replace '^textures/', '' -replace '\.png$', '' -replace '/', '_')) + '.png'
  $dst = Join-Path $tex $name
  $kub = Join-Path "$old\kubejs\assets\$ns" ($path -replace '/', '\')
  if (Test-Path $kub) { Copy-Item $kub $dst -Force; return "pack_lbc:textures/quests/$name" }
  $key = "assets/$ns/$path"
  if ($jars.ContainsKey($key)) { $z = [IO.Compression.ZipFile]::OpenRead($jars[$key]); $e = $z.GetEntry($key); $s = $e.Open(); $fs = [IO.File]::Create($dst); $s.CopyTo($fs); $fs.Close(); $s.Close(); $z.Dispose(); return "pack_lbc:textures/quests/$name" }
  return $null
}
foreach ($f in Get-ChildItem "$old\config\ftbquests\quests\chapters" -Filter *.snbt) {
  $mine = Join-Path $root "config\ftbquests\quests\chapters\$($f.Name)"
  if (-not (Test-Path $mine)) { continue }
  $t = [IO.File]::ReadAllText($f.FullName)
  $m = [regex]::Match($t, '(?s)\n\timages: \[(.*?)\n\t\]')
  if (-not $m.Success) { continue }
  $block = $m.Value
  $lost = 0
  $block = [regex]::Replace($block, 'image: "([^"]+)"', {
      param($x) $res = $x.Groups[1].Value; $ns = $res.Split(':')[0]
      if ($present -contains $ns) { return $x.Value }
      $n = CopyTex $res; if ($n) { return "image: `"$n`"" }; $script:lost++; return $x.Value })
  $mt = [IO.File]::ReadAllText($mine)
  if ($mt -notmatch '\n\timages: \[ \]') { "$($f.BaseName) : bloc images deja rempli, ignore"; continue }
  $mt = $mt -replace '\n\timages: \[ \]', ($block -replace '\$', '$$$$')
  [IO.File]::WriteAllText($mine, $mt, $enc)
  "{0,-28} {1} images restaurees{2}" -f $f.BaseName, ([regex]::Matches($block, 'image: "')).Count, $(if ($lost) { " ($lost texture(s) introuvable(s))" } else { '' })
}
