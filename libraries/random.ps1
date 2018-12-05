function RandomString()
{
    param(
        [Parameter(Mandatory=$true)][Int32]$size
    )
    return -join ((65..90) + (97..122) | Get-Random -Count $size | % {[char]$_})
}
