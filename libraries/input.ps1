$ForegroundColor = (get-host).ui.rawui.ForegroundColor

function confirmation
{
    param(
        [string]$Message
    )

    Write-Color -Text "$($Message) [", "y", "/", "n", "]:" `
        -ForegroundColor  $ForegroundColor,Green,$ForegroundColor,Red,$ForegroundColor `
        -NoNewLine
    $confirmation = Read-Host
    if ($confirmation -eq 'y') {
      return $true
    }
    <#
    Write-Color -Text "Red ", "Green ", "Yellow " -Color Red,Green,Yellow
    Write-Host "[" -NoNewLine;
    Write-Host "y" -ForegroundColor Green -NoNewline;
    Write-Host "/" -NoNewLine;
    Write-Host "n" -ForegroundColor Red -NoNewline;
    Write-Host "]" -NoNewLine;
     #>

}
