@echo off
setlocal EnableDelayedExpansion
call :isAdmin
if %errorlevel% neq 0 (goto :UACPrompt)

:run
title SpacziBOX V2
color 0F
goto intro

:intro
cls
echo.
echo   SPACZIBOX V2
echo   ---------------------------
echo   Inicjalizacja...
timeout /t 2 /nobreak >nul
goto begin

:begin
title SpacziBOX - Menu Glowne
color 0F
cls
echo.
echo   M E N U  G L O W N E
echo   ----------------------------------------
echo   [1] Narzedzia Chris Titus (WinUtil)
echo   [2] Sprawdz Winget
echo   [3] Szybki Konfigurator Programow
echo   [4] Wyjscie
echo   ----------------------------------------
echo.
choice /C 1234 /M "  Wybierz opcje: "
if errorlevel 4 goto end
if errorlevel 3 goto configuratorstart
if errorlevel 2 goto wingetinstall
if errorlevel 1 goto christoolbox

:christoolbox
color 09
powershell.exe -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm https://christitus.com/win | iex"
goto begin

:wingetinstall
color 0B
cls
echo.
echo   [*] Szybkie sprawdzenie i odswiezenie zrodel Winget...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "if (Get-Command winget -ErrorAction SilentlyContinue) { Write-Host 'Winget jest obecny w systemie. Aktualizowanie zrodel...'; winget source update } else { Write-Host 'Brak Wingeta! Zainstaluj App Installer ze sklepu Microsoft Store.'; }"
echo.
echo   [!] Gotowe.
echo   Powrot do menu...
timeout /t 2 >nul
goto begin

:configuratorstart
set "BROWSER=" & set "BROWSER_ID=" & set "ZIP=" & set "ZIP_ID=" & set "PIC=" & set "PIC_ID="
set "MESS_S=" & set "MESS_SHOW="
set "PLAY_S=" & set "PLAY_SHOW="
set "GAME_S=" & set "GAME_SHOW="
set "EXTR_S=" & set "EXTR_SHOW="

:c_1
cls
echo.
echo   [ KROK 1/7 ] PRZEGLADARKA
echo   ----------------------------------------
echo   [1] Firefox  [2] Firefox-ESR  [3] LibreWolf  [4] Helium  [5] Pomin
echo.
choice /C 12345 /M "  Wybor: "
if errorlevel 5 goto c_2
if errorlevel 4 set "BROWSER=[Helium]" & set "BROWSER_ID=ImputNet.Helium"
if errorlevel 3 set "BROWSER=[LibreWolf]" & set "BROWSER_ID=LibreWolf.LibreWolf"
if errorlevel 2 set "BROWSER=[Firefox-ESR]" & set "BROWSER_ID=Mozilla.Firefox.ESR"
if errorlevel 1 set "BROWSER=[Firefox]" & set "BROWSER_ID=Mozilla.Firefox"

:c_2
cls
echo.
echo   [ KROK 2/7 ] ARCHIWIZATOR
echo   ----------------------------------------
echo   [1] 7-Zip  [2] WinRAR  [3] Pomin
echo.
choice /C 123 /M "  Wybor: "
if errorlevel 3 goto c_3
if errorlevel 2 set "ZIP=[WinRAR]" & set "ZIP_ID=RARLab.WinRAR"
if errorlevel 1 set "ZIP=[7-Zip]" & set "ZIP_ID=7zip.7zip"

:c_3
cls
echo.
echo   [ KROK 3/7 ] KOMUNIKATORY
echo   ----------------------------------------
echo   Wybrano: %MESS_SHOW%
echo.
echo   [1] Discord [2] TS3 [3] Messenger (Next) [4] Dalej
echo.
choice /C 1234 /M "  Dodaj: "
if errorlevel 4 goto c_4
if errorlevel 3 echo %MESS_SHOW% | find "[Messenger]" >nul && goto c_3 || (set "MESS_S=%MESS_S% Rozsazoltan.MessengerNext" & set "MESS_SHOW=%MESS_SHOW% [Messenger]" & goto c_3)
if errorlevel 2 echo %MESS_SHOW% | find "[TeamSpeak]" >nul && goto c_3 || (set "MESS_S=%MESS_S% TeamSpeakSystems.TeamSpeakClient" & set "MESS_SHOW=%MESS_SHOW% [TeamSpeak]" & goto c_3)
if errorlevel 1 echo %MESS_SHOW% | find "[Discord]" >nul && goto c_3 || (set "MESS_S=%MESS_S% Discord.Discord" & set "MESS_SHOW=%MESS_SHOW% [Discord]" & goto c_3)

:c_4
cls
echo.
echo   [ KROK 4/7 ] MULTIMEDIA
echo   ----------------------------------------
echo   Wybrano: %PLAY_SHOW%
echo.
echo   [1] VLC [2] Spotify [3] Dalej
echo.
choice /C 123 /M "  Dodaj: "
if errorlevel 3 goto c_5
if errorlevel 2 echo %PLAY_SHOW% | find "[Spotify]" >nul && goto c_4 || (set "PLAY_S=%PLAY_S% Spotify.Spotify" & set "PLAY_SHOW=%PLAY_SHOW% [Spotify]" & goto c_4)
if errorlevel 1 echo %PLAY_SHOW% | find "[VLC]" >nul && goto c_4 || (set "PLAY_S=%PLAY_S% VideoLAN.VLC" & set "PLAY_SHOW=%PLAY_SHOW% [VLC]" & goto c_4)

:c_5
cls
echo.
echo   [ KROK 5/7 ] GRY
echo   ----------------------------------------
echo   Wybrano: %GAME_SHOW%
echo.
echo   [1] Steam [2] Epic [3] Playnite [4] GOG [5] Dalej
echo.
choice /C 12345 /M "  Dodaj: "
if errorlevel 5 goto c_6
if errorlevel 4 echo %GAME_SHOW% | find "[GoG]" >nul && goto c_5 || (set "GAME_S=%GAME_S% GOG.Galaxy" & set "GAME_SHOW=%GAME_SHOW% [GoG]" & goto c_5)
if errorlevel 3 echo %GAME_SHOW% | find "[Playnite]" >nul && goto c_5 || (set "GAME_S=%GAME_S% Playnite.Playnite" & set "GAME_SHOW=%GAME_SHOW% [Playnite]" & goto c_5)
if errorlevel 2 echo %GAME_SHOW% | find "[Epic]" >nul && goto c_5 || (set "GAME_S=%GAME_S% EpicGames.EpicGamesLauncher" & set "GAME_SHOW=%GAME_SHOW% [Epic]" & goto c_5)
if errorlevel 1 echo %GAME_SHOW% | find "[Steam]" >nul && goto c_5 || (set "GAME_S=%GAME_S% Valve.Steam" & set "GAME_SHOW=%GAME_SHOW% [Steam]" & goto c_5)

:c_6
cls
echo.
echo   [ KROK 6/7 ] PRZEGLADARKA ZDJEC
echo   ----------------------------------------
echo   [1] QView  [2] JPEGView  [3] Pomin
echo.
choice /C 1234 /M "  Wybor: "
if errorlevel 3 goto c_7
if errorlevel 2 set "PIC=[JPEGView]" & set "PIC_ID=sylikc.JPEGView"
if errorlevel 1 set "PIC=[QView]" & set "PIC_ID=jurplel.qView"

:c_7
cls
echo.
echo   [ KROK 7/7 ] DODATKI
echo   ----------------------------------------
echo   Wybrano: %EXTR_SHOW%
echo.
echo   [1] BCU [2] TeraCopy [3] ShareX [4] HWiNFO [5] UniGetUI [6] Dalej
echo.
choice /C 123456 /M "  Dodaj: "
if errorlevel 6 goto summary
if errorlevel 5 echo %EXTR_SHOW% | find "[UniGetUI]" >nul && goto c_7 || (set "EXTR_S=%EXTR_S% Devolutions.UniGetUI" & set "EXTR_SHOW=%EXTR_SHOW% [UniGetUI]" & goto c_7)
if errorlevel 4 echo %EXTR_SHOW% | find "[HWiNFO]" >nul && goto c_7 || (set "EXTR_S=%EXTR_S% REALiX.HWiNFO" & set "EXTR_SHOW=%EXTR_SHOW% [HWiNFO]" & goto c_7)
if errorlevel 3 echo %EXTR_SHOW% | find "[ShareX]" >nul && goto c_7 || (set "EXTR_S=%EXTR_S% ShareX.ShareX" & set "EXTR_SHOW=%EXTR_SHOW% [ShareX]" & goto c_7)
if errorlevel 2 echo %EXTR_SHOW% | find "[TeraCopy]" >nul && goto c_7 || (set "EXTR_S=%EXTR_S% CodeSector.TeraCopy" & set "EXTR_SHOW=%EXTR_SHOW% [TeraCopy]" & goto c_7)
if errorlevel 1 echo %EXTR_SHOW% | find "[BCU]" >nul && goto c_7 || (set "EXTR_S=%EXTR_S% Klocman.BulkCrapUninstaller" & set "EXTR_SHOW=%EXTR_SHOW% [BCU]" & goto c_7)

:summary
cls
echo.
echo   PODSUMOWANIE KONFIGURACJI
echo   ----------------------------------------
if not "%BROWSER%"==""   echo   Przegladarka : %BROWSER%
if not "%ZIP%"==""       echo   Archiwizator : %ZIP%
if not "%MESS_SHOW%"=="" echo   Komunikatory : %MESS_SHOW%
if not "%PLAY_SHOW%"=="" echo   Multimedia   : %PLAY_SHOW%
if not "%GAME_SHOW%"=="" echo   Gaming       : %GAME_SHOW%
if not "%PIC%"==""       echo   Zdjecia      : %PIC%
if not "%EXTR_SHOW%"=="" echo   Dodatki      : %EXTR_SHOW%
echo   ----------------------------------------
echo   Dodatkowo: Biblioteki systemowe (VCRedist,DotNet,DirectX,JRE,PowerShell-7)
echo.
choice /C 12 /M "  [1] Potwierdz i instaluj  [2] Anuluj: "
if errorlevel 2 goto begin

:configuratorinstallation
title SpacziBOX - Instalacja (Winget)...
color 0B
cls
echo.
echo   [*] Wlaczanie funkcji systemowych (.NET Framework, DirectPlay, LegacyComponents)...
dism /online /enable-feature /featurename:NetFx3 /featurename:NetFx4-AdvSrvs /featurename:DirectPlay /featurename:LegacyComponents /All

echo   [*] Przygotowywanie bibliotek systemowych...
for %%b in (
    abbodi1406.vcredist
    Microsoft.DotNet.Runtime.2_2
    Microsoft.DotNet.Runtime.3_1
    Microsoft.DotNet.Runtime.5
    Microsoft.DotNet.Runtime.6
    Microsoft.DotNet.Runtime.7
    Microsoft.DotNet.Runtime.8
    Microsoft.DotNet.Runtime.9
    Microsoft.DotNet.Runtime.10
    Microsoft.DotNet.Runtime.11
    Microsoft.DotNet.DesktopRuntime.3_1
    Microsoft.DotNet.DesktopRuntime.5
    Microsoft.DotNet.DesktopRuntime.6
    Microsoft.DotNet.DesktopRuntime.7
    Microsoft.DotNet.DesktopRuntime.8
    Microsoft.DotNet.DesktopRuntime.9
    Microsoft.DotNet.DesktopRuntime.10
    Microsoft.DotNet.DesktopRuntime.11
    Microsoft.XNARedist
    Microsoft.DirectX
    Azul.Zulu.8.JRE
    Azul.Zulu.17.JRE
    Azul.Zulu.21.JRE
    Azul.Zulu.25.JRE
    Microsoft.PowerShell
) do (
    echo   + Biblioteka: %%b
    winget install --id %%b -e --silent --accept-package-agreements --accept-source-agreements
)

echo.
echo   [*] Instalowanie wybranych programow...
for %%a in (%BROWSER_ID% %ZIP_ID% %MESS_S% %PLAY_S% %GAME_S% %PIC_ID% %EXTR_S%) do (
    if not "%%a"=="" (
        echo   + Instalacja ID: %%a
        winget install --id %%a -e --silent --accept-package-agreements --accept-source-agreements
    )
)
echo.
echo   [!] Proces zakonczony sukcesem.
pause
goto begin

:isAdmin
fsutil dirty query %systemdrive% >nul
exit /b

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:end
cls
color 02
echo.
echo   Dzieki za skorzystanie ze SpacziBOXa!
timeout /t 2 >nul
exit
