var program   = require('commander'),
    grunt     = require('grunt'),
    http      = require('http'),
    fs = require('fs'),
    files     = require(__dirname + '/file-utils.js'),
    libraries = require(__dirname + '/../config/libraries.js'),
    _         = grunt.utils._;



module.exports = {
  fetch: function(libs) {
    var libs = normalizeNames(libs);
    ensureLifeIsGood(libs);
    grunt.log.writeln("Lineman will fetch: "+aToS(libs));

    _(libs).each(function(libraryName) {
      download(libraryName, libraries[libraryName])
    });
  }
};

//Library stuff

download = function(name, lib) {
  grunt.log.writeln("Attempting to fetch '"+name+"' from '"+lib.url+"'");


  var path = filePathFor(name, lib),
      file = fs.createWriteStream(path);
  http.get(lib.url, function(res) {
    res.on('data', function(data) {
      file.write(data);
    }).on('end', function() {
      file.end();
      grunt.log.writeln("'"+name+"' installed to '"+path+"'");
    });
  });
};

//Filename stuff

filePathFor = function(name, lib) {
  var ext = lib.extension || extensionOf(lib.url),
      dir = dirFor(ext);
  return process.cwd()+"/vendor/"+dir+"/"+name+"."+ext;
};

dirFor = function(ext) {
  if(_(["js"]).include(ext)) {
    return "js";
  } else if(_(["css"]).include(ext)) {
    return "css";
  } else if(_(["png, jpg, jpeg, gif"]).include(ext)) {
    return "img";
  } else {
    fail("Lineman doesn't know where to put files with extension '"+ext+"'");
  }
};

extensionOf = function(url) {
  return _(url.match(/\.([^.]*)$/)).last();
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

