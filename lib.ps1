Function Get-QueryUser() {
    Param([switch]$Json) 
    $HT = @()
    $Lines = @(query user).foreach( { $(($_) -replace ('\s{2,}', ',')) })
    $header = $($Lines[0].split(',').trim())
    for ($i = 1; $i -lt $($Lines.Count); $i++) {
        $Res = "" | Select-Object $header
        $Line = $($Lines[$i].split(',')).foreach( { $_.trim().trim('>') })
        if ($Line.count -eq 5) { $Line = @($Line[0], "$($null)", $Line[1], $Line[2], $Line[3], $Line[4] ) }
        for ($x = 0; $x -lt $($Line.count); $x++) {
            $Res.$($header[$x]) = $Line[$x]
        }
        $HT += $Res
        Remove-Variable Res
    }
    if ($Json) {
        $JsonObj = [PSCustomObject]@{ $($env:COMPUTERNAME) = $HT } | ConvertTo-Json
        Return $JsonObj
    }
    else {
        Return $HT
    }
}
