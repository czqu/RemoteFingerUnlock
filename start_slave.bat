@echo off

set currentDir=%~dp0
cd "%currentDir%"
start "" core-service.exe %*

rem 
exit
