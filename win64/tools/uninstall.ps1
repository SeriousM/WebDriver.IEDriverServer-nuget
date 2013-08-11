param($installPath, $toolsPath, $package, $project)

$file = Join-Path (Join-Path $toolsPath '..\content') 'IEDriverServer.exe' | Get-ChildItem

$project.ProjectItems.Item($file.Name).Delete()