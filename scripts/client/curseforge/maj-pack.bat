@echo off
setlocal
rem ==================================================================
rem  pack_LBC - installation / mise a jour pour un profil CurseForge
rem  A placer dans le dossier du profil (celui qui contient "mods").
rem  A lancer avant de jouer (premiere installation comprise).
rem ==================================================================
title Mise a jour pack_LBC
cd /d "%~dp0"
set "PACK_URL=https://raw.githubusercontent.com/Fidrall/pack_LBC/main/pack.toml"
set "BOOT=packwiz-installer-bootstrap.jar"
set "BOOT_URL=https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar"

rem --- Java 21 : celui de CurseForge (dossier Install a cote de Instances), sinon celui du PC
set "JAVA="
for %%J in (
  "%~dp0..\..\Install\java\java-runtime-delta\bin\java.exe"
  "%~dp0..\..\Install\java\Jre_21\bin\java.exe"
  "%USERPROFILE%\curseforge\minecraft\Install\java\java-runtime-delta\bin\java.exe"
  "%USERPROFILE%\curseforge\minecraft\Install\java\Jre_21\bin\java.exe"
) do if not defined JAVA if exist %%J set "JAVA=%%~J"
if not defined JAVA (
  where java >nul 2>nul && set "JAVA=java"
)
if not defined JAVA (
  echo [ERREUR] Java introuvable. Lance une premiere fois le profil depuis CurseForge
  echo          ^(il telecharge Java^), ferme le jeu, puis relance ce fichier.
  pause
  exit /b 1
)
echo Java : %JAVA%

rem --- Installateur packwiz (telecharge une seule fois)
if not exist "%BOOT%" (
  echo Telechargement de l'installateur...
  curl -sL -o "%BOOT%" "%BOOT_URL%" || powershell -NoProfile -Command "Invoke-WebRequest '%BOOT_URL%' -OutFile '%BOOT%' -UseBasicParsing"
)
if not exist "%BOOT%" (
  echo [ERREUR] Impossible de telecharger l'installateur. Verifie la connexion internet.
  pause
  exit /b 1
)
if /i "%~1"=="test" (
  echo Test OK : Java et installateur trouves, installation non lancee.
  goto :fin
)

rem --- Synchronisation : mods, configs, quetes, packs de ressources
echo Mise a jour du pack en cours ^(la premiere fois peut prendre plusieurs minutes^)...
"%JAVA%" -jar "%BOOT%" -s client "%PACK_URL%"
if errorlevel 1 (
  echo [ERREUR] La mise a jour a echoue. Relance ce fichier ; si ca persiste, envoie une capture.
  pause
  exit /b 1
)
echo.
echo Pack a jour. Tu peux lancer le profil depuis CurseForge.
:fin
pause
