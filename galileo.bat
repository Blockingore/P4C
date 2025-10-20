setlocal enabledelayedexpansion

REM Imposta la versione desiderata di Java
set "java_version=jre6"


REM Trova la versione di Java installata che contiene la stringa jre6 nel percorso
set "java_path="
for /d %%i in ("C:\Program Files (x86)\Java\*") do (
	"%%~nxi" equ "jre6" (
           set "java_path=C:\Program Files (x86)\Java\jre6\bin\javaws.exe" 
           goto :BreakLoop

    )


)
:BreakLoop


REM Se il percorso di Java è stato trovato, esegui il comando
do ( 
   if defined java_path (
	"%java_path%" "C:\Galileo\galileo.jnlp"
)

endlocal
