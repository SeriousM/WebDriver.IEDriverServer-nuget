param($installPath, $toolsPath, $package, $project)

$driverFile = "IEDriverServer.exe"
$contentPath = Join-Path $installPath "content"
$driverPath = Join-Path $contentPath $driverFile

# Treat the project file as a MSBuild script xml instead of DTEnv object model.
Add-Type -AssemblyName 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
$projectXml = ([Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | select -First 1).Xml

# Delete IEDriverServer content item
$projectXml.Children | ` # All children of root <Project>
Where-Object   { $_ -is [Microsoft.Build.Construction.ProjectItemGroupElement] } | ` # Elements that are <ItemGroup>
ForEach-Object { $_.Children } | ` # Children of the ItemGroup elements
Where-Object   { ($_.Children | Where-Object { $_.Name -eq "Link" -and $_.Value -eq $driverFile}) -ne $null } | ` # item trying to find
ForEach-Object {
    # Remove the item from the parent
    $itemGrp = $_.Parent
    $itemGrp.RemoveChild($_)
    # remove the item group if it has no children af removing the item
    if ($itemGrp.Children.Count -eq 0) { $projectXml.RemoveChild($itemGrp) }
}