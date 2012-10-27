var program   = require('commander'),
    grunt     = require('grunt'),
    files     = require(__dirname + '/file-utils.js'),
    libraries = require(__dirname + '/../config/libraries.js'),
    _         = grunt.utils._;



module.exports = {
  install: function(librariesToInstall) {
    var libs = normalizeNames(librariesToInstall);
    ensureLifeIsGood(libs);
    grunt.log.writeln("Lineman will fetch: "+aToS(libs));

    _(libs).each(function(libraryName) {
      download(libraryName, libraries[libraryName])
    });


    grunt.log.writeln("YAY");
  }
};

//Library stuff

download = function(name, lib) {
  grunt.log.writeln("Attempting to fetch '"+name+"' from '"+lib.url+"'");

};

//Data stuff

knownLibraryNames = function() {
  return normalizeNames(_(libraries).keys());
};

normalizeNames = function(list) {
  return _(list).map(function(n) { return n.toLowerCase(); });
};

//Validation stuff

ensureLifeIsGood = function(list) {
  ensureListIsntEmpty(list);
  ensureAllLibrariesAreKnown(list);
};

ensureListIsntEmpty = function(list) {
  if(!list || list.length === 0) {
    fail("No libraries selected");
  }
};

ensureAllLibrariesAreKnown = function(list) {
  var knownLibs = knownLibraryNames(),
      unknownLibs = _(list).select(function(desired) {
                      return !_(knownLibs).include(desired);
                    });

  if(unknownLibs.length > 0) {
    fail("Lineman doesn't know how to fetch libraries: "+aToS(unknownLibs));
  }
};

//Message stuff

fail = function(message) {
  newLine();
  grunt.log.writeln("Error: "+message);
  newLine();
  grunt.log.writeln(usage());
  process.exit(1);
};

usage = function() {
  return "usage: $ lineman fetch <library_name> \n\n"+
         "available libraries: \n"+
         _(knownLibraryNames()).map(function(l){ return " - "+l;}).join("\n");
};

//Stringy stuff
newLine = function() {
  grunt.log.writeln();
};

aToS = function(a) {
  return "["+a.join(", ")+"]";
};

