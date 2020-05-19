# PrePublish.ps1
#
# Perform ${variable} substitution in an arbitrary text file
#
# Invoked by vscode:prepublish script reference in package.json
# Facilitates consistent application of theme colors
# Allows semantic naming of values
#
# To create custom themes,
#   Create a theme template - this can be a theme file from a Yeoman generator
#   Create a variables file - this is a JSON hashtable mapping names to values
#   Alter the theme template to replace "#RRGGBBAA" strings with "${variableName}" references
#   Run this script after changing variable values or theme variable references
#
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

# Ensure all files are input, template, output files are valid

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

# Load and transform input, Load template

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

# iterate each variable in the input file
foreach ($varKey in $vars.GetEnumerator()) {
    # resolve name/value pair
    $varName = $varKey.Name
    $var = $vars[$varName]

    # globally replace name reference with value
    $template = $template.Replace("`${$varName}", $var)
}

# Write processed output
Set-Content -Path $OutputFile -Value $template -Force

#endregion