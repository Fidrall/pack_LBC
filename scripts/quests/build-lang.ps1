$s = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -Path "$s\Snbt.cs"
$enc = New-Object Text.UTF8Encoding($false)
$base = "C:\Users\Antho\curseforge\minecraft\pack_LBC\config\ftbquests\quests"
function readFrag($path) {
  $d = [ordered]@{}; $lines = [IO.File]::ReadAllLines($path, [Text.Encoding]::UTF8); $i = 0
  while ($i -lt $lines.Count) {
    $l = $lines[$i].Trim(); if ($l -eq '') { $i++; continue }
    $m = [regex]::Match($l, '^([a-z_]+\.[0-9A-F]{16}\.[a-z_]+):\s*(.*)$')
    if (-not $m.Success) { throw "Ligne invalide ($path #$($i+1)): $l" }
    $k = $m.Groups[1].Value; $v = $m.Groups[2].Value
    if ($v -eq '[') { $arr = @(); $i++; while ($lines[$i].Trim() -ne ']') { $arr += $lines[$i].Trim(); $i++ }; $d[$k] = , $arr } else { $d[$k] = $v }
    $i++
  }
  $d
}
$fr = [ordered]@{}
foreach ($f in Get-ChildItem "$s\tr" -Filter '*.fr*.txt') { $d = readFrag $f.FullName; foreach ($k in $d.Keys) { if ($fr.Contains($k)) { "DOUBLON $k ($($f.Name))" }; $fr[$k] = $d[$k] } }
# ids present in chapters/reward tables
$ids = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($f in Get-ChildItem "$base\chapters", "$base\reward_tables" -Filter *.snbt) { foreach ($m in [regex]::Matches([IO.File]::ReadAllText($f.FullName), 'id: "([0-9A-F]{16})"')) { [void]$ids.Add($m.Groups[1].Value) } }
foreach ($l in [IO.File]::ReadAllLines("$base\chapter_groups.snbt")) { $m = [regex]::Match($l, '"([0-9A-F]{16})"'); if ($m.Success) { [void]$ids.Add($m.Groups[1].Value) } }
$sb = New-Object Text.StringBuilder
[void]$sb.Append("{`n`tfile.0000000000000001.title: `"&6&lpack_LBC`"`n")
foreach ($l in [IO.File]::ReadAllLines("$s\tr\_groups.lang.txt", [Text.Encoding]::UTF8) + [IO.File]::ReadAllLines("$s\tr\_reward_tables.lang.txt", [Text.Encoding]::UTF8)) { [void]$sb.Append("$l`n") }
$orphans = 0
foreach ($k in ($fr.Keys | Sort-Object)) {
  $id = $k.Split('.')[1]; if (-not $ids.Contains($id)) { $orphans++; continue }
  $v = $fr[$k]
  if ($v -is [array]) { [void]$sb.Append("`t$($k): [`n"); foreach ($x in $v) { foreach ($y in @($x)) { [void]$sb.Append("`t`t$y`n") } }; [void]$sb.Append("`t]`n") }
  else { [void]$sb.Append("`t$($k): $v`n") }
}
[void]$sb.Append("}`n")
$out = "$base\lang\fr_fr.snbt"
[IO.File]::WriteAllText($out, $sb.ToString(), $enc)
$p = [Snbt]::Parse([IO.File]::ReadAllText($out))
$bad = Select-String $out -Pattern '&(?![0-9a-fk-orA-FK-OR#\\])'; if ($bad) { "Esperluette invalide:"; $bad | % { $_.Line.Trim() } }
"fr_fr.snbt: $($p.Count) entrees ($orphans cles orphelines ignorees)"
