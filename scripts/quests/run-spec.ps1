param([string]$Names)
$s = Split-Path -Parent $MyInvocation.MyCommand.Path
foreach ($n in $Names.Split(',')) {
  $f = "$s\specs\$n.ps1"
  $t = [IO.File]::ReadAllText($f, [Text.Encoding]::UTF8)
  [IO.File]::WriteAllText($f, $t, (New-Object Text.UTF8Encoding($true)))
  powershell -ExecutionPolicy Bypass -File "$s\gen-chapter.ps1" -Spec $f
}
powershell -ExecutionPolicy Bypass -File "$s\build-lang.ps1"
