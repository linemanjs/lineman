# notes: due to ../../ paths for images in many css libs we dump images out to the root of dist and generated
#        if your lib requires a different structure to counter this, you'll need to nest your img files in vendor/img accordingly, ie: vendor/img/img
module.exports = (lineman) ->
  config:
    images:
      files:
        "app/img/": "<%= files.img.app %>"
        "vendor/img/": "<%= files.img.vendor %>"

      root: "<%= files.img.root %>"
      dev:
        dest: "generated"

      dist:
        dest: "dist"
