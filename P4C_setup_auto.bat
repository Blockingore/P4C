@echo off
setlocal enabledelayedexpansion

REM Auto-hide script: se non è già nascosto, rilancia se stesso nascosto
if not "%1"=="hidden" (
    powershell -WindowStyle Hidden -Command "Start-Process cmd -ArgumentList '/c \"%~f0\" hidden' -WindowStyle Hidden"
    exit /b
)

REM TEMPORANEO: Rimuovo redirection per far funzionare tutto
REM >nul 2>&1 (

REM === STEP 1: COPIA DEPLOYMENT.PROPERTIES ===
REM Crea cartelle e copia deployment.properties nei percorsi Java
md "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment" 2>nul
md "%USERPROFILE%\.java\deployment" 2>nul
md "%USERPROFILE%\AppData\Roaming\Sun\Java\Deployment" 2>nul
md "C:\Users\Default\AppData\LocalLow\Sun\Java\Deployment" 2>nul
md "C:\Users\Default\.java\deployment" 2>nul
copy /Y "%~dp0deployment.properties" "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\deployment.properties"
copy /Y "%~dp0deployment.properties" "%USERPROFILE%\.java\deployment\deployment.properties"
copy /Y "%~dp0deployment.properties" "%USERPROFILE%\AppData\Roaming\Sun\Java\Deployment\deployment.properties"
copy /Y "%~dp0deployment.properties" "C:\Users\Default\AppData\LocalLow\Sun\Java\Deployment\deployment.properties"
copy /Y "%~dp0deployment.properties" "C:\Users\Default\.java\deployment\deployment.properties"

REM === CREAZIONE MANUALE FILE EXCEPTION.SITES ===
REM Crea il file exception.sites nelle cartelle Java per assicurarsi che le eccezioni siano riconosciute
echo https://c4c.cee-psn.asi-1.i.it > "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
echo https://c4c.cce.asl-11.it >> "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
md "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\security" 2>nul
echo https://c4c.cee-psn.asi-1.i.it > "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
echo https://c4c.cce.asl-11.it >> "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"

md "%USERPROFILE%\.java\deployment\security" 2>nul
echo https://c4c.cee-psn.asi-1.i.it > "%USERPROFILE%\.java\deployment\security\exception.sites"
echo https://c4c.cce.asl-11.it >> "%USERPROFILE%\.java\deployment\security\exception.sites"

md "%USERPROFILE%\AppData\Roaming\Sun\Java\Deployment\security" 2>nul
echo https://c4c.cee-psn.asi-1.i.it > "%USERPROFILE%\AppData\Roaming\Sun\Java\Deployment\security\exception.sites"
echo https://c4c.cce.asl-11.it >> "%USERPROFILE%\AppData\Roaming\Sun\Java\Deployment\security\exception.sites"

REM Crea anche per l'utente Default
md "C:\Users\Default\AppData\LocalLow\Sun\Java\Deployment\security" 2>nul
echo https://c4c.cee-psn.asi-1.i.it > "C:\Users\Default\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
echo https://c4c.cce.asl-11.it >> "C:\Users\Default\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"

md "C:\Users\Default\.java\deployment\security" 2>nul
echo https://c4c.cee-psn.asi-1.i.it > "C:\Users\Default\.java\deployment\security\exception.sites"
echo https://c4c.cce.asl-11.it >> "C:\Users\Default\.java\deployment\security\exception.sites"

REM === STEP 1.1: CONFIGURAZIONE REGISTRO JAVA ===
REM Aggiungi impostazioni Java nel registro per utente corrente
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.javaws.splash.index" /t REG_SZ /d "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\cache\6.0\splash\splash.xml" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.version" /t REG_SZ /d "8" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.javaws.appicon.index" /t REG_SZ /d "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\cache\6.0\appIcon\appIcon.xml" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.user.security.exception.sites" /t REG_SZ /d "https://c4c.cee-psn.asi-1.i.it%0Ahttps://c4c.cce.asl-11.it" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.browser.path" /t REG_SZ /d "C:\Program Files\Google\Chrome\Application\chrome.exe" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.javapi.cache.update" /t REG_SZ /d "true" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.roaming.profile" /t REG_SZ /d "true" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.expiration.check.enabled" /t REG_SZ /d "false" /f

REM Impostazioni aggiuntive per eliminare COMPLETAMENTE i popup di aggiornamento
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.installer.update.preference" /t REG_SZ /d "NEVER" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.javaws.update.timeout" /t REG_SZ /d "0" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.javaws.autodownload" /t REG_SZ /d "NEVER" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.security.askgrantdialog.show" /t REG_SZ /d "true" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.security.askgrantdialog.notinca" /t REG_SZ /d "true" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.console.startup.mode" /t REG_SZ /d "HIDE" /f

REM Disabilita anche Java Update Scheduler specifico per JNLP
reg add "HKCU\SOFTWARE\JavaSoft\Java Update\Policy" /v "EnableJavaUpdate" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\JavaSoft\Java Update\Policy" /v "EnableAutoUpdateCheck" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\JavaSoft\Java Update\Policy" /v "NotifyDownload" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\JavaSoft\Java Update\Policy" /v "NotifyInstall" /t REG_DWORD /d 0 /f

REM === CONFIGURAZIONE AGGIUNTIVA ECCEZIONI SICUREZZA ===
REM Aggiungi anche nel registro di sistema per la sicurezza Java Web Start
reg add "HKCU\SOFTWARE\JavaSoft\Java Web Start\1.0.1" /v "JNLPExceptionSiteList" /t REG_SZ /d "https://c4c.cee-psn.asi-1.i.it;https://c4c.cce.asl-11.it" /f
reg add "HKCU\SOFTWARE\JavaSoft\Java Web Start" /v "ExceptionSiteList" /t REG_SZ /d "https://c4c.cee-psn.asi-1.i.it;https://c4c.cce.asl-11.it" /f

REM Configura anche le impostazioni di sicurezza per Java Control Panel
reg add "HKCU\SOFTWARE\JavaSoft\Java Runtime Environment\1.8" /v "ExceptionSiteList" /t REG_SZ /d "https://c4c.cee-psn.asi-1.i.it;https://c4c.cce.asl-11.it" /f
reg add "HKCU\SOFTWARE\JavaSoft\Java Runtime Environment\1.6" /v "ExceptionSiteList" /t REG_SZ /d "https://c4c.cee-psn.asi-1.i.it;https://c4c.cce.asl-11.it" /f

REM === CONFIGURAZIONE MICROSOFT EDGE - DISABILITA RICARICAMENTO MODALITA' IE ===
REM Disabilita il ricaricamento automatico dei siti in modalità Internet Explorer
REM Policy: "Consenti il ricaricamento dei siti in modalità Internet Explorer" impostata su "Non consentire"
echo.
echo [CONFIG EDGE] Disabilitazione ricaricamento siti in modalita IE...

REM Crea le chiavi di policy di Edge se non esistono
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /f 2>nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Edge" /f 2>nul

REM Disabilita il ricaricamento in modalità IE (valore 0 = Non consentire)
REM HKLM = per tutti gli utenti del computer (richiede privilegi amministrativi)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "InternetExplorerIntegrationReloadInIEModeAllowed" /t REG_DWORD /d 0 /f 2>nul

REM HKCU = per l'utente corrente (non richiede privilegi amministrativi)
reg add "HKCU\SOFTWARE\Policies\Microsoft\Edge" /v "InternetExplorerIntegrationReloadInIEModeAllowed" /t REG_DWORD /d 0 /f

echo   [OK] Ricaricamento siti in modalita IE disabilitato per Edge

REM Abilita il pannello di controllo Java per permettere modifiche manuali
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.control.panel.suppress" /t REG_SZ /d "false" /f
reg add "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.security.level" /t REG_SZ /d "MEDIUM" /f

REM === VERIFICA CONFIGURAZIONE ===
echo.
echo [VERIFICA] Controllo configurazione eccezioni Java...
reg query "HKCU\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.user.security.exception.sites" 2>nul
if %errorlevel% equ 0 (
    echo   [OK] Eccezioni di sicurezza configurate nel registro
) else (
    echo   [WARN] Eccezioni di sicurezza non trovate nel registro
)

REM Verifica file exception.sites
if exist "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites" (
    echo   [OK] File exception.sites creato
    echo   [INFO] Contenuto file exception.sites:
    type "%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
) else (
    echo   [WARN] File exception.sites non trovato
)

REM Forza il refresh delle impostazioni Java terminando tutti i processi
echo   [INFO] Refresh impostazioni Java in corso...
taskkill /F /IM javaw.exe /T 2>nul >nul
taskkill /F /IM java.exe /T 2>nul >nul
taskkill /F /IM javaws.exe /T 2>nul >nul
taskkill /F /IM jp2launcher.exe /T 2>nul >nul
echo   [OK] Processi Java terminati per refresh configurazione

REM Carica anche il registro del Default user per i nuovi utenti (richiede admin)
reg load "HKU\DefaultUser" "C:\Users\Default\NTUSER.DAT" 2>nul
if !errorlevel! equ 0 (
    reg add "HKU\DefaultUser\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.version" /t REG_SZ /d "8" /f 2>nul
    reg add "HKU\DefaultUser\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.user.security.exception.sites" /t REG_SZ /d "https://c4c.cee-psn.asi-1.i.it%0Ahttps://c4c.cce.asl-11.it" /f 2>nul
    reg add "HKU\DefaultUser\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.browser.path" /t REG_SZ /d "C:\Program Files\Google\Chrome\Application\chrome.exe" /f 2>nul
    reg add "HKU\DefaultUser\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.javapi.cache.update" /t REG_SZ /d "true" /f 2>nul
    reg add "HKU\DefaultUser\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.roaming.profile" /t REG_SZ /d "true" /f 2>nul
    reg add "HKU\DefaultUser\SOFTWARE\JavaSoft\DeploymentProperties" /v "deployment.expiration.check.enabled" /t REG_SZ /d "false" /f 2>nul
    reg unload "HKU\DefaultUser" 2>nul
)

REM === STEP 2: CREAZIONE CARTELLA GALILEO ===

REM Configurazione cartella Galileo...

set "galileo_folder=C:\Galileo"

REM Crea sempre la cartella Galileo se non esiste
if not exist "%galileo_folder%" (
    mkdir "%galileo_folder%"
    echo   [OK] Cartella C:\Galileo creata
)

REM Copia SEMPRE i file galileo.bat e Icona_Galileo.ico (FORZATO)
echo   [INFO] Copia FORZATA file galileo...
copy "%~dp0galileo.bat" "%galileo_folder%\" /Y
copy "%~dp0Icona_Galileo.ico" "%galileo_folder%\" /Y

REM Copia anche galileo.jnlp se esiste
if exist "%~dp0galileo.jnlp" (
    copy "%~dp0galileo.jnlp" "%galileo_folder%\" /Y
    echo   [OK] galileo.jnlp copiato in C:\Galileo
) else (
    echo   [WARN] galileo.jnlp non trovato nella cartella script
)

echo   [OK] File galileo copiati FORZATAMENTE in C:\Galileo

REM === STEP 3: GESTIONE COLLEGAMENTO GALILEO SUL DESKTOP ===
echo.
echo [STEP 3/6] Gestione collegamento Galileo sul Desktop...

REM Elimina qualsiasi file o collegamento contenente "galileo" (case-insensitive) dal Desktop
echo   [INFO] Ricerca e rimozione file/collegamenti contenenti "galileo" dal Desktop...

REM Cambia nella directory Desktop
REM ELIMINAZIONE BRUTALE CON POWERSHELL
echo   [INFO] Eliminazione file galileo con PowerShell...

powershell -Command "Get-ChildItem -Path '%USERPROFILE%\Desktop' -Filter '*galileo*' -Force | Remove-Item -Force -ErrorAction SilentlyContinue"
powershell -Command "Get-ChildItem -Path 'C:\Users\Public\Desktop' -Filter '*galileo*' -Force | Remove-Item -Force -ErrorAction SilentlyContinue"
powershell -Command "Get-ChildItem -Path 'C:\Utenti\Pubblica\Desktop pubblico' -Filter '*galileo*' -Force | Remove-Item -Force -ErrorAction SilentlyContinue"

echo   [OK] Eliminazione PowerShell completata

REM Crea il nuovo collegamento a galileo.bat (sempre, indipendentemente dalla cartella)
echo   [INFO] Creazione collegamento a C:\Galileo\galileo.bat...

REM Crea collegamento usando PowerShell (senza file esterni)
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\GALILEO.lnk'); $Shortcut.TargetPath = 'C:\Galileo\galileo.bat'; $Shortcut.WorkingDirectory = 'C:\Galileo'; $Shortcut.IconLocation = 'C:\Galileo\Icona_Galileo.ico'; $Shortcut.Description = 'Avvia Galileo'; $Shortcut.Save()"

if exist "%USERPROFILE%\Desktop\GALILEO.lnk" (
    echo   [OK] Collegamento GALILEO.lnk creato sul Desktop
) else (
    echo   [ERROR] Errore nella creazione del collegamento
)

REM === STEP 4: CREAZIONE CARTELLA P4C E COPIA TINYSERVER.JNLP ===
echo.
echo [STEP 4/6] Configurazione cartella P4C...

set "p4c_folder=C:\P4C"

REM Controlla se la cartella esiste
if not exist "%p4c_folder%" (
    mkdir "%p4c_folder%" >nul 2>&1
    echo   [OK] Cartella C:\P4C creata
) else (
    echo   [INFO] Cartella C:\P4C già esistente
)

REM Copia tinyserver.jnlp
REM Copia sempre i file richiesti nella cartella P4C, sovrascrivendo quelli esistenti
copy /Y "%~dp0tinyserver.jnlp" "%p4c_folder%\" >nul 2>&1
if exist "%p4c_folder%\tinyserver.jnlp" (
    echo   [OK] tinyserver.jnlp copiato in C:\P4C
) else (
    echo   [ERROR] tinyserver.jnlp non trovato o non copiato
)

copy /Y "%~dp0deployment.properties" "%p4c_folder%\" >nul 2>&1
if exist "%p4c_folder%\deployment.properties" (
    echo   [OK] deployment.properties copiato in C:\P4C
) else (
    echo   [ERROR] deployment.properties non trovato o non copiato
)

copy /Y "%~dp0favicon.png" "%p4c_folder%\" >nul 2>&1
if exist "%p4c_folder%\favicon.png" (
    echo   [OK] favicon.png copiato in C:\P4C
) else (
    echo   [ERROR] favicon.png non trovato o non copiato
)

REM === STEP 5: AVVIO TINYSERVER CON JRE 8 (CODICE ORIGINALE) ===
echo.
echo [STEP 5/6] Avvio tinyserver.jnlp...

REM === TERMINAZIONE PROCESSI JAVAW ATTIVI PRIMA DEL LANCIO ===
echo   [INFO] Ricerca e terminazione processi Java attivi...

REM Terminazione processi usando PowerShell (più affidabile)
powershell -Command "Get-Process -Name 'javaws','javaw','java','jp2launcher' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue"

echo   [OK] Eventuali processi Java terminati

echo   [INFO] Attesa 3 secondi dopo terminazione processi...
timeout /t 3 /nobreak >nul

echo.
echo ATTENZIONE: Gestire manualmente eventuali popup Java che appariranno.
echo Cliccare su "Esegui" o "OK" quando richiesto.
echo.

REM Imposta la versione desiderata di Java
set "java_version=jre8"

REM Trova la versione di Java installata che contiene la stringa jre8 nel percorso
set "java_path="
for /d %%i in ("C:\Program Files (x86)\Java\*") do (
    if "%%~nxi" equ "jre8" (
        set "java_path=C:\Program Files (x86)\Java\jre8\bin\javaws.exe" 
        goto :BreakLoop
    )
)
:BreakLoop

REM Se il percorso di Java è stato trovato, esegui il comando
if defined java_path (
    echo Avvio P4C con Java 8...
    "%java_path%" "C:\P4C\tinyserver.jnlp"
) else (
    echo ATTENZIONE: Java 8 non trovato. Tentativo con Java predefinito...
    javaws "C:\P4C\tinyserver.jnlp"
)

REM === STEP 6: CREAZIONE ICONA TINYSERVER NELLA SYSTEM TRAY ===
echo.
echo [STEP 6/6] Configurazione sistema tray Tinyserver...

REM Termina eventuali processi PowerShell precedenti che eseguono il monitor
echo [INFO] Terminazione eventuali istanze precedenti del monitor...
powershell -Command "Get-Process -Name 'powershell' -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like '*tinyserver_tray*' } | Stop-Process -Force -ErrorAction SilentlyContinue"

echo   [OK] Script tray integrato nel batch (nessun file esterno necessario)

REM Crea il bat principale in C:\P4C per avere un percorso fisso
set "bat_source=%~f0"
copy "%bat_source%" "C:\P4C\P4C_setup_auto.bat" /Y >nul 2>&1
echo   [OK] Bat copiato in C:\P4C

REM Crea collegamento nella cartella Startup usando PowerShell
set "startup_folder=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"

echo   [INFO] Creazione collegamento con PowerShell...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%startup_folder%\P4C_Setup_Auto.lnk'); $Shortcut.TargetPath = 'C:\P4C\P4C_setup_auto.bat'; $Shortcut.WorkingDirectory = 'C:\P4C'; $Shortcut.Description = 'P4C Setup Automatico'; $Shortcut.Save()"

if exist "%startup_folder%\P4C_Setup_Auto.lnk" (
    echo   [OK] Collegamento P4C_Setup_Auto.lnk creato con successo!
) else (
    echo   [ERROR] Collegamento non creato - provo metodo alternativo...
    REM Metodo alternativo: copia direttamente il bat
    copy "C:\P4C\P4C_setup_auto.bat" "%startup_folder%\P4C_Setup_Auto.bat" /Y >nul 2>&1
    if exist "%startup_folder%\P4C_Setup_Auto.bat" (
        echo   [OK] File bat copiato direttamente in Startup come alternativa
    ) else (
        echo   [ERROR] Impossibile creare alcun file in Startup
    )
)

REM Attendi un momento per assicurarsi che i processi precedenti siano terminati
timeout /t 2 /nobreak >nul 2>&1

REM Avvia il sistema tray direttamente con PowerShell (nascosto)
echo   [INFO] Avvio sistema tray...
start /b powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notifyIcon = New-Object System.Windows.Forms.NotifyIcon; try { if (Test-Path 'C:\P4C\favicon.png') { $bitmap = New-Object System.Drawing.Bitmap('C:\P4C\favicon.png'); $notifyIcon.Icon = [System.Drawing.Icon]::FromHandle($bitmap.GetHicon()) } elseif (Test-Path 'C:\P4C\Icona_Galileo.ico') { $notifyIcon.Icon = New-Object System.Drawing.Icon('C:\P4C\Icona_Galileo.ico') } else { $notifyIcon.Icon = [System.Drawing.SystemIcons]::Information } } catch { $notifyIcon.Icon = [System.Drawing.SystemIcons]::Information }; $notifyIcon.Text = 'Tinyserver'; $notifyIcon.Visible = $true; while ($true) { try { $launcherProcess = Get-Process -Name 'jp2launcher' -ErrorAction SilentlyContinue; if ($launcherProcess) { if (-not $notifyIcon.Visible) { $notifyIcon.Visible = $true } } else { if ($notifyIcon.Visible) { $notifyIcon.Visible = $false }; $notifyIcon.Dispose(); exit } } catch { }; Start-Sleep -Seconds 3 }"

echo   [OK] Sistema tray Tinyserver avviato (integrato, nessun file esterno)

REM === CONFIGURAZIONE COMPLETATA ===
echo.
echo ===============================================
echo    CONFIGURAZIONE P4C COMPLETATA
echo ===============================================
echo.
echo RIEPILOGO OPERAZIONI:
echo [OK] deployment.properties copiato e configurato

REM === STEP FINALE: AVVIO DIRECTCONNECT ===
echo.
echo [STEP FINALE] Avvio DirectConnect con Java 6...
echo   [INFO] Avvio DirectConnect con Java 6...
"C:\Program Files (x86)\Java\jre6\bin\javaws" -Xnosplash \\SRV-FS01\Link-ICT\Hitech\direct-connect.jnlp
echo   [OK] DirectConnect avviato

REM Fine script
REM )
endlocal
--
REM jre-8u121-windows-i586.exe /s INSTALLDIR="C:\Program Files (x86)\Java\jre1.8.0_121" AUTO_UPDATE=0 EULA=1 REBOOT=0 SPONSORS=0
--
--
