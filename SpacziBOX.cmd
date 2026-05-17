@echo off
setlocal EnableDelayedExpansion
call :isAdmin
if %errorlevel% neq 0 (goto :UACPrompt)

:run
title SpacziBOX
color 0F
goto intro

:intro
cls
echo.
echo   SPACZIBOX
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
echo   [2] Zainstaluj srodowisko Chocolatey
echo   [3] Szybki Konfigurator Programow
echo   [4] Wyjscie
echo   ----------------------------------------
echo.
choice /C 1234 /M "  Wybierz opcje: "
if errorlevel 4 goto end
if errorlevel 3 goto check_choco
if errorlevel 2 goto chocolateyinstall
if errorlevel 1 goto christoolbox

:christoolbox
color 09
powershell.exe -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm https://christitus.com/win | iex"
goto begin

:chocolateyinstall
color 0B
cls
echo.
echo   [*] Instalacja Chocolatey...
powershell.exe -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
echo.

echo   [*] Konfiguracja funkcji i ustawien Chocolatey...
:: Wlaczanie funkcji
choco feature enable -n allowGlobalConfirmation
choco feature enable -n useEnhancedExitCodes
choco feature enable -n useRememberedArgumentsForUpgrades
choco feature enable -n stopOnFirstPackageFailure
choco feature enable -n exitOnRebootDetected
choco feature enable -n powershellHost

:: Wylaczanie funkcji
choco feature disable -n showDownloadProgress

:: Ustawienia konfiguracji
choco config set commandExecutionTimeoutSeconds 14400
choco config set cacheLocation C:\ChocoCache
echo.

echo   [!] Gotowe.
echo   Restartowanie skryptu...
timeout /t 2 >nul
start "" "%~f0"
exit

:check_choco
where choco >nul 2>nul ||
if exist "%ProgramData%\chocolatey\bin\choco.exe" (set "PATH=%PATH%;%ProgramData%\chocolatey\bin") else (
    echo.
    echo   [!] Blad: Chocolatey nie jest zainstalowane.
    pause
    goto begin
)
goto configuratorstart

:configuratorstart
set "BROWSER=" & set "BROWSER_ID=" & set "ZIP=" & set "ZIP_ID=" & set "PIC=" & set "PIC_ID="
set "MESS_S=" & set "MESS_SHOW="
set "PLAY_S=" & set "PLAY_SHOW="
set "GAME_S=" & set "GAME_SHOW="
set "RESC_S=" & set "RESC_SHOW="
set "EXTR_S=" & set "EXTR_SHOW="

:c_1
cls
echo.
echo   [ KROK 1/8 ] PRZEGLADARKA
echo   ----------------------------------------
echo   [1] Firefox  [2] Firefox-ESR  [3] Brave  [4] OperaGX  [5] Pomin
echo.
choice /C 12345 /M "  Wybor: "
if errorlevel 5 goto c_2
if errorlevel 4 set "BROWSER=[OperaGX]" & set "BROWSER_ID=opera-gx"
if errorlevel 3 set "BROWSER=[Brave]" & set "BROWSER_ID=brave"
if errorlevel 2 set "BROWSER=[Firefox-ESR]" & set "BROWSER_ID=firefoxesr"
if errorlevel 1 set "BROWSER=[Firefox]" & set "BROWSER_ID=firefox"

:c_2
cls
echo.
echo   [ KROK 2/8 ] ARCHIWIZATOR
echo   ----------------------------------------
echo   [1] 7-Zip  [2] WinRAR  [3] Pomin
echo.
choice /C 123 /M "  Wybor: "
if errorlevel 3 goto c_3
if errorlevel 2 set "ZIP=[WinRAR]" & set "ZIP_ID=winrar"
if errorlevel 1 set "ZIP=[7-Zip]" & set "ZIP_ID=7zip"

:c_3
cls
echo.
echo   [ KROK 3/8 ] KOMUNIKATORY
echo   ----------------------------------------
echo   Wybrano: %MESS_SHOW%
echo.
echo   [1] Discord [2] TS3 [3] Messenger [4] Telegram [5] Signal [6] Dalej
echo.
choice /C 123456 /M "  Dodaj: "
if errorlevel 6 goto c_4
if errorlevel 5 echo %MESS_SHOW% | find "[Signal]" >nul && goto c_3 || (set "MESS_S=%MESS_S% signal" & set "MESS_SHOW=%MESS_SHOW% [Signal]" & goto c_3)
if errorlevel 4 echo %MESS_SHOW% | find "[Telegram]" >nul && goto c_3 || (set "MESS_S=%MESS_S% telegram" & set "MESS_SHOW=%MESS_SHOW% [Telegram]" & goto c_3)
if errorlevel 3 echo %MESS_SHOW% | find "[Messenger]" >nul && goto c_3 || (set "MESS_S=%MESS_S% caprine" & set "MESS_SHOW=%MESS_SHOW% [Messenger]" & goto c_3)
if errorlevel 2 echo %MESS_SHOW% | find "[TeamSpeak]" >nul && goto c_3 || (set "MESS_S=%MESS_S% teamspeak" & set "MESS_SHOW=%MESS_SHOW% [TeamSpeak]" & goto c_3)
if errorlevel 1 echo %MESS_SHOW% | find "[Discord]" >nul && goto c_3 || (set "MESS_S=%MESS_S% discord" & set "MESS_SHOW=%MESS_SHOW% [Discord]" & goto c_3)

:c_4
cls
echo.
echo   [ KROK 4/8 ] MULTIMEDIA
echo   ----------------------------------------
echo   Wybrano: %PLAY_SHOW%
echo.
echo   [1] VLC [2] K-Lite [3] Foobar2000 [4] Spotify [5] Dalej
echo.
choice /C 12345 /M "  Dodaj: "
if errorlevel 5 goto c_5
if errorlevel 4 echo %PLAY_SHOW% | find "[Spotify]" >nul && goto c_4 || (set "PLAY_S=%PLAY_S% spotify" & set "PLAY_SHOW=%PLAY_SHOW% [Spotify]" & goto c_4)
if errorlevel 3 echo %PLAY_SHOW% | find "[Foobar]" >nul && goto c_4 || (set "PLAY_S=%PLAY_S% foobar2000" & set "PLAY_SHOW=%PLAY_SHOW% [Foobar]" & goto c_4)
if errorlevel 2 echo %PLAY_SHOW% | find "[K-Lite]" >nul && goto c_4 || (set "PLAY_S=%PLAY_S% k-litecodecpackmega" & set "PLAY_SHOW=%PLAY_SHOW% [K-Lite]" & goto c_4)
if errorlevel 1 echo %PLAY_SHOW% | find "[VLC]" >nul && goto c_4 || (set "PLAY_S=%PLAY_S% vlc vlc-skins" & set "PLAY_SHOW=%PLAY_SHOW% [VLC]" & goto c_4)

:c_5
cls
echo.
echo   [ KROK 5/8 ] GRY
echo   ----------------------------------------
echo   Wybrano: %GAME_SHOW%
echo.
echo   [1] Steam [2] Epic [3] Playnite [4] GOG [5] Dalej
echo.
choice /C 12345 /M "  Dodaj: "
if errorlevel 5 goto c_6
if errorlevel 4 echo %GAME_SHOW% | find "[GoG]" >nul && goto c_5 || (set "GAME_S=%GAME_S% goggalaxy" & set "GAME_SHOW=%GAME_SHOW% [GoG]" & goto c_5)
if errorlevel 3 echo %GAME_SHOW% | find "[Playnite]" >nul && goto c_5 || (set "GAME_S=%GAME_S% playnite" & set "GAME_SHOW=%GAME_SHOW% [Playnite]" & goto c_5)
if errorlevel 2 echo %GAME_SHOW% | find "[Epic]" >nul && goto c_5 || (set "GAME_S=%GAME_S% epicgameslauncher" & set "GAME_SHOW=%GAME_SHOW% [Epic]" & goto c_5)
if errorlevel 1 echo %GAME_SHOW% | find "[Steam]" >nul && goto c_5 || (set "GAME_S=%GAME_S% steam" & set "GAME_SHOW=%GAME_SHOW% [Steam]" & goto c_5)

:c_6
cls
echo.
echo   [ KROK 6/8 ] PRZEGLADARKA ZDJEC
echo   ----------------------------------------
echo   [1] QView  [2] IrfanView  [3] JPEGView  [4] Pomin
echo.
choice /C 1234 /M "  Wybor: "
if errorlevel 4 goto c_7
if errorlevel 3 set "PIC=[JPEGView]" & set "PIC_ID=jpegview"
if errorlevel 2 set "PIC=[IrfanView]" & set "PIC_ID=irfanview"
if errorlevel 1 set "PIC=[QView]" & set "PIC_ID=qview"

:c_7
cls
echo.
echo   [ KROK 7/8 ] NARZEDZIA RATUNKOWE
echo   ----------------------------------------
echo   Wybrano: %RESC_SHOW%
echo.
echo   [1] ShareX [2] CrystalDiskInfo [3] HWiNFO64 [4] LibreHardwareMonitor [5] Dalej
echo.
choice /C 12345 /M "  Dodaj: "
if errorlevel 5 goto c_8
if errorlevel 4 echo %RESC_SHOW% | find "[LHM]" >nul && goto c_7 || (set "RESC_S=%RESC_S% librehardwaremonitor" & set "RESC_SHOW=%RESC_SHOW% [LHM]" & goto c_7)
if errorlevel 3 echo %RESC_SHOW% | find "[HWiNFO]" >nul && goto c_7 || (set "RESC_S=%RESC_S% hwinfo" & set "RESC_SHOW=%RESC_SHOW% [HWiNFO]" & goto c_7)
if errorlevel 2 echo %RESC_SHOW% | find "[CrystalDisk]" >nul && goto c_7 || (set "RESC_S=%RESC_S% crystaldiskinfo" & set "RESC_SHOW=%RESC_SHOW% [CrystalDisk]" & goto c_7)
if errorlevel 1 echo %RESC_SHOW% | find "[ShareX]" >nul && goto c_7 || (set "RESC_S=%RESC_S% sharex" & set "RESC_SHOW=%RESC_SHOW% [ShareX]" & goto c_7)

:c_8
cls
echo.
echo   [ KROK 8/8 ] DODATKI
echo   ----------------------------------------
echo   Wybrano: %EXTR_SHOW%
echo.
echo   [1] OpenShell [2] BCU [3] TeraCopy [4] ChocoGUI [5] Dalej
echo.
choice /C 12345 /M "  Dodaj: "
if errorlevel 5 goto summary
if errorlevel 4 echo %EXTR_SHOW% | find "[ChocoGUI]" >nul && goto c_8 || (set "EXTR_S=%EXTR_S% chocolateygui" & set "EXTR_SHOW=%EXTR_SHOW% [ChocoGUI]" & goto c_8)
if errorlevel 3 echo %EXTR_SHOW% | find "[TeraCopy]" >nul && goto c_8 || (set "EXTR_S=%EXTR_S% teracopy" & set "EXTR_SHOW=%EXTR_SHOW% [TeraCopy]" & goto c_8)
if errorlevel 2 echo %EXTR_SHOW% | find "[BCU]" >nul && goto c_8 || (set "EXTR_S=%EXTR_S% bulk-crap-uninstaller" & set "EXTR_SHOW=%EXTR_SHOW% [BCU]" & goto c_8)
if errorlevel 1 echo %EXTR_SHOW% | find "[OpenShell]" >nul && goto c_8 || (set "EXTR_S=%EXTR_S% open-shell --params "'/StartMenu'"" & set "EXTR_SHOW=%EXTR_SHOW% [OpenShell]" & goto c_8)

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
if not "%RESC_SHOW%"=="" echo   Ratunkowe    : %RESC_SHOW%
if not "%EXTR_SHOW%"=="" echo   Dodatki      : %EXTR_SHOW%
echo   ----------------------------------------
echo   Dodatkowo: Biblioteki systemowe (DotNet, DirectX, Zulu JRE)
echo.
choice /C 12 /M "  [1] Potwierdz i instaluj  [2] Anuluj: "
if errorlevel 2 goto begin

:configuratorinstallation
title SpacziBOX - Instalacja...
color 0B
cls
echo.
echo   [*] Przygotowywanie bibliotek systemowych...
choco install dotnet-all vcredist-all directx xna zulu8 zulu17 zulu21 zulu25 -y --silent

echo   [*] Instalowanie wybranych programow...
for %%a in (%BROWSER_ID% %ZIP_ID% %MESS_S% %PLAY_S% %GAME_S% %PIC_ID% %RESC_S% %EXTR_S%) do (
    if not "%%a"=="" (
        echo   + Instalacja: %%a
        choco install %%a -y --silent
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