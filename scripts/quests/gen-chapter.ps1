param([string]$Spec)
# Generates an FTB Quests chapter + French lang fragment from a PowerShell spec file.
# Spec defines $Chapter (hashtable) and $Quests (array of hashtables).
$s = Split-Path -Parent $MyInvocation.MyCommand.Path
Add-Type -Path "$s\Snbt.cs", "$s\QConv.cs"
$enc = New-Object Text.UTF8Encoding($false)
$base = "C:\Users\Antho\curseforge\minecraft\pack_LBC\config\ftbquests\quests"
. $Spec
$file = $Chapter.file
$idFile = "$s\ids\$file.json"
New-Item -ItemType Directory -Force "$s\ids" | Out-Null
$ids = @{}
if (Test-Path $idFile) { (Get-Content $idFile -Raw | ConvertFrom-Json).PSObject.Properties | % { $ids[$_.Name] = $_.Value } }
# all ids already used elsewhere
$used = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($f in Get-ChildItem "$base\chapters", "$base\reward_tables" -Filter *.snbt) { if ($f.BaseName -eq $file) { continue }; foreach ($m in [regex]::Matches([IO.File]::ReadAllText($f.FullName), '"([0-9A-F]{16})"')) { [void]$used.Add($m.Groups[1].Value) } }
foreach ($v in $ids.Values) { [void]$used.Add($v) }
function Id($key) {
  if ($ids.ContainsKey($key)) { return $ids[$key] }
  do { $n = [QConv]::NewId() } while ($used.Contains($n))
  [void]$used.Add($n); $ids[$key] = $n; return $n
}
$items = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($l in [IO.File]::ReadAllLines("$s\items.txt")) { [void]$items.Add($l) }
$structs = New-Object 'System.Collections.Generic.HashSet[string]'
if (Test-Path "$s\structures.txt") { foreach ($l in [IO.File]::ReadAllLines("$s\structures.txt")) { [void]$structs.Add($l) } }
foreach ($v in 'ancient_city','stronghold','mansion','monument','desert_pyramid','jungle_pyramid','igloo','village_plains','pillager_outpost','bastion_remnant','fortress','end_city','trial_chambers','ruined_portal','shipwreck','buried_treasure','mineshaft','swamp_hut','trail_ruins','ocean_ruin_cold','ocean_ruin_warm') { [void]$structs.Add("minecraft:$v") }
function Num($v) { ('{0}d' -f [double]$v).Replace(',', '.') }
function Esc($t) { $t.Replace('\', '\\').Replace('"', '\"') }
$tiers = @{ commune = 0; rare = 1; epique = 2; legendaire = 3 }
$warn = @()
$sb = New-Object Text.StringBuilder
$lang = New-Object Text.StringBuilder
$cid = Id 'chapter'
[void]$lang.AppendLine("chapter.$($cid).title: `"$(Esc $Chapter.title)`"")
if ($Chapter.subtitle) { [void]$lang.AppendLine("chapter.$($cid).chapter_subtitle: [`n  `"$(Esc $Chapter.subtitle)`"`n]") }
[void]$sb.Append("{`n`tdefault_hide_dependency_lines: false`n`tdefault_quest_shape: `"`"`n`tfilename: `"$file`"`n`tgroup: `"$($Chapter.group)`"`n`ticon: {`n`t`tid: `"$($Chapter.icon)`"`n`t}`n`tid: `"$cid`"`n`torder_index: $($Chapter.order)`n`tprogression_mode: `"flexible`"`n`tquest_links: [ ]`n`tquests: [`n")
if (-not $items.Contains($Chapter.icon)) { $warn += "icone chapitre inconnue: $($Chapter.icon)" }
foreach ($q in $Quests) {
  $qid = Id $q.k
  [void]$sb.Append("`t`t{`n")
  if ($q.deps) { $dl = ($q.deps | % { "`"$(Id $_)`"" }) -join ', '; [void]$sb.Append("`t`t`tdependencies: [$dl]`n") }
  if ($q.minDeps) { [void]$sb.Append("`t`t`tmin_required_dependencies: $($q.minDeps)`n") }
  if ($q.hideLines) { [void]$sb.Append("`t`t`thide_dependency_lines: true`n") }
  if ($q.icon) { [void]$sb.Append("`t`t`ticon: {`n`t`t`t`tid: `"$($q.icon)`"`n`t`t`t}`n"); if (-not $items.Contains($q.icon)) { $warn += "icone inconnue ($($q.k)): $($q.icon)" } }
  [void]$sb.Append("`t`t`tid: `"$qid`"`n")
  if ($q.optional) { [void]$sb.Append("`t`t`toptional: true`n") }
  # rewards
  $rw = @()
  if ($q.crate) { $rw += "`t`t`t`t{`n`t`t`t`t`tid: `"$(Id ($q.k + '#crate'))`"`n`t`t`t`t`titem: {`n`t`t`t`t`t`tcomponents: {`n`t`t`t`t`t`t`t`"ftbquests:loot_crate`": `"$($q.crate)`"`n`t`t`t`t`t`t}`n`t`t`t`t`t`tcount: 1`n`t`t`t`t`t`tid: `"ftbquests:lootcrate`"`n`t`t`t`t`t}`n`t`t`t`t`ttype: `"item`"`n`t`t`t`t}" }
  $ri = 0
  foreach ($r in @($q.give)) { if (-not $r) { continue }; $p = $r.Split('*'); $cnt = if ($p.Count -gt 1) { $p[1] } else { 1 }; if (-not $items.Contains($p[0])) { $warn += "recompense inconnue ($($q.k)): $($p[0])" }; $rw += "`t`t`t`t{`n`t`t`t`t`tcount: $cnt`n`t`t`t`t`tid: `"$(Id ($q.k + '#give' + $ri))`"`n`t`t`t`t`titem: {`n`t`t`t`t`t`tcount: 1`n`t`t`t`t`t`tid: `"$($p[0])`"`n`t`t`t`t`t}`n`t`t`t`t`ttype: `"item`"`n`t`t`t`t}"; $ri++ }
  if ($q.xp) { $rw += "`t`t`t`t{`n`t`t`t`t`tid: `"$(Id ($q.k + '#xp'))`"`n`t`t`t`t`ttype: `"xp`"`n`t`t`t`t`txp: $($q.xp)`n`t`t`t`t}" }
  if ($rw.Count) { [void]$sb.Append("`t`t`trewards: [`n" + ($rw -join "`n") + "`n`t`t`t]`n") }
  if ($q.shape) { [void]$sb.Append("`t`t`tshape: `"$($q.shape)`"`n") }
  if ($q.size) { [void]$sb.Append("`t`t`tsize: $(Num $q.size)`n") }
  # tasks
  $tk = @(); $ti = 0
  if ($q.anyOf) { [void]$sb.Append('') }
  foreach ($t in @($q.tasks)) {
    $tidd = Id ($q.k + '#t' + $ti); $ti++
    if ($t -eq '@check') { $tk += "`t`t`t`t{`n`t`t`t`t`tid: `"$tidd`"`n`t`t`t`t`ttype: `"checkmark`"`n`t`t`t`t}" }
    elseif ($t -like 'kill:*') { $e = $t.Substring(5); $tk += "`t`t`t`t{`n`t`t`t`t`tentity: `"$e`"`n`t`t`t`t`tid: `"$tidd`"`n`t`t`t`t`ttype: `"kill`"`n`t`t`t`t`tvalue: 1L`n`t`t`t`t}" }
    elseif ($t -like 'struct:*') { $e = $t.Substring(7); if (-not $e.StartsWith('#') -and -not $structs.Contains($e)) { $warn += "structure inconnue ($($q.k)): $e" }; $tk += "`t`t`t`t{`n`t`t`t`t`tid: `"$tidd`"`n`t`t`t`t`tstructure: `"$e`"`n`t`t`t`t`ttype: `"structure`"`n`t`t`t`t}" }
    elseif ($t -like 'dim:*') { $e = $t.Substring(4); $tk += "`t`t`t`t{`n`t`t`t`t`tdimension: `"$e`"`n`t`t`t`t`tid: `"$tidd`"`n`t`t`t`t`ttype: `"dimension`"`n`t`t`t`t}" }
    elseif ($t -like 'adv:*') { $e = $t.Substring(4); $tk += "`t`t`t`t{`n`t`t`t`t`tadvancement: `"$e`"`n`t`t`t`t`tcriterion: `"`"`n`t`t`t`t`tid: `"$tidd`"`n`t`t`t`t`ttype: `"advancement`"`n`t`t`t`t}" }
    else { $p = $t.Split('*'); $cnt = if ($p.Count -gt 1) { $p[1] } else { 1 }; if (-not $items.Contains($p[0])) { $warn += "tache inconnue ($($q.k)): $($p[0])" }; $tk += "`t`t`t`t{`n`t`t`t`t`tcount: $($cnt)L`n`t`t`t`t`tid: `"$tidd`"`n`t`t`t`t`titem: { count: 1, id: `"$($p[0])`" }`n`t`t`t`t`ttype: `"item`"`n`t`t`t`t}" }
  }
  [void]$sb.Append("`t`t`ttasks: [`n" + ($tk -join "`n") + "`n`t`t`t]`n")
  [void]$sb.Append("`t`t`tx: $(Num $q.x)`n`t`t`ty: $(Num $q.y)`n`t`t}`n")
  # lang
  if ($q.t) { [void]$lang.AppendLine("quest.$($qid).title: `"$(Esc $q.t)`"") }
  if ($q.st) { [void]$lang.AppendLine("quest.$($qid).quest_subtitle: `"$(Esc $q.st)`"") }
  if ($q.d) { [void]$lang.AppendLine("quest.$($qid).quest_desc: ["); foreach ($l in $q.d) { [void]$lang.AppendLine("  `"$(Esc $l)`"") }; [void]$lang.AppendLine("]") }
  if ($q.checkTitle) { [void]$lang.AppendLine("task.$(Id ($q.k + '#t0')).title: `"$(Esc $q.checkTitle)`"") }
}
[void]$sb.Append("`t]`n}`n")
$out = "$base\chapters\$file.snbt"
[IO.File]::WriteAllText($out, $sb.ToString(), $enc)
[void][Snbt]::Parse([IO.File]::ReadAllText($out))
[IO.File]::WriteAllText("$s\tr\$file.fr.txt", $lang.ToString(), $enc)
($ids | ConvertTo-Json) | Out-File $idFile -Encoding utf8
"chapitre $file : $($Quests.Count) quetes, id $cid"
$warn | % { "ATTENTION: $_" }
