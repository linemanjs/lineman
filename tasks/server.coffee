###
Task: server
Description: server static files and proxy API (server-side) requests from another port
Dependencies: grunt
Contributor: @dmosher, @searls

Configuration:
"base" - the path from which to serve static assets from (this should almost always be left to the default value of "generated")
"web.port" - the port from which to run the development server (defaults to 8000, can be overridden with ENV variable WEB_PORT)
"apiProxy.port" - the port of the server running an API we want to proxy (does not proxy be default, can be overridden with ENV variable API_PORT)
"apiProxy.enabled" - set to true to enable API proxying; if Lineman can't respond to a request, it will forward it to the API proxy
"apiProxy.host" - the host to which API requests should be proxy, defaults to `localhost`)"
###
module.exports = (grunt) ->
  _ = grunt.util._
  express = require("express")
  httpProxy = require("http-proxy")
  fileUtils = require("./../lib/file-utils")
  watchr = require('watch_r');

  grunt.registerTask "server", "static file & api proxy development server", ->
    apiPort = process.env.API_PORT || grunt.config.get("server.apiProxy.port") || 3000
    apiProxyEnabled = grunt.config.get("server.apiProxy.enabled")
    apiProxyPrefix  = grunt.config.get("server.apiProxy.prefix") || undefined
    apiProxyHost = grunt.config.get("server.apiProxy.host") || "localhost"
    webPort = process.env.WEB_PORT || grunt.config.get("server.web.port") || 8000
    webRoot = grunt.config.get("server.base") || "generated"
    userConfig = fileUtils.loadConfigurationFile("server")
    pushStateEnabled = grunt.config.get("server.pushState")
    app = express()

    userConfig.drawRoutes(app) if userConfig.drawRoutes

    app.configure ->
      app.use express.static("#{process.cwd()}/#{webRoot}")
      app.use apiProxy(apiProxyPrefix, apiProxyHost, apiPort, new httpProxy.RoutingProxy()) if apiProxyEnabled
      app.use express.errorHandler()
      app.use pushStateSimulator(process.cwd(),webRoot) if pushStateEnabled

    grunt.log.writeln("Starting express web server in \"./generated\" on port #{webPort}")
    grunt.log.writeln("Proxying API requests to #{apiProxyHost}:#{apiPort}") if apiProxyEnabled
    grunt.log.writeln("Simulating HTML5 PushState: Serving up '#{webRoot}/index.html' for all other unmatched paths") if pushStateEnabled

    app.listen webPort, ->
      resetRoutesOnServerConfigChange(app)

  pushStateSimulator = (cwd, webRoot) ->
    (req, res, next) ->
      grunt.log.writeln("\nPushState: '#{req.path}' not found in #{cwd}/#{webRoot} - Serving up '#{webRoot}/index.html'")
      res.sendfile("#{webRoot}/index.html")

  apiProxy = (prefix, host, port, proxy) ->
    prefixMatcher = new RegExp(prefix)

    proxy.on "proxyError", (err, req, res) ->
      res.statusCode = 500
      res.write("API Proxying to `#{req.url}` failed with: `#{err.toString()}`")
      res.end()

    return (req, res, next) ->
      if prefix and prefixMatcher.exec(req.path)
        proxy.proxyRequest(req, res, {host: host, port: port})
      else
        next()

  resetRoutesOnServerConfigChange = (app) ->
    watchr grunt.file.expand('config/server.*'), (err, watcher) ->
      watcher.on 'change', (contexts) ->
        _(contexts).each (context) ->
          userConfig = fileUtils.reloadConfigurationFile("server")
          if userConfig.drawRoutes
            _(app.routes).each (route, name) -> app.routes[name] = []
            userConfig.drawRoutes(app)
