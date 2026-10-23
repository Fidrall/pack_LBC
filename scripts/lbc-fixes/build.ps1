# Compile le mod de correctifs lbcfixes et ecrit mods/lbcfixes-<version>.jar (jar brut du pack, comme Maps 3D).
# Classpath : bibliotheques Prism (Minecraft 1.21.1 en noms Mojang, NeoForge, Mixin) + jars des mods vises
# pris dans une instance (par defaut pack_LBC-dev). JDK : celui de Prism (java-runtime-delta).
param(
    [string]$Instance = "$env:APPDATA\PrismLauncher\instances\pack_LBC-dev\.minecraft",
    [string]$Jdk = "$env:APPDATA\PrismLauncher\java\java-runtime-delta",
    [string]$Version = '1.0.5'
)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$root = Split-Path (Split-Path $here -Parent) -Parent
$lib = "$env:APPDATA\PrismLauncher\libraries"
$work = Join-Path $env:TEMP 'lbcfixes-build'
if (Test-Path $work) { Remove-Item $work -Recurse -Force }
New-Item -ItemType Directory -Force "$work\classes" | Out-Null

# MixinExtras : livre dans NeoForge (jar-in-jar)
Add-Type -AssemblyName System.IO.Compression.FileSystem
$universal = Get-ChildItem $lib -Recurse -File -Filter 'neoforge-21.1.*-universal.jar' | Select-Object -First 1
$z = [IO.Compression.ZipFile]::OpenRead($universal.FullName)
$mx = $z.Entries | Where-Object { $_.FullName -match '^META-INF/jarjar/mixinextras-neoforge-.*\.jar$' } | Select-Object -First 1
[IO.Compression.ZipFileExtensions]::ExtractToFile($mx, "$work\mixinextras.jar", $true)
$z.Dispose()

# Le premier jar qui contient une classe gagne : d'abord neoforge-*-client.jar (classes patchees par NeoForge, noms Mojang),
# puis client-*-srg.jar (le reste de Minecraft en noms Mojang). Sans le jar obfusque ni le slim.
$jars = @(Get-ChildItem $lib -Recurse -File -Filter *.jar | Where-Object { $_.FullName -notmatch 'installer|\\com\\mojang\\minecraft\\|-slim\.jar$' } | ForEach-Object FullName)
$cp = @($jars | Where-Object { $_ -match '\\neoforge-[^\\]+-client\.jar$' }) + @($jars | Where-Object { $_ -notmatch '\\neoforge-[^\\]+-client\.jar$' })
$cp += "$work\mixinextras.jar"
foreach ($p in 'wyrmroost-*.jar', 'ftb-chunks-*.jar', 'ftb-library-*.jar', 'somakespells-*.jar', 'infested_swarms_spiders-*.jar', 'Apotheosis-*.jar') {
    $j = Get-ChildItem "$Instance\mods" -Filter $p | Select-Object -First 1
    if (-not $j) { throw "Jar introuvable dans l'instance : $p" }
    $cp += $j.FullName
}
[IO.File]::WriteAllText("$work\cp.txt", ($cp -join [IO.Path]::PathSeparator))

$src = @(Get-ChildItem "$here\src\main\java" -Recurse -File -Filter *.java | ForEach-Object { '"' + $_.FullName.Replace('\', '/') + '"' })
[IO.File]::WriteAllText("$work\sources.txt", ($src -join "`n"))
$cpArg = '"' + ((Get-Content "$work\cp.txt" -Raw).Replace('\', '/')) + '"'
[IO.File]::WriteAllText("$work\args.txt", "--release 21 -proc:none -encoding UTF-8 -nowarn -d `"$($work.Replace('\','/'))/classes`" -cp $cpArg")

& "$Jdk\bin\javac.exe" "@$work\args.txt" "@$work\sources.txt"
if ($LASTEXITCODE -ne 0) { throw "javac a echoue ($LASTEXITCODE)" }

Copy-Item "$here\src\main\resources\*" "$work\classes" -Recurse -Force
$toml = Join-Path "$work\classes" 'META-INF\neoforge.mods.toml'
(Get-Content $toml -Raw) -creplace '(?m)^version = "[^"]*"', "version = `"$Version`"" | Set-Content $toml -NoNewline -Encoding ascii

$out = Join-Path $root "mods\lbcfixes-$Version.jar"
Get-ChildItem (Join-Path $root 'mods') -Filter 'lbcfixes-*.jar' | Remove-Item -Force
& "$Jdk\bin\jar.exe" --create --file $out -C "$work\classes" .
if ($LASTEXITCODE -ne 0) { throw "jar a echoue ($LASTEXITCODE)" }
Write-Host "OK : $out ($([Math]::Round((Get-Item $out).Length / 1KB)) Ko)"
