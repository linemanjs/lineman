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

module.exports = function(grunt) {
  var _ = grunt.utils._,
      express   = require('express'),
      httpProxy = require('http-proxy');

  grunt.registerTask('server', 'static file & api proxy development server', function() {
    var apiPort = process.env.API_PORT || grunt.config.get("server.apiProxy.port") || 3000,
        apiProxyEnabled = grunt.config.get("server.apiProxy.enabled"),
        apiProxyHost = grunt.config.get("server.apiProxy.host") || 'localhost',
        webPort = process.env.WEB_PORT || grunt.config.get("server.web.port") || 8000,
        webRoot = grunt.config.get("server.base") || "generated",
        app = express();


    app.configure(function() {
      app.use(express.static(process.cwd() + "/" + webRoot));
      if(apiProxyEnabled) {
        app.use(apiProxy(apiProxyHost, apiPort, new httpProxy.RoutingProxy()));
      }
      app.use(express.bodyParser());
      app.use(express.errorHandler());
    });


    grunt.log.writeln('Starting express web server in "./generated" on port '+webPort);
    if(apiProxyEnabled) {
      grunt.log.writeln('Proxying API requests to '+apiProxyHost+':'+apiPort);
    }
    app.listen(webPort);
  });

  var apiProxy = function(host, port, proxy) {
    proxy.on('proxyError', function(err, req, res){
      res.statusCode = 500;
      res.write("API Proxying to `"+req.url+"` failed with: `"+err.toString()+"`");
      res.end();
    });

    return function(req, res, next) {
      proxy.proxyRequest(req, res, {host: host, port: port});
    }
  }
};