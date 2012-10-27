#!/usr/bin/env node

var program   = require('commander'),
    grunt     = require('grunt'),
    files     = require(__dirname + '/lib/file-utils.js'),
    npm       = require(__dirname + '/lib/npm-utils.js'),
    appTasks  = require(__dirname + '/config/application.js').appTasks,
    _         = grunt.utils._,
    cli       = require('grunt/lib/grunt/cli'),
    libraries = require(__dirname + '/config/libraries.js');

program.version(require(__dirname + '/package').version);

program
    .command('new')
    .description(' - generates a new lineman project in the specified folder : lineman new my-project')
    .action(function(project_name) {
      var src  = __dirname + "/archetype/",
          dest = process.cwd() + "/" + project_name;
          console.log(" - Assembling your new project directory in '" + dest + "'...");
          files.copyDir(src, dest);
          files.overwritePackageJson(dest + "/package.json", project_name)
          npm.installFrom(dest, function(error) {
            if(error) {
              console.info("Oh no! Please consider opening a new issue with your log output at:\n"+
                           "\nhttps://github.com/testdouble/lineman/issues \n\n"+
                           "We're terribly sorry for the inconvenience!");
            } else {
              console.info(' - Created a new project in "'+project_name+'/" with Lineman. Yay!\n'+
                          '\n'+
                          'Getting started:\n'+
                          '  1. `cd '+project_name+'` into your new project directory\n'+
                          '  2. Start working on your project!\n'+
                          '    * `lineman run` starts a web server at http://localhost:8000\n'+
                          '    * `lineman build` bundles a distribution in the "dist" directory\n'+
                          '    * `lineman clean` empties the "dist" and "generated" directories\n'+
                          '    * `lineman spec` runs specs from the "specs" directory using testem'+
                          '\n'+
                          'For more info, check out http://github.com/testdouble/lineman');
            }
          });
    });

program
    .command('run')
    .description(' - runs the development server from /generated and watches files for updates')
    .action(function() {
      cli.tasks = _.union(appTasks.common, appTasks.watch).join(' ');
      grunt.cli();
    });

program
    .command('build')
    .description(' - compiles all assets into a production ready form in the /dist folder')
    .action(function() {
      cli.tasks = _.union(appTasks.common, appTasks.dist).join(' ');
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
      cli.tasks = _.union(appTasks.common, ["spec-ci"]).join(' ');
      grunt.cli();
    });

program
    .command('fetch')
    .description(' - downloads a known third-party library (e.g. '+_(libraries).keys().join(', ')+')')
    .action(function() {
      var libs = _(arguments).chain().toArray().initial().value();
      require(__dirname + '/lib/fetches-libraries.js').fetch(libs);
    });

program
    .command('clean')
    .description(' - cleans out /generated and /dist folders')
    .action(function() {
      cli.tasks = ["clean"];
      grunt.cli();
    });

program.parse(process.argv);