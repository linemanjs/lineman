#!/usr/bin/env node
require('coffee-script')
var program = require('commander'),
    grunt   = require('grunt'),
    files   = require('./lib/file-utils'),
    npm     = require('./lib/npm-utils'),
    cli     = require('grunt/lib/grunt/cli'),
    _       = grunt.util._;


program
  .version(require('./package').version)
  .option("--skip-install", "Skip the `npm install` step when creating a new project")
_(cli.optlist).each(function(option, name){
  if(!_(["help", "version"]).include(name)) {
    program.option((option.short ? "-"+option.short+", " : "")+"--"+name, option.info);
  }
});

program
  .command('new')
  .description(' - generates a new lineman project in the specified folder : lineman new my-project')
  .action(function(projectName) {
    var src  = __dirname + "/archetype/",
        dest = process.cwd() + "/" + projectName;
    console.log(" - Assembling your new project directory in '" + dest + "'...");
    files.copyDir(src, dest);
    files.overwritePackageJson(dest + "/package.json", projectName);
    files.copy(dest + "/.npmignore", dest + "/.gitignore")
    if(program.skipInstall) {
      console.log(" - Skipping `npm install`. You may need to run this yourself while inside the new `"+projectName+"` directory later.");
      printWelcome(projectName);
    } else {
      npm.installFrom(dest, function(error) {
        error ? printError() : printWelcome(projectName);
      });
    }
});

program
  .command('run')
  .description(' - runs the development server from /generated and watches files for updates')
  .action(function(context) {
    process.env['LINEMAN_RUN'] = true;
    cli.tasks = ["common", "dev"];
    grunt.cli();
  });

program
  .command('build')
  .description(' - compiles all assets into a production ready form in the /dist folder')
  .action(function() {
    cli.tasks = ["common", "dist"];
    grunt.cli();
  });

program
    .command('spec')
    .description(' - runs specs in Chrome, override in config/spec.json')
    .action(function() {
      cli.tasks = ["spec"];
      grunt.cli();
    });

program
    .command('spec-ci')
    .description(' - runs specs in a single pass using PhantomJS and outputs in TAP13 format, override in config/spec.json')
    .action(function() {
      cli.tasks = ["common","spec-ci"];
      grunt.cli();
    });

program
    .command('clean')
    .description(' - cleans out /generated and /dist folders')
    .action(function() {
      cli.tasks = ["clean"];
      grunt.cli();
    });

program
  .command('grunt')
  .description('Run a grunt command with lineman\'s version of grunt')
  .action(function(){
    cli.tasks = grunt.util._(arguments).
      chain().toArray().
        initial().
        without('grunt').
        value();

    grunt.cli({gruntfile: (__dirname+"/Gruntfile.coffee")});
  });

program
    .command('*')
    .description('unknown command')
    .action(function(){
      program.help()
    });

var printError = function(){
  console.info("Oh no! Please consider opening a new issue with your log output at:\n"+
               "\nhttps://github.com/testdouble/lineman/issues \n\n"+
               "We're terribly sorry for the inconvenience!");
};

var printWelcome = function(projectName){
  console.info(' - Created a new project in "'+projectName+'/" with Lineman. Yay!\n'+
              '\n'+
              'Getting started:\n'+
              '  1. `cd '+projectName+'` into your new project directory\n'+
              '  2. Start working on your project!\n'+
              '    * `lineman run` starts a web server at http://localhost:8000\n'+
              '    * `lineman build` bundles a distribution in the "dist" directory\n'+
              '    * `lineman clean` empties the "dist" and "generated" directories\n'+
              '    * `lineman spec` runs specs from the "specs" directory using testem'+
              '\n'+
              'For more info, check out http://github.com/testdouble/lineman');

};

program.parse(process.argv)
