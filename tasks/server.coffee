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
"apiProxy.prefix" - an api prefix, to be used in conjunction with server.pushState to correctly identify requests that should go to the apiProxy"
###
module.exports = (grunt) ->
  _ = grunt.util._
  http = require("http")
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
    @requiresConfig("server.apiProxy.prefix") if pushStateEnabled and apiProxyEnabled
    app = express()
    server = http.createServer(app)

    userConfig.modifyHttpServer(server) if userConfig.modifyHttpServer
            
    app.configure ->
      app.use(express.compress())
      app.use(express.static("#{process.cwd()}/#{webRoot}"))

      userConfig.drawRoutes(app) if userConfig.drawRoutes
      addBodyParserCallbackToRoutes(app)

      if apiProxyEnabled
        if pushStateEnabled
          grunt.log.writeln("Proxying API requests prefixed with '#{apiProxyPrefix}' to #{apiProxyHost}:#{apiPort}")
          app.use(prefixMatchingApiProxy(apiProxyPrefix, apiProxyHost, apiPort, new httpProxy.RoutingProxy()))
        else
          grunt.log.writeln("Proxying API requests to #{apiProxyHost}:#{apiPort}")
          app.use(apiProxy(apiProxyHost, apiPort, new httpProxy.RoutingProxy()))

      app.use(express.bodyParser())
      app.use(express.errorHandler())
      userConfig.drawRoutes(app) if userConfig.drawRoutes
      app.use(pushStateSimulator(process.cwd(),webRoot)) if pushStateEnabled

    grunt.log.writeln("Starting express web server in \"./generated\" on port #{webPort}")
    grunt.log.writeln("Simulating HTML5 pushState: Serving up '#{webRoot}/index.html' for all other unmatched paths") if pushStateEnabled

    server.listen webPort, ->
      resetRoutesOnServerConfigChange(app)

  pushStateSimulator = (cwd, webRoot) ->
    (req, res, next) ->
      grunt.log.writeln("\nPushState: '#{req.path}' not found in #{cwd}/#{webRoot} - Serving up '#{webRoot}/index.html'")
      res.sendfile("#{webRoot}/index.html")

  handleProxyError = (err, req, res) ->
    res.statusCode = 500
    res.write("API Proxying to `#{req.url}` failed with: `#{err.toString()}`")
    res.end()

  prefixMatchingApiProxy = (prefix, host, port, proxy) ->
    prefixMatcher = new RegExp(prefix)

    proxy.on "proxyError", handleProxyError

    return (req, res, next) ->
      if prefix and prefixMatcher.exec(req.path)
        proxy.proxyRequest(req, res, {host, port})
      else
        next()

  apiProxy = (host, port, proxy) ->
    proxy.on "proxyError", handleProxyError

    return (req, res, next) ->
      proxy.proxyRequest(req, res, {host, port})

  addBodyParserCallbackToRoutes = (app) ->
    bodyParser = express.bodyParser()
    _(["get", "post", "patch", "put", "delete", "options", "head"]).each (verb) ->
      _(app.routes[verb]).each (route) ->
        route.callbacks.unshift(bodyParser)

  resetRoutesOnServerConfigChange = (app) ->
    watchr grunt.file.expand('config/server.*'), (err, watcher) ->
      watcher.on 'change', (contexts) ->
        _(contexts).each (context) ->
          userConfig = fileUtils.reloadConfigurationFile("server")
          if userConfig.drawRoutes
            _(app.routes).each (route, name) -> app.routes[name] = []
            userConfig.drawRoutes(app)
            addBodyParserCallbackToRoutes(app.routes)
