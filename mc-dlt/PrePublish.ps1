[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [String] $TemplateFile,
    [Parameter(Mandatory = $true)]
    [String] $VariableFile,
    [Parameter(Mandatory = $true)]
    [String] $OutputFile,
    [Parameter(Mandatory = $false)]
    [Switch] $Force = $false
)

#region Validations

if (!(Test-Path $TemplateFile)) {
    Write-Error ("Unable to find {0}" -f $TemplateFile)
    return
}

if (!(Test-Path $VariableFile)) {
    Write-Error ("Unable to find {0}" -f $VariableFile)
    return 
}

if ((Test-Path $OutputFile) -and !$Force) {
    Write-Error ("Output file {0} exists. Use -Force to overwrite.")
    return 
}

#endregion

#region Load Content

$template = Get-Content $TemplateFile
$vars = Get-Content $VariableFile | ConvertFrom-JSON -AsHashtable

if (!$template) {
    Write-Error ("Unable to load template content from {0}" -f $TemplateFile)
    return
}

if (!$vars) {
    Write-Error ("Unable to evaluate variables in {0}" -f $VariableFile)
    return
}

#endregion

#region Process

foreach ($varKey in $vars.GetEnumerator()) {
    $varName = $varKey.Name
    $var = $vars[$varName]

    $template = $template.Replace("`${$varName}", $var)
}

Set-Content -Path $OutputFile -Value $template -Force

#endregion