@echo off

set PWD="%CD%"
set NUGET=%PWD%\NuGet.exe
set VERSION=win64

DEL %PWD%\..\%VERSION%\*.nupkg

%NUGET% pack -Verbosity detailed -OutputDirectory %PWD%\..\%VERSION% -Exclude "**/build/**;**/.git/**;**/.git*;**/README.md" %PWD%\..\%VERSION%\WebDriver.IEDriverServer.%VERSION%.nuspec