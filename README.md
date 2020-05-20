# McDLT
## Another (?!) dark theme for VS Code

McDLT is a dark theme that tries to have it both warm and cool, like the burger that inspired it (well, not really).

Overall window chrome and UI is blue to blue-gray, as are language keywords. Text and constants range from brown to off-white.

It's written in a fairly extensible manner, allowing you to define colors as variables, and reference those variables in your theme template. Then, a pre-publish script generates your theme during packaging.

---
## Screenshots

---
### Text
![Text](https://raw.githubusercontent.com/waitingforguacamole/McDLT/master/images/Screenshot-1.png)

---
### Sidebar
![Sidebar](https://raw.githubusercontent.com/waitingforguacamole/McDLT/master/images/Screenshot-2.png)

---
### Powershell
![Powershell highlighting](https://raw.githubusercontent.com/waitingforguacamole/McDLT/master/images/Screenshot-3.png)

---
### Menus
![Menus](https://raw.githubusercontent.com/waitingforguacamole/McDLT/master/images/Screenshot-4.png)

---
## Implementation details

McDLT is a parameterized theme - two source files and a pre-publish script are used to construct a theme:

- template-vars.json: a simple hashtable containing name value pairs
- template-theme.json: a VS Code *-color-theme.json file, with references (via ${name}) to template-vars.json
- your choice of pre-publish script:
    - prepublish.js: a NodeJS script to combine template-vars.json and template-theme.json into an output-color-theme.json file
    - PrePublish.ps1: a Powershell script to do the same

Depending on the pre-publish script you choose, your package.json pre-publish script entry will look like:

### NodeJS:

    ...
    "scripts": {
        "vscode:prepublish": "node ./prepublish.js --template ./themes/template-theme.json --variables ./themes/template-vars.json --output ./themes/your-color-theme.json --force --verbose"
    },
    ...

### PowerShell 7:

    ...
    "scripts": {
        "vscode:prepublish": "pwsh ./PrePublish.ps1 -Template ./themes/template-theme.json -Variables ./themes/template-vars.json -Output ./themes/your-color-theme.json -Force"
    }, 
    ...   
