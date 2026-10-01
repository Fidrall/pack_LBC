# Genere les fichiers serveur pour MineStrator (sans Java) :
#   build\server\          -> dossier a synchroniser en SFTP (mods\, server.properties, ...)
#   build\pack_LBC-server.zip -> la meme chose en zip (pour le WebSFTP du panel)
# NeoForge lui-meme s'installe depuis le panel MineStrator (version lue dans pack.toml).
# Relancer apres chaque mise a jour du pack : seuls les mods modifies sont retelecharges,
# et les mods retires du pack sont supprimes de build\server\mods.
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$root = Split-Path $PSScriptRoot -Parent
$out  = Join-Path $root "build\server"
$mods = Join-Path $out "mods"
New-Item -ItemType Directory -Force $mods | Out-Null

function Get-Hash($path, $fmt) {
    $algo = @{ sha1 = "SHA1"; sha256 = "SHA256"; sha512 = "SHA512" }[$fmt]
    (Get-FileHash -LiteralPath $path -Algorithm $algo).Hash.ToLower()
}

$wanted = @()
$failed = @()
foreach ($f in Get-ChildItem (Join-Path $root "mods") -Filter *.pw.toml) {
    $t = Get-Content $f.FullName -Raw
    $side = [regex]::Match($t, 'side = "([^"]+)"').Groups[1].Value
    if ($side -eq "client") { continue }
    $name = [regex]::Match($t, '(?m)^filename = "([^"]+)"').Groups[1].Value
    $fmt  = [regex]::Match($t, 'hash-format = "([^"]+)"').Groups[1].Value
    $hash = [regex]::Match($t, '(?m)^hash = "([^"]+)"').Groups[1].Value
    $url  = [regex]::Match($t, '(?m)^url = "([^"]+)"').Groups[1].Value
    $wanted += $name
    $dest = Join-Path $mods $name

    if ((Test-Path -LiteralPath $dest) -and ((Get-Hash $dest $fmt) -eq $hash)) { continue }

    $urls = @()
    if ($url) { $urls += $url }
    else {
        $fid = [int][regex]::Match($t, 'file-id = (\d+)').Groups[1].Value
        $enc = [uri]::EscapeDataString($name)
        $urls += "https://mediafilez.forgecdn.net/files/$([math]::Floor($fid / 1000))/$($fid % 1000)/$enc"
        $urls += "https://edge.forgecdn.net/files/$([math]::Floor($fid / 1000))/$($fid % 1000)/$enc"
    }
    $ok = $false
    foreach ($u in $urls) {
        try {
            # -OutFile ne gere pas les [ ] dans les noms : on passe par un fichier temporaire
            $tmp = Join-Path $mods "download.tmp"
            Invoke-WebRequest $u -OutFile $tmp -UseBasicParsing
            if ((Get-Hash $tmp $fmt) -eq $hash) { Move-Item -LiteralPath $tmp $dest -Force; $ok = $true; break }
            Remove-Item $tmp -ErrorAction SilentlyContinue
        } catch { }
    }
    if ($ok) { Write-Host "  + $name" } else { $failed += $name; Remove-Item -LiteralPath $dest -ErrorAction SilentlyContinue }
}

# Supprimer les mods qui ne font plus partie du pack
Get-ChildItem $mods -Filter *.jar | Where-Object { $wanted -notcontains $_.Name } | ForEach-Object {
    Write-Host "  - $($_.Name)"; Remove-Item -LiteralPath $_.FullName
}

# Configs du pack (si presentes) + reglages serveur
foreach ($d in "config", "defaultconfigs") {
    $src = Join-Path $root $d
    if (Test-Path $src) { Copy-Item $src $out -Recurse -Force }
}
$srv = Join-Path $PSScriptRoot "server"
Copy-Item (Join-Path $srv "server.properties") $out -Force
Copy-Item (Join-Path $srv "user_jvm_args.txt") $out -Force

$zip = Join-Path $root "build\pack_LBC-server.zip"
if (Test-Path $zip) { Remove-Item $zip }
# Zip avec des chemins en "/" (Compress-Archive de PS 5.1 met des "\" que Linux ne comprend pas)
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$za = [IO.Compression.ZipFile]::Open($zip, 'Create')
$outFull = (Resolve-Path $out).Path.TrimEnd('\')
foreach ($file in Get-ChildItem $out -Recurse -File) {
    $entry = $file.FullName.Substring($outFull.Length + 1).Replace('\', '/')
    [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($za, $file.FullName, $entry, 'Optimal')
}
$za.Dispose()

$neo = [regex]::Match((Get-Content (Join-Path $root "pack.toml") -Raw), 'neoforge = "([^"]+)"').Groups[1].Value
Write-Host ""
Write-Host "Mods serveur : $((Get-ChildItem $mods -Filter *.jar).Count)   (NeoForge a installer : $neo)"
Write-Host "Dossier : $out"
Write-Host "Zip     : $zip ($([math]::Round((Get-Item $zip).Length / 1MB)) Mo)"
if ($failed.Count) { Write-Host "ECHECS ($($failed.Count)) :"; $failed | ForEach-Object { Write-Host "  $_" }; exit 1 }
