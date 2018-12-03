<#
    toggle HYPER-V
    version 1.0
#>
. "$PSScriptRoot\libraries\uac.ps1"
. "$PSScriptRoot\libraries\input.ps1"

Use-RunAs

$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online

Write-Host "Current  $($hyperv.FeatureName) state: $($hyperv.State)"

if(confirmation("Do you want to enable $($hyperv.FeatureName)"))
{
    if($hyperv.State -eq "Enabled") {
        Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
    }
    else {
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
    }
}
Pause
