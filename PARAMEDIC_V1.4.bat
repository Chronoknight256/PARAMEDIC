::::::::::::::::::::::::::::::::::::::::::::
:: PARAMEDIC V1.4
::::::::::::::::::::::::::::::::::::::::::::
 @echo off
 color 3
 CLS
 ECHO.
 ECHO :=============================:
 ECHO :Running Admin shell			:
 ECHO :=============================:

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~dpnx0"
 rem this works also from cmd shell, other than %~0
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"
  
  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
color a
Title Paramedic.tool
@echo off
cls
Echo .-################################++*###########################*++*###############################+
Echo .-#################################++*#########################*++*################################+
Echo .-##################################+=+####*+=--:::::--=+*####*=+*#################################+
Echo .-###################################+=+###*+=--:::::--=+*###+==*##################################+
Echo .-###################################*==+###*=--:::::--=*###+==*###################################+
Echo .-#####################################===###*=-:::::--+###+-=*####################################+
Echo .-######################################=-=###*-:::::-+###=--*#####################################+
Echo .-#######################################--=###*:::::+###=--*######################################+
Echo .-########################################---###*:::+###=--*#######################################+
Echo .-#########################################-:-###+:+###-:-#########################################+
Echo .-##########################################-:-#######-:-*#########################################+
Echo .-###########################################-::#####:::###########################################+
Echo .-###########################################*::=###+::*###########################################+
Echo .-###########################################=::+####::-###########################################+
Echo .-##########################################=::+#####*::-##########################################+
Echo .-#########################################=::*###-*##*-:=#########################################+
Echo .-########################################=--*###:::####---########################################+
Echo .-#######################################=--*###-::::####--=#######################################+
Echo .-######################################=--####-:::::-*###--=######################################+
Echo .-#####################################+=-####=-:::::-=####=-=#####################################+
Echo .-####################################===####=--:::::--=####===####################################+
Echo .-###################################+==####+=--:::::--=+####==+###################################+
Echo .-##################################+==####*+=--:::::--=+*####+=+##################################+
Echo .-#################################+++#####**++==---==++**#####+++#################################+
Echo .-################################*++###########################++*################################+
Echo .##################################################################################################+
Echo ====================================================================================================
Echo :
Echo :					PARAMEDIC.tool	
Echo :					Version 1.4		   
Echo :					by Itz_Chr0n0						   
Echo :
Echo ====================================================================================================
:::::::::::::::::::::
:::Scans and fixes:::
:::::::::::::::::::::

echo Program will take 5-15 minutes to finish
timeout /t 10
echo Beginning 1 of 4 Scans...

echo Now booting System File Checker...
SFC /scannow
rem SFC: system file checker, built into windows, very common repair tool

Echo ====================================================================================================
Echo 					Scan 1 Complete
Echo ====================================================================================================

DISM /Online /Cleanup-Image /ScanHealth
rem  DISM: Cleans up the Windows installation files

Echo ====================================================================================================
Echo 					Scan 2 Complete
Echo ====================================================================================================

DISM /Online /Cleanup-Image /RestoreHealth
rem fixes any issues found in scan 2

Echo ====================================================================================================
Echo 					Scan 3 Complete
Echo ====================================================================================================

chkdsk
chkdsk /f
rem this scans the physical memory blocks for hard drive health

Echo ====================================================================================================
Echo 					Scan Complete
Echo ====================================================================================================

fsutil behavior query memoryusage
fsutil behavior set memoryusage 2
rem this increases memory access allowed when opening and closing programs

setlocal
:PROMPT
SET /P AREYOUSURE=Would you like to reboot now (Y/N)?
IF /I "%AREYOUSURE%"=="Y" shutdown.exe /r /t 00
rem invokes a shutdown prompt

timeout /T -1