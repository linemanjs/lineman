#!/usr/bin/env node
var files = require(__dirname+"/lib/file-utils.js"),
    npm = require(__dirname+"/lib/npm-utils.js"),
    name = process.argv[2];

if(!name) {
  console.error("usage: `lineman <project_name>`");
  process.exit(1);
}

var src = __dirname+"/archetype/",
    dest = process.cwd() + "/" + name;

console.info(" - Assembling your new project directory in '/"+name+"'...");
files.copyDir(src, dest);
files.overwritePackageJson(dest + "/package.json", name);

npm.installFrom(dest, function(error){
  console.info(' - Created a new project in "'+name+'/" with Lineman. Yay!\n'+
              '\n'+
              'Getting started:\n'+
              '  1. `cd '+name+'` into your new project directory\n'+
              '  2. Start working on your project!\n'+
              '    * `grunt run` starts a web server at http://localhost:8000\n'+
              '    * `grunt` bundles a distribution in the "dist" directory\n'+
              '    * `grunt clean` empties the "dist" and "generated" directories\n'+
              '\n'+
              'For more info, check out http://github.com/testdouble/lineman'
  );
});