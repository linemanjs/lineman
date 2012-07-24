#!/usr/bin/env node
var files = require(__dirname+"/lib/file-utils.js"),
    name = process.argv[2];

if(!name) {
  console.error("usage: `lineman <project_name>`");
  process.exit(1);
}

var src = __dirname+"/archetype/",
    dest = process.cwd() + "/" + name;

files.copyDir(src, dest);
files.overwritePackageJson(dest + "/package.json", name);

console.log('Created a new project in "'+name+'/" with Lineman. Yay!\n'+
            '\n'+
            'Getting started:\n'+
            '  1. Run `cd '+name+'` to change into your new project directory\n'+
            '  2. Run `npm install` to install dependencies\n'+
            '  3. Start working on your project:\n'+
            '    * `grunt run` starts a web server at http://localhost:8000\n'+
            '    * `grunt` bundles a distribution in the "dist" directory\n'+
            '    * `grunt clean` empties the "dist" and "generated" directories\n'+
            '\n'+
            'For more info, check out http://github.com/testdouble/lineman'
);

