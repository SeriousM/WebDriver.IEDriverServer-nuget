@echo off

set PWD="%CD%"
set NUGET=%PWD%\NuGet.exe
set VERSION=win32

set /P APIKEY=Enter your Api Key from https://www.nuget.org/account/ApiKeys: 

if "%APIKEY%"=="" GOTO ERROR

%NUGET% push -source nuget.org %PWD%\..\%VERSION%\*.nupkg %APIKEY%
GOTO END

:ERROR
echo EXIT: No api key was entered

:END