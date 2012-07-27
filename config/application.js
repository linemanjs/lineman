/* Exports an object that defines
 *  all of the configuration needed by the projects'
 *  depended-on grunt tasks.
 */

module.exports = {
  pkg: '<json:package.json>',
  meta: {
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.company %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
  },

  appTasks: {
    common: [
      'coffee',
      'less',
      'lint',
      'handlebars',
      'jst',
      'configure',
      'concat:js',
      'concat:spec',
      'concat:css',
      'images:dev',
      'homepage:dev'
    ],
    watch: [
      'spec:watch',
      'server',
      'watch'
    ],
    dist: [
      'spec:once',
      'min',
      'mincss',
      'images:dist',
      'homepage:dist'
    ]
  },

  //code
  coffee: {
    compile: {
      files: {
        "generated/js/app.coffee.js": "<config:files.coffee.app>",
        "generated/js/spec.coffee.js": "<config:files.coffee.spec>",
        "generated/js/spec-helpers.coffee.js": "<config:files.coffee.specHelpers>"
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
        "generated/css/app.less.css": "<config:files.less.app>"
      }
    }
  },

  //templates
  handlebars: {
    compile: {
      options: {
        namespace: "JST"
      },
      files: {
        "generated/template/handlebars.js": '<config:files.template.handlebars>'
      }
    }
  },
  jst: {
    compile: {
      options: {
        namespace: "JST"
      },
      files: {
        "generated/template/underscore.js": '<config:files.template.underscore>'
      }
    }
  },

  //quality
  spec: {
    files: [
      '<config:files.glob.js.concatenated>',
      '<config:files.glob.js.concatenatedSpec>'
    ]
  },
  lint: {
    files: ['<config:files.js.app>']
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
      src: ['<banner:meta.banner>', '<config:files.js.vendor>', '<config:files.template.generated>', '<config:files.coffee.generated>', '<config:files.js.app>'],
      dest: '<config:files.glob.js.concatenated>'
    },
    spec: {
      src: ['<config:files.js.specHelpers>', '<config:files.coffee.generatedSpecHelpers>', '<config:files.js.spec>', '<config:files.coffee.generatedSpec>'],
      dest: '<config:files.glob.js.concatenatedSpec>'
    },
    css: {
      src: ['<config:files.css.vendor>', '<config:files.less.generated>', '<config:files.css.app>'],
      dest: '<config:files.glob.css.concatenated>'
    }
  },
  // notes: due to ../../ paths for images in many css libs we dump images out to the root of dist and generated
  //        if your lib requires a different structure to counter this, you'll need to nest your img files in vendor/img accordingly, ie: vendor/img/img
  images: {
    files: {
      "app/img/": "<config:files.img.app>",
      "vendor/img/": "<config:files.img.vendor>"
    },
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
  uglify: {},
  min: {
    dist: {
      src: ['<banner:meta.banner>', '<config:concat.js.dest>'],
      dest: "<config:files.glob.js.minified>"
    }
  },
  mincss: {
    compress: {
      files: {
        "dist/css/app.min.css": "<config:concat.css.dest>"
      }
    }
  },

  //cleaning
  clean: {
    js: {
      src: '<config:files.js.concatenated>'
    },
    css: {
      src: '<config:files.css.concatenated>'
    },
    dist: {
      src: ["dist", "generated"]
    }
  },

  //productivity
  server: {
    base: "generated"
  },
  watch: {
    js: {
      files: ['<config:files.glob.js.vendor>', '<config:files.glob.js.app>'],
      tasks: 'configure concat:js'
    },
    coffee: {
      files: '<config:files.glob.coffee.app>',
      tasks: 'configure coffee configure concat:js'
    },

    jsSpecs: {
      files: ['<config:files.glob.js.specHelpers>', '<config:files.glob.js.spec>'],
      tasks: 'configure concat:spec'
    },
    coffeeSpecs: {
      files: ['<config:files.glob.coffee.specHelpers>', '<config:files.glob.coffee.spec>'],
      tasks: 'configure coffee configure concat:spec'
    },

    css: {
      files: '<config:files.glob.css.app>',
      tasks: 'configure concat:css'
    },
    less: {
      files: '<config:files.glob.less.app>',
      tasks: 'configure less configure concat:css'
    },

    handlebars: {
      files: '<config:files.glob.template.handlebars>',
      tasks: 'configure handlebars configure concat:js'
    },
    underscore: {
      files: '<config:files.glob.template.underscore>',
      tasks: 'configure jst configure concat:js'
    },

    images: {
      files: ["<config:files.glob.img.app>", "<config:files.glob.img.vendor>"],
      tasks: 'configure images:dev'
    },
    homepage: {
      files: '<config:homepage.template>',
      tasks: 'configure homepage:dev'
    },

    lint: {
      files: '<config:files.glob.js.app>',
      tasks: 'configure lint'
    }
  }
};