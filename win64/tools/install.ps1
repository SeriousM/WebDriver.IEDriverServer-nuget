param($installPath, $toolsPath, $package, $project)

$driverFile = "IEDriverServer.exe"
$contentPath = Join-Path $installPath "content" 
$driverPath = Join-Path $contentPath $driverFile
$nupkgName = Split-Path $installPath -Leaf

# remote the automatically added IEDriverServer.exe from the {packageRoot}\Deploy
$project.ProjectItems.Item($driverFile).Delete()
$project.Save()

# add IEDriverServer.exe as a file link
# use the MSBuild API to access the xml dom of the csproj file 
Add-Type -AssemblyName 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
$projectXml = ([Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | select -First 1).Xml
$projectUri = [uri]$project.FullName;
$drivertUri = [uri]$driverPath;
$driverRelativePath = $projectUri.MakeRelative($drivertUri) -replace "/","\"

$itemGrp = $projectXml.CreateItemGroupElement()
$projectXml.AppendChild($itemGrp)
$item = $itemGrp.AddItem("Content", $driverRelativePath)
$item.AddMetadata("Link", $driverFile)
$item.AddMetadata("CopyToOutputDirectory", "PreserveNewest")