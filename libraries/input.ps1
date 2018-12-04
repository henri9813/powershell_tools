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
    if ($confirmation -eq 'y')
    {
        return $true
    }
}
