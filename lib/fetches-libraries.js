var program   = require('commander'),
    grunt     = require('grunt'),
    http      = require('http'),
    fs = require('fs'),
    files     = require(__dirname + '/file-utils.js'),
    libraries = require(__dirname + '/../config/libraries.js'),
    Tempfile  = require('temporary/lib/file'),
    AdmZip    = require('adm-zip'),
    _         = grunt.utils._;



module.exports = {
  fetch: function(libs) {
    var libs = normalizeNames(libs);
    ensureLifeIsGood(libs);
    grunt.log.writeln("Lineman will fetch: "+aToS(libs));

    _(libs).each(function(libraryName) {
      fetchLibrary(libraryName, libraries[libraryName])
    });
  }
};

//Library stuff

fetchLibrary = function(name, lib) {
  grunt.log.writeln("Attempting to fetch '"+name+"' from '"+lib.url+"'");

  if(isArchive(lib)) {
    fetchArchive(name, lib);
  } else {
    fetchAsset(name, lib);
  }
};

fetchAsset = function(name, lib) {
  var path = filePathForLibrary(name, lib);
  download(lib.url, path, function() {
    grunt.log.writeln("'"+name+"' installed to '"+path+"'");
  });
};

fetchArchive = function(name, lib) {
  var tempfile = new Tempfile;

  download(lib.url, tempfile.path, function() {
    grunt.log.writeln("downloaded");
    var archive = new AdmZip(tempfile.path);

    var entries = _(archive.getEntries()).chain().reject(function(e) {
        return e.isDirectory;
      }).select(function(e) {
        return _(lib.paths).include(e.entryName)
    }).value();

    _(entries).each(function(entry) {
      var dest = filePathForArchiveEntry(entry.entryName);
      grunt.log.writeln("Extracting '"+entry.entryName+"' to '"+dest+"'");

      //FIXME: this completely explodes with CRC failures (and it doesn't read the end of the file)
      archive.extractEntryTo(entry, dest, false, true);
    });

    tempfile.unlink();
  });
}

//Download stuff

download = function(source, destination, callback) {
  var file = fs.createWriteStream(destination);
  http.get(source, function(res) {
    res.on('data', function(data) {
      file.write(data);
    }).on('end', function() {
      file.end();
      callback();
    });
  });
};

//Filename stuff

isArchive = function(lib) {
  return extensionOf(lib) === "zip";
};

filePathForLibrary = function(name, lib) {
  var ext = extensionOf(lib),
      dir = dirNameFor(ext);
  return process.cwd()+"/vendor/"+dir+"/"+name+"."+ext;
};

filePathForArchiveEntry = function(entryPath) {
  var //name = _(entryPath.match(/(?:\/)?([^\/.]*)(?:[^\/]*)?$/)).last(),
      ext  = extensionOf({url: entryPath}),
      dir  = dirNameFor(ext);

  return process.cwd()+"/vendor/"+dir;
};

dirNameFor = function(ext) {
  if(_(["js"]).include(ext)) {
    return "js";
  } else if(_(["css"]).include(ext)) {
    return "css";
  } else if(_(["png", "jpg", "jpeg", "gif"]).include(ext)) {
    return "img";
  } else {
    fail("Lineman doesn't know where to put files with extension '"+ext+"'");
  }
};

extensionOf = function(lib) {
  return lib.extension || _(lib.url.match(/\.([^.]*)$/)).last();
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

