$workingDir = "D:\azure-rest-api-specs\dev\cognitiveservices\data-plane\Language\"
$patchDir = "D:\MeetingMinutesAdHocTools\SumAPI\patch\"
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
Push-Location
Set-Location $workingDir
git fetch origin
git checkout origin/main .
foreach($f in Get-ChildItem -Path $patchDir -Filter *.json){
    Write-Output $f.FullName
    $patchFile = $f.FullName
    $workingFile = $f.FullName.replace($patchDir, $workingDir)
    if($f.Name -eq "analyzeconversations.json"){
        $content = jq 'del(.definitions.ConversationSummarizationTaskParameters,.definitions.SummaryResult)' $workingFile
        [System.IO.File]::WriteAllLines($workingFile, $content, $Utf8NoBomEncoding)
    }
    $content = jq -s '.[0] * .[1]' $workingFile $patchFile
    if($f.Name -eq "analyzetext.json"){
        $content = Write-Output $content | jq 'del(.definitions.CustomTaskParameters,.definitions.CustomResult,.definitions.DocumentError,.definitions.ExtractiveSummarizationTaskParameters.properties.stringIndexType)'
        $content = Write-Output $content | jq 'del(.paths | .. | .post?.\"x-ms-examples\".\"Succesful Healthcare Request\")'
    }
    [System.IO.File]::WriteAllLines($workingFile, $content, $Utf8NoBomEncoding)
}

#jq convert float to int, which causes example file not review-friendly, thus replace string literally in hack
$f = Join-Path $workingDir "examples\analyzeconversations-authoring\SuccessfulGetModelEvaluationSummary.json"
Write-Output $f
$content = Get-Content $f
$content = $content.replace("`"body`": {", "`"body`": {`r`n        `"projectKind`": `"Conversation`",")
[System.IO.File]::WriteAllLines($f, $content, $Utf8NoBomEncoding)

Copy-Item -Path (Join-Path $patchDir "examples") -Destination $workingDir -Recurse -Force -ErrorAction SilentlyContinue

Pop-Location