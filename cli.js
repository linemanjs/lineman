#!/usr/bin/env node
var grunt = require('grunt'),
    fs = require('fs'),
    _ = grunt.utils._,
    name = process.argv[2];

if(!name) {
  console.error("usage: `groan <project_name>`");
  process.exit(1);
}

var mkdirIfNecessary = function(src, dest) {
  var checkDir = fs.statSync(src);
  try {
    fs.mkdirSync(dest, checkDir.mode);
  } catch (e) {
    if (e.code !== 'EEXIST') {
      throw e;
    }
  }
};

var copyDir = function(src, dest) {
  mkdirIfNecessary(src, dest);
  var paths = fs.readdirSync(src);

  _(paths).each(function(path) {
    var path = "/" + path,
        srcPath = src + path,
        destPath = dest + path,
        file = fs.lstatSync(srcPath);

    if(file.isDirectory()) {
      copyDir(srcPath, destPath);
    } else if(file.isSymbolicLink()) {
      fs.symlinkSync(fs.readlinkSync(srcPath), destPath);
    } else {
      fs.writeFileSync(destPath, fs.readFileSync(srcPath));
    }
  });
};

var src = __dirname+"/archetype/",
    dest = process.cwd() + "/" + name;

copyDir(src, dest);

console.log('Created a new project in "'+name+'" -- Yay!\n'+
            '\n'+
            'Getting started:\n'+
            '  1. Run `cd '+name+'` to change into your new project directory\n'+
            '  2. Run `npm install` to install dependencies\n'+
            '  3. Start working on your project:\n'+
            '    * `grunt run` starts a web server at http://localhost:8000\n'+
            '    * `grunt` bundles a distribution in the "dist" directory\n'+
            '    * `grunt clean` empties the "dist" and "generated" directories\n'+
            '\n'+
            'For more info, check out http://github.com/testdouble/groan'
);

