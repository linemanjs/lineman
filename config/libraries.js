/* Exports an object that defines
 *  all of the downloadable libraries
 */

module.exports = {
  backbone: {
    url: "http://backbonejs.org/backbone.js",
    dependsOn: ["underscore"]
  },
  bootstrap: {
    url: "http://twitter.github.com/bootstrap/assets/bootstrap.zip"
    paths: [
      "css/bootstrap-responsive.css",
      "css/bootstrap.css",
      "img/glyphicons-halflings-white.png",
      "img/glyphicons-halflings.png",
      "js/bootstrap.js"
    ]
  },
  jQuery: {
    url: "http://code.jquery.com/jquery-latest.js"
  },
  underscore: {
    url: "http://underscorejs.org/underscore.js"
  }
}