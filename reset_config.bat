@echo off


>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin

    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )


    if "%~1"=="" (
        echo No directory specified to delete.
        exit /B 1
    )


    echo Attempting to delete: "%~1"
    rmdir /S /Q "%~1"
    if '%errorlevel%' EQU '0' (
        echo Directory "%~1" deleted successfully.
    ) else (
        echo Failed to delete directory "%~1". Please check the path or permissions.
    )
    exit /B