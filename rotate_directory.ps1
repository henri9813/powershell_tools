<#
    Rotate a whole directory
    version 1.0
#>

param (
    [Parameter(Mandatory=$true)][ValidateScript({Test-Path $_})][string]$path
)

. "$PSScriptRoot\libraries\random.ps1"

Write-Color -Text "Creating new directory : " -NoNewLine
try
{
    $Folder = New-Item "$($path)\$(RandomString(50))" -ItemType Directory -Force
    $Folder.Attributes = "Hidden"
    Write-Color -Text "Ok" -ForegroundColor Green
}
catch
{
    Write-Color -Text "Error" -ForegroundColor Red
    echo $_.Exception.Message
    break
}

Write-Color -Text "Moving files : " -NoNewLine
try
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
            $_.MoveTo("$($Folder.FullName)\$($_.BaseName)$($_.Extension)")
        }
    }
    Write-Color -Text "Ok" -ForegroundColor Green
}
catch
{
    Write-Color -Text "Error" -ForegroundColor Red
    echo $_.Exception.Message
    echo $_.Exception.ItemName
    break
}

Write-Color -Text "Compressig directory : " -NoNewLine
try
{
    $date = Get-Date -format yyyy-MM-dd
    #https://github.com/PowerShell/Microsoft.PowerShell.Archive/issues/19
    #Compress-Archive -DestinationPath "$($Folder.FullName).zip" -CompressionLevel "Optimal" -LiteralPath "$($Folder.FullName)"
    #Install-Module -Name 7Zip4Powershell
    Compress-7Zip -Path "$( $Folder.FullName )" -ArchiveFileName "$( $path )\$( $date ).zip" -Format "Zip" -CompressionLevel "Ultra"
    Write-Color -Text "Ok" -ForegroundColor Green
}
catch
{
    Write-Color -Text "Error" -ForegroundColor Red
    echo $_.Exception.Message
    break
}

Write-Color -Text "Remove directory : " -NoNewLine
try
{
    Remove-Item $Folder.FullName -Recurse -Force
    Write-Color -Text "Ok" -ForegroundColor Green
}
catch
{
    Write-Color -Text "Error" -ForegroundColor Red
    echo $_.Exception.Message
    break
}
