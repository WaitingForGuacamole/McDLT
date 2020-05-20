const args = require('command-line-args');
const { exception } = require('console');
const { format } = require('util');
const optionDefs = [
    { name: 'verbose', alias: 'v', type: Boolean },
    { name: 'variables', type: String },
    { name: 'template', type: String },
    { name: 'output', type: String },
    { name: 'force', alias: 'f', type: Boolean },
    { name: 'help', alias: 'h', type: Boolean }
]
const options = args(optionDefs, { stopAtFirstUnknown: true });

if (options.help) {
    usage();
} else {
    const fs = require('fs');
    if (fs.existsSync(options.output) && ! options.force) {
        console.error(format("--output %s: file exists, use --force to overwrite", options.output));
        return;
    }

    if (!fs.existsSync(options.template)) {
        console.error(format("--template %s: file doesn't exist", options.template));
        return;
    }
    let template = fs.readFileSync(options.template, "utf-8");

    if (!fs.existsSync(options.variables)) {
        console.error(format("--variables %s: file doesn't exist", options.variables));
        return;
    }
    const variables = require(options.variables);

    Object.keys(variables).forEach(function (varName) {
        const varSelector = "\\$\\{" + varName + "\\}";
        const value = variables[varName];

        if (options.verbose) {
            console.log("${%s} => \"%s\"", varName, value);
        }

        template = template.replace(new RegExp(varSelector, "g"), value);
    });

    fs.writeFileSync(options.output, template, "utf-8");
}

function usage() {
    const usage = require('command-line-usage')
    const sections = [
        {
            header: 'PreProcess',
            content: 'Generates output using a template file and JSON ${variable} substitution'
        },
        {
            header: 'Options',
            optionList: [
                {
                    name: 'variables',
                    typeLabel: '{underline file}',
                    description: 'A JSON file containing a hashtable of name/value pairs'
                },
                {
                    name: 'template',
                    typeLabel: '{underline file}',
                    description: 'A text file containing a references to  ${name}/value pairs'
                },
                {
                    name: 'output',
                    typeLabel: '{underline file}',
                    description: 'Path to processed output'
                },
                {
                    name: 'force',
                    description: 'Overwrite any existing output file'
                },
                {
                    name: 'verbose',
                    description: 'Display additional information during preprocessing'
                },
                {
                    name: 'help',
                    description: 'Print this usage guide.'
                }
            ]
        }
    ]
}