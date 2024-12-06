# https://adventofcode.com/2024/day/1

Set-Location "2024-01"

$fileContents = Get-ChildItem -Filter "*.txt" | Get-Content

$listOne = New-Object System.Collections.ArrayList
$listTwo = New-Object System.Collections.ArrayList

foreach ($line in $fileContents){
    $pair = $line -split("   ")
    [void]$listOne.Add($pair[0])
    [void]$listTwo.Add($pair[1])
}

$listOne = $listOne | Sort-Object
$listTwo = $listTwo | Sort-Object

foreach ($location in $listOne){
    $totalDistance += [Math]::Abs($listOne[$listOne.IndexOf($location)] - $listTwo[$listOne.IndexOf($location)])
}


Write-Host "Total Difference is: $totalDistance"