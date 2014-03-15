
module.exports = (grunt) ->
  installDirections = (name) -> """
  To install the plugin, just run:

  $ npm install --save-dev lineman-less

  Then try  `lineman run` again.
  """

  pluginNotices =
    "lineman-less": (name) -> """
    It looks like you've added a Less file to your project. In order for
    Lineman to compile Less, you should install the lineman-less plugin.

    #{installDirections(name)}

    Please note that lineman-less does *not* concatenate all your Less files.
    It looks for "#{grunt.config("files.less.main") || 'app/css/main.less'}" as the main less file,
    from which all other less files should be @import'ed. You
    can import any file relative to either "app/css/" or "vendor/css".

    """
    default: (name) -> """

    There is a lineman plugin named "#{name}" that provides this functionality.

    #{installDirections(name)}

    """

  grunt.registerTask "learnAboutLinemanPlugin", "notify users that a plugin exists for given behavior", (name) ->
    grunt.warn(pluginNotices[name]?(name) || pluginNotices.default(name))
