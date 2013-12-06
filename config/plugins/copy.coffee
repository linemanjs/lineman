module.exports = (lineman) ->
  config:
    copy:
      dev:
        files: [
          expand: true
          cwd: "app/static"
          src: "**"
          dest: 'generated'
        ]

      dist:
        files: [
          expand: true
          cwd: "app/static"
          src: "**"
          dest: 'dist'
        ]

