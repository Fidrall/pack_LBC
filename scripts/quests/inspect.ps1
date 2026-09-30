param([string]$Chapter)
$s = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -Path "$s\Snbt.cs"
$base = "C:\Users\Antho\curseforge\minecraft\pack_LBC\config\ftbquests\quests"
$ch = [Snbt]::Parse([IO.File]::ReadAllText("$base\chapters\$Chapter.snbt"))
$lang = [IO.File]::ReadAllText("$base\lang\fr_fr.snbt")
foreach ($q in $ch.Get('quests')) {
  $id = $q.Str('id')
  $title = [regex]::Match($lang, "quest\.$id\.title: `"([^`"]*)`"").Groups[1].Value
  $sub = [regex]::Match($lang, "quest\.$id\.quest_subtitle: `"([^`"]*)`"").Groups[1].Value
  $tl = @()
  foreach ($t in $q.Get('tasks')) {
    $ty = $t.Str('type'); if (-not $ty) { $ty = 'item' }
    if ($ty -eq 'item') { $it = $t.Get('item'); if ($it -is [SC]) { $tl += 'item:' + $it.Str('id') } else { $tl += 'item:' + [Snbt]::Unq($it) } }
    elseif ($ty -eq 'kill') { $tl += 'kill:' + $t.Str('entity') }
    else { $tl += $ty }
  }
  $deps = @(); $d = $q.Get('dependencies'); if ($d) { foreach ($x in $d) { $deps += ([Snbt]::Unq($x)).Substring(0,6) } }
  $rw = @(); $r = $q.Get('rewards'); if ($r) { foreach ($x in $r) { $it = $x.Get('item'); if ($it -is [SC]) { $c = $it.Get('components'); if ($c) { $rw += 'caisse:' + $c.Str('ftbquests:loot_crate') } else { $rw += $it.Str('id') } } else { $rw += $x.Str('type') } } }
  "{0} x={1,-6} y={2,-6} | {3} {4} | T[{5}] | D[{6}] | R[{7}]" -f $id.Substring(0,6), $q.Str('x'), $q.Str('y'), $title, $sub, ($tl -join ','), ($deps -join ','), ($rw -join ',')
}
