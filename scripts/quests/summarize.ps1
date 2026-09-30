param([string]$Chapter, [string]$Lang, [int]$DescLen = 260)
$s = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -Path "$s\Snbt.cs"
$ch = [Snbt]::Parse([IO.File]::ReadAllText($Chapter))
$L = [Snbt]::Parse([IO.File]::ReadAllText($Lang))
$map = @{}; foreach ($kv in $L) { $map[$kv.Key] = $kv.Value }
function txt($v) { if ($v -is [SL]) { ($v | % { [Snbt]::Unq($_) } | ? { $_ -ne '' -and $_ -notmatch '^\{' }) -join ' / ' } elseif ($v) { [Snbt]::Unq($v) } else { '' } }
function clean($t) { ($t -replace '&[0-9a-fk-or]', '') }
$cid = $ch.Str('id'); "CHAPITRE: " + (clean (txt $map["chapter.$cid.title"]))
$qs = @($ch.Get('quests')) | Sort-Object { [double](($_.Str('y')) -replace 'd','') }, { [double](($_.Str('x')) -replace 'd','') }
foreach ($q in $qs) {
  $id = $q.Str('id')
  $tl = @(); foreach ($t in $q.Get('tasks')) { $ty = $t.Str('type'); if (-not $ty) { $ty = 'item' }; if ($ty -eq 'item') { $it = $t.Get('item'); if ($it -is [SC]) { $tl += $it.Str('id') } else { $tl += [Snbt]::Unq($it) } } elseif ($ty -eq 'kill') { $tl += 'kill ' + $t.Str('entity') } else { $tl += $ty } }
  $rw = @(); $r = $q.Get('rewards'); if ($r) { foreach ($x in $r) { $it = $x.Get('item'); if ($it -is [SC]) { $rw += ($x.Str('count') + 'x' + $it.Str('id')) } elseif ($it) { $rw += [Snbt]::Unq($it) } else { $rw += $x.Str('type') } } }
  $d = clean (txt $map["quest.$id.quest_desc"]); if ($d.Length -gt $DescLen) { $d = $d.Substring(0, $DescLen) + '...' }
  "- [{0}] {1} | taches: {2} | recomp: {3}`n    {4}" -f (clean (txt $map["quest.$id.title"])), (clean (txt $map["quest.$id.quest_subtitle"])), ($tl -join ', '), ($rw -join ', '), $d
}
