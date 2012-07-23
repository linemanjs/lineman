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
      'concat:css',
      'images:dev',
      'homepage:dev'
    ],
    dist: [
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
  lint: {
    files: ['<config:files.js.app>', '<config:files.js.spec>']
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
      dest: 'generated/js/app.js'
    },
    css: {
      src: ['<config:files.css.vendor>', '<config:files.less.generated>', '<config:files.css.app>'],
      dest: 'generated/css/app.css'
    }
  },
  images: {
    files: {
      "app/img/": "<config:files.img.app>",
      "vendor/img/": "<config:files.img.vendor>"
    },
    dev: {
      dest: "generated/img"
    },
    dist: {
      dest: "dist/img"
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
      dest: 'dist/js/app.min.js'
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
      src: 'generated/js/app.js'
    },
    css: {
      src: 'generated/css/app.css'
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
      files: ['<config:files.js.vendor>', '<config:files.js.app>'],
      tasks: 'concat:js'
    },
    coffee: {
      files: '<config:files.coffee.app>',
      tasks: 'coffee configure concat:js'
    },

    css: {
      files: '<config:files.css.app>',
      tasks: 'concat:css'
    },
    less: {
      files: '<config:files.less.app>',
      tasks: 'less configure concat:css'
    },

    handlebars: {
      files: '<config:files.template.handlebars>',
      tasks: 'handlebars configure concat:js'
    },
    underscore: {
      files: '<config:files.template.underscore>',
      tasks: 'jst configure concat:js'
    },

    images: {
      files: ["<config:files.img.app>", "<config:files.img.vendor>"],
      tasks: 'images:dev'
    },
    homepage: {
      files: '<config:homepage.template>',
      tasks: 'homepage:dev'
    },

    lint: {
      files: '<config:files.js.app>',
      tasks: 'lint'
    }
  }
};