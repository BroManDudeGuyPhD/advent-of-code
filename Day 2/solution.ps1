# https://adventofcode.com/2024/day/1
Set-Location "Day 2"
$fileContents = Get-ChildItem -Filter "*.txt" | Get-Content
$allReports = New-Object System.Collections.ArrayList

foreach ($line in $fileContents) {
    $report = $line -split (" ")
    [void]$allReports.Add($report)
}

function Evaluate-Report($report) {
    $lastValue = $decreasing = $increasing = $null

    foreach ($item in $report) {
        #Force item to be an int
        $item = [int]$item

        if ($null -eq $lastValue) {
            # Catches the first item in the array, and sets it to $lastValue
            Write-Host "Evaluating: $($report)"
            $lastValue = $item;
            continue;
        }

        elseif ($null -ne $lastValue) {
            # Evaluates all subsequent items in array
            $difference = [Math]::Abs($lastValue - $item)
            if ($difference -eq 1 -or $difference -eq 2 -or $difference -eq 3) {

                if ($lastValue -gt $item) {
                    $decreasing = $true
                    Write-Host "    $($lastValue) -> $($item): decrease of $($difference)"
                }

                if ($lastValue -lt $item) {
                    $increasing = $true
                    Write-Host "    $($lastValue) -> $($item): increase of $($difference)"
                }

                if ($null -ne $decreasing -and $null -ne $increasing) {
                    return "UNSAFE: Not all decreasing or increasing"
                }
            }
            else {
                #Breaks loop on unsafe increase
                return "UNSAFE: Problematic Increase from $($lastValue) to $($item): $($difference)"
            }
        }
        $lastValue = $item;
    }
    return "SAFE"
}

$safeCounter = 0;
foreach ($report in $allReports) {
    $evaluation = Evaluate-Report $report

    if ($evaluation -eq "SAFE") {
        Write-Host "SAFE"
        Write-Host "======================================================"
        $safeCounter += 1
    }
    elseif ($evaluation -like "UNSAFE*") {
        Write-Host $evaluation
        Write-Host "======================================================"
    }
}

Write-Host "Safe count: $($safeCounter)"
