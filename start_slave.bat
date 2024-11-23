@echo off

set currentDir=%~dp0
cd /d "%currentDir%"
start "" core-service.exe %*

rem 
exit
