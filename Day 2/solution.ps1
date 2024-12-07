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
            if ($lastValue -gt $item) {
                $decreasing = $true

                if ($difference -eq 1 -or $difference -eq 2 -or $difference -eq 3) {
                    Write-Host "    $($lastValue) -> $($item): decrease of $($difference)"
                }
                else {
                    #Breaks loop on unsafe decrease
                    return "UNSAFE: Large Decrease from $($lastValue) to $($item): $($difference)"
                }
                if ($null -ne $decreasing -and $null -ne $increasing) {
                    return "UNSAFE: Not all increasing"
                }
            }

            elseif ($lastValue -lt $item) {
                $increasing = $true

                if ($difference -eq 1 -or $difference -eq 2 -or $difference -eq 3) {
                    Write-Host "    $($lastValue) -> $($item): increase of $($difference)"
                }
                else {
                    #Breaks loop on unsafe increase
                    return "UNSAFE: Large Increase from $($lastValue) to $($item): $($difference)"
                }
                if ($null -ne $decreasing -and $null -ne $increasing) {
                    return "UNSAFE: Not all decreasing"
                }
            }
            elseif ($lastValue -eq $item) {
                return "UNSAFE: No Change from $($lastValue) to $($item)"
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
        Write-Host "SAFE" -ForegroundColor Green
        Write-Host "======================================================"
        $safeCounter += 1
    }
    elseif ($evaluation -like "UNSAFE*") {
        Write-Host "UNSAFE" -ForegroundColor -Red
        Write-Host "======================================================" -ForegroundColor -Red
    }
}

Write-Host "Safe count: $($safeCounter)"
