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
    [String] $Template,
    [Parameter(Mandatory = $true)]
    [String] $Variables,
    [Parameter(Mandatory = $true)]
    [String] $Output,
    [Parameter(Mandatory = $false)]
    [Switch] $Force = $false
)

#region Validations

# Ensure all files are input, template, output files are valid

if (!(Test-Path $Template)) {
    Write-Error ("Unable to find {0}" -f $Template)
    return
}

if (!(Test-Path $Variables)) {
    Write-Error ("Unable to find {0}" -f $Variables)
    return 
}

if ((Test-Path $Output) -and !$Force) {
    Write-Error ("Output file {0} exists. Use -Force to overwrite." -f $Output)
    return 
}

#endregion

#region Load Content

# Load and transform input, Load template

$templateContent = Get-Content $Template 
$vars = Get-Content $Variables | ConvertFrom-JSON -AsHashtable

if (!$templateContent) {
    Write-Error ("Unable to load template content from {0}" -f $Template)
    return
}

if (!$vars) {
    Write-Error ("Unable to evaluate variables in {0}" -f $Variables)
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
    $templateContent = $templateContent.Replace("`${$varName}", $var)
}

# Write processed output
Set-Content -Path $Output -Value $templateContent -Force

#endregion