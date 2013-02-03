/* Exports an object that defines
 *  all of the configuration needed by the projects'
 *  depended-on grunt tasks.
 */

var grunt = require('grunt');
module.exports = {
  pkg: grunt.file.readJSON('package.json'),
  meta: {
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.company %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
  },

  appTasks: {
    common: [
      'coffee',
      'less',
      'jshint',
      'handlebars',
      'jst',
      'configure',
      'concat:js',
      'concat:spec',
      'concat:css',
      'images:dev',
      'webfonts:dev',
      'homepage:dev'
    ],
    dev: [
      'connect:dev',
      'watch'
    ],
    dist: [
      'uglify:js',
      'uglify:css',
      'images:dist',
      'webfonts:dist',
      'homepage:dist'
    ]
  },

  //code
  coffee: {
    compile: {
      files: {
        "generated/js/app.coffee.js": "<%= files.coffee.app %>",
        "generated/js/spec.coffee.js": "<%= files.coffee.spec %>",
        "generated/js/spec-helpers.coffee.js": "<%= files.coffee.specHelpers %>"
      }
    }
  },

  //style
  less: {
    compile: {
      options: {
        paths: ["app/css", "vendor/css"]
      },
      files: {
        "generated/css/app.less.css": "<%= files.less.app %>"
      }
    }
  },

  //templates
  handlebars: {
    compile: {
      options: {
        namespace: "JST",
        wrapped: true
      },
      files: {
        "generated/template/handlebars.js": '<%= files.template.handlebars %>'
      }
    }
  },
  jst: {
    compile: {
      options: {
        namespace: "JST"
      },
      files: {
        "generated/template/underscore.js": '<%= files.template.underscore %>'
      }
    }
  },

  //quality
  spec: {
    files: [
      '<%= files.glob.js.concatenated %>',
      '<%= files.glob.js.concatenatedSpec %>'
    ]
  },
  jshint: {
    files: ['<%= files.js.app %>']
  },
  jshint: {
    options: {
      curly: true,
      eqeqeq: true,
      latedef: true,
      newcap: true,
      noarg: true,
      sub: true,
      undef: false,
      boss: true,
      eqnull: true,
      browser: true
    }
  },


  //distribution
  concat:{
    js: {
      src: ['<banner:meta.banner>', '<%= files.js.vendor %>', '<%= files.template.generated %>', '<%= files.coffee.generated %>', '<%= files.js.app %>'],
      dest: '<%= files.glob.js.concatenated %>'
    },
    spec: {
      src: ['<%= files.js.specHelpers %>', '<%= files.coffee.generatedSpecHelpers %>', '<%= files.js.spec %>', '<%= files.coffee.generatedSpec %>'],
      dest: '<%= files.glob.js.concatenatedSpec %>'
    },
    css: {
      src: ['<%= files.css.vendor %>', '<%= files.less.generated %>', '<%= files.css.app %>'],
      dest: '<%= files.glob.css.concatenated %>'
    }
  },
  // notes: due to ../../ paths for images in many css libs we dump images out to the root of dist and generated
  //        if your lib requires a different structure to counter this, you'll need to nest your img files in vendor/img accordingly, ie: vendor/img/img
  images: {
    files: {
      "app/img/": "<%= files.img.app %>",
      "vendor/img/": "<%= files.img.vendor %>"
    },
    root: "<%= files.glob.img.root %>",
    dev: {
      dest: "generated"
    },
    dist: {
      dest: "dist"
    }
  },

  webfonts: {
    files: {
      "vendor/webfonts/" : "<%= files.webfonts.vendor %>"
    },
    root: "<%= files.glob.webfonts.root %>",
    dev: {
      dest: "generated"
    },
    dist: {
      dest: "dist"
    }
  },
  homepage: {
    template: 'app/templates/homepage.us',
    dev: {
      dest: 'generated/index.html',
      context: {
        js: 'js/app.js',
        css: 'css/app.css'
      }
    },
    dist: {
      dest: 'dist/index.html',
      context: {
        js: 'js/app.min.js',
        css: 'css/app.min.css'
      }
    }
  },

  //optimizing
  uglify: {
    options: {
      banner: '<%= meta.banner %>'
    },
    js: {
      'generated/js/app.js' : "<%= files.glob.js.minified %>"
    },
    css: {
      "dist/css/app.min.css": "<%= files.css.concatenated %>"
    }
  },

  //cleaning
  clean: {
    js: {
      src: '<%= files.js.concatenated %>'
    },
    css: {
      src: '<%= files.css.concatenated %>'
    },
    dist: {
      src: ["dist", "generated"]
    }
  },

  //productivity
  server: {
    base: "generated",
    web: {
      port: 8000
    },
    apiProxy: {
      enabled: false,
      host: 'localhost',
      port: 3000
    }
  },
  watch: {
    js: {
      files: ['<%= files.glob.js.vendor %>', '<%= files.glob.js.app %>'],
      tasks: 'configure concat:js'
    },
    coffee: {
      files: '<%= files.glob.coffee.app %>',
      tasks: 'configure coffee configure concat:js'
    },

    jsSpecs: {
      files: ['<%= files.glob.js.specHelpers %>', '<%= files.glob.js.spec %>'],
      tasks: 'configure concat:spec'
    },
    coffeeSpecs: {
      files: ['<%= files.glob.coffee.specHelpers %>', '<%= files.glob.coffee.spec %>'],
      tasks: 'configure coffee configure concat:spec'
    },

    css: {
      files: '<%= files.glob.css.app %>',
      tasks: 'configure concat:css'
    },
    less: {
      files: '<%= files.glob.less.app %>',
      tasks: 'configure less configure concat:css'
    },

    handlebars: {
      files: '<%= files.glob.template.handlebars %>',
      tasks: 'configure handlebars configure concat:js'
    },
    underscore: {
      files: '<%= files.glob.template.underscore %>',
      tasks: 'configure jst configure concat:js'
    },

    images: {
      files: ["<%= files.glob.img.app %>", "<%= files.glob.img.vendor %>"],
      tasks: 'configure images:dev'
    },
    homepage: {
      files: '<%= homepage.template %>',
      tasks: 'configure homepage:dev'
    },

    lint: {
      files: '<%= files.glob.js.app %>',
      tasks: 'configure lint'
    }
  }
};
