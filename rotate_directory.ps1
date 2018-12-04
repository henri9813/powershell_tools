<#
    Rotate a whole directory
    version 1.0
#>

param (
    [Parameter(Mandatory=$true)][ValidateScript({Test-Path $_})][string]$path
)

$date = $(get-date -f yyyy-MM-dd-hh-mm-ss)

Write-Color -Text "Creating new directory : " -NoNewLine
Try
{
    $Folder = New-Item "$($path)\$($date)" -ItemType Directory -Force
    Write-Color -Text "Ok" -ForegroundColor Green
}
Catch
{
    Write-Color -Text "Error" -ForegroundColor Red
    echo $_.Exception.Message
    Break
}

Write-Color -Text "Moving files : " -NoNewLine
Try
{
    Get-ChildItem "$($path)" |
    Foreach-Object {
        if ([string]$_.BaseName -eq $($Folder.BaseName)) {
            return
        }
        elseif ([string]$_.BaseName -as [DateTime] -and [string]$_.Extension -eq ".zip") {
            return
        }
        else {
            $_.MoveTo("$($Folder.FullName)\$($_.BaseName).$($_.Extension)")
        }
    }
    Write-Color -Text "Ok" -ForegroundColor Green
}
Catch
{
    Write-Color -Text "Error" -ForegroundColor Red
    echo $_.Exception.Message
    echo $_.Exception.ItemName
    Break
}

Write-Color -Text "Compressig directory : " -NoNewLine
Try
{
    #https://github.com/PowerShell/Microsoft.PowerShell.Archive/issues/19
    #Compress-Archive -DestinationPath "$($Folder.FullName).zip" -CompressionLevel "Optimal" -LiteralPath "$($Folder.FullName)"
    #Install-Module -Name 7Zip4Powershell
    Compress-7Zip -Path "$($Folder.FullName)" -ArchiveFileName "$($Folder.FullName).zip" -Format "Zip" -CompressionLevel "Ultra"
    Write-Color -Text "Ok" -ForegroundColor Green
}
Catch
{
    Write-Color -Text "Error" -ForegroundColor Red
    echo $_.Exception.Message
    Break
}

Write-Color -Text "Remove directory : " -NoNewLine
Try
{
    $Folder.Remove()
    Write-Color -Text "Ok" -ForegroundColor Green
}
Catch
{
    Write-Color -Text "Error" -ForegroundColor Red
    echo $_.Exception.Message
    Break
}
