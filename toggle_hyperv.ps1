<#
    toggle HYPER-V
    version 1.0
#>
. "$PSScriptRoot\libraries\uac.ps1"
. "$PSScriptRoot\libraries\input.ps1"

Use-RunAs

$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online

Write-Host "Current  $($hyperv.FeatureName) state: $($hyperv.State)"

$action = If ($($hyperv.State)) {"disable"} Else {"enable"}

if(confirmation("Do you want to $($action) $($hyperv.FeatureName)"))
{
    try
    {
        if($($hyperv.State)) {
            Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
        }
        else {
            Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
        }
    }
    catch
    {
        Write-Color -Text "Error" -ForegroundColor Red
        echo $_.Exception.Message
        break
    }
}
