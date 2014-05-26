module.exports = (lineman) ->
  config:
    copy:
      dev:
        files: [
            expand: true
            cwd: "vendor/static"
            src: "**"
            dest: 'generated'
          ,
            expand: true
            cwd: "app/static"
            src: "**"
            dest: 'generated'
        ]

      dist:
        files: [
            expand: true
            cwd: "vendor/static"
            src: "**"
            dest: 'dist'
          ,
            expand: true
            cwd: "app/static"
            src: "**"
            dest: 'dist'
        ]
