@echo off

echo Attempting to delete: "%~1"
rmdir /S /Q "%~1"
if '%errorlevel%' EQU '0' (
        echo Directory "%~1" deleted successfully.
    ) else (
        echo Failed to delete directory "%~1". Please check the path or permissions.
 )
pause