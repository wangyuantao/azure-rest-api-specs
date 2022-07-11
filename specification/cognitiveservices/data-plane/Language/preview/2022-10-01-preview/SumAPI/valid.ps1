#$workingDir = "D:\azure-rest-api-specs\specification\cognitiveservices\data-plane\Language\"
$prevDir = "D:\azure-rest-api-specs\specification\cognitiveservices\data-plane\Language\preview\2022-05-15-preview\"
$workingDir = "D:\azure-rest-api-specs\dev\cognitiveservices\data-plane\Language\"
$cwd = Get-Location
$patchDir = Join-Path -Path $cwd -ChildPath "patch" 
$diffDir = Join-Path -Path $cwd -ChildPath "diff"
Remove-Item $diffDir -Recurse
New-Item $diffDir -ItemType Directory
$readme = Join-Path -Path $workingDir -ChildPath "readme.md"
autorest --validation --azure-validator --use=@microsoft.azure/classic-openapi-validator@latest --use=@microsoft.azure/openapi-validator@latest $readme
foreach($f in Get-ChildItem -Path $patchDir -Filter *.json){    
    $oldSpec = Join-Path -Path $prevDir -ChildPath $f.Name
    if($f.Name -eq "analyzetext.json"){
        $oldSpec = Join-Path -Path $prevDir -ChildPath "textanalytics.json"
    }
    $newSpec = Join-Path -Path $workingDir -ChildPath $f.Name
    $diff = Join-Path -Path $diffDir -ChildPath $f.Name
    Write-Output "================"
    Write-Output "Validate $newSpec wtih $oldSpec"
    Write-Output "================"
    oav validate-spec $newSpec
    Write-Output "================"
    oav validate-example $newSpec
    Write-Output "================"
    oad compare $oldSpec $newSpec > $diff 
    Write-Output "================"
}
Remove-Item *.log