/**
 * Task: server
 * Description: server static files and proxy API (server-side) requests from another port
 * Dependencies: grunt
 * Contributor: @dmosher, @searls
 *
 * Configuration:
 *   "api.port" - the port of the server running an API we want to proxy (does not proxy be default, can be overridden with ENV variable API_PORT)
 *   "web.port" - the port from which to run the development server (defaults to 8000, can be overridden with ENV variable WEB_PORT)
 */

var apiProxy = function(host, port, proxy) {
  return function(req, res, next) {
    if(req.url.match(new RegExp('^\/api\/'))) {
      proxy.proxyRequest(req, res, {host: host, port: port});
    } else {
      next();
    }
  }
}

module.exports = function(grunt) {
  var _ = grunt.utils._,
      express   = require('express'),
      httpProxy = require('http-proxy');

  grunt.registerTask('server', 'static file & api proxy development server', function() {
    var apiPort = process.env.API_PORT || grunt.config.get("server.api.port"),
        webPort = process.env.WEB_PORT || grunt.config.get("server.web.port"),
        app = express();

    if(apiPort) {
      var proxy = new httpProxy.RoutingProxy();
    }

    app.configure(function() {
      app.use(express.static(process.cwd() + "/generated"));
      app.use(apiProxy('localhost', apiPort, proxy));
      app.use(express.bodyParser());
      app.use(express.errorHandler());
    });


    grunt.log.writeln('Starting express web server in "./generated" on port '+webPort);
    app.listen(webPort);
  });
};