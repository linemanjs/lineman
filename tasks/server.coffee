###
Task: server
Description: server static files and proxy API (server-side) requests from another port
Dependencies: grunt
Contributor: @davemo, @searls

Configuration:
"base" - the path from which to serve static assets from (this should almost always be left to the default value of "generated")
"web.port" - the port from which to run the development server (defaults to 8000, can be overridden with ENV variable WEB_PORT)
"apiProxy.port" - the port of the server running an API we want to proxy (does not proxy by default, can be overridden with ENV variable API_PORT)
"apiProxy.enabled" - set to true to enable API proxying; if Lineman can't respond to a request, it will forward it to the API proxy
"apiProxy.host" - the host to which API requests should be proxy, defaults to `localhost`)"
"apiProxy.prefix" - an api prefix, to be used in conjunction with server.pushState to correctly identify requests that should go to the apiProxy"
###

module.exports = (grunt) ->
  _ = require("lodash")
  http = require("http")
  express = require("express")
  httpProxy = require("http-proxy")
  fileUtils = require("./../lib/file-utils")
  watchr = require('watch_r-structr-lock')
  fs = require("fs")

  grunt.registerTask "server", "static file & api proxy development server", ->
    apiPort = process.env.API_PORT || grunt.config.get("server.apiProxy.port") || 3000
    apiProxyEnabled = grunt.config.get("server.apiProxy.enabled")
    apiProxyPrefix  = grunt.config.get("server.apiProxy.prefix") || undefined
    apiProxyHost = grunt.config.get("server.apiProxy.host") || "localhost"
    apiProxyChangeOrigin = grunt.config.get("server.apiProxy.changeOrigin")
    webPort = process.env.WEB_PORT || grunt.config.get("server.web.port") || 8000
    webRoot = grunt.config.get("server.base") || "generated"
    staticRoutes = grunt.config.get("server.staticRoutes")
    userConfig = fileUtils.loadConfigurationFile("server")
    pushStateEnabled = grunt.config.get("server.pushState")
    relativeUrlRoot = grunt.config.get("server.relativeUrlRoot")
    @requiresConfig("server.apiProxy.prefix") if pushStateEnabled and apiProxyEnabled

    app = express()
    server = http.createServer(app)

    userConfig.modifyHttpServer?(server)

    app.configure ->
      app.use(express.compress())
      configureLiveReloadMiddleware(app)
      app.use(express.static("#{process.cwd()}/#{webRoot}"))
      mountUserStaticRoutes(app, webRoot, staticRoutes)

      userConfig.drawRoutes?(app)
      addBodyParserCallbackToRoutes(app)

      if apiProxyEnabled
        if pushStateEnabled
          grunt.log.writeln("Proxying API requests prefixed with '#{apiProxyPrefix}' to #{apiProxyHost}:#{apiPort}")
          app.use(prefixMatchingApiProxy(apiProxyPrefix, apiProxyHost, apiPort, apiProxyChangeOrigin, relativeUrlRoot, new httpProxy.RoutingProxy()))
        else
          grunt.log.writeln("Proxying API requests to #{apiProxyHost}:#{apiPort}")
          app.use(apiProxy(apiProxyHost, apiPort, apiProxyChangeOrigin, relativeUrlRoot, new httpProxy.RoutingProxy()))

      app.use(express.bodyParser())
      app.use(express.errorHandler())
      userConfig.drawRoutes?(app)
      app.use(pushStateSimulator(process.cwd(),webRoot)) if pushStateEnabled

    grunt.log.writeln("Starting express web server in '#{webRoot}' on port #{webPort}")
    grunt.log.writeln("Simulating HTML5 pushState: Serving up '#{webRoot}/index.html' for all other unmatched paths") if pushStateEnabled

    applyRelativeUrlRoot(app, relativeUrlRoot).listen webPort, ->
      resetRoutesOnServerConfigChange(app)

  applyRelativeUrlRoot = (app, relativeUrlRoot) ->
    return app unless relativeUrlRoot?
    grunt.log.writeln("Mounting application at path '#{relativeUrlRoot}'.")
    _(express()).tap (otherApp) ->
      otherApp.use(relativeUrlRoot, app)

  configureLiveReloadMiddleware = (app) ->
    return unless livereload = grunt.config.get("livereload")
    return if livereload.injectScript == false
    port = livereload.port || 35729
    grunt.log.writeln("Injecting LiveReload script into HTML documents (port: #{port})")
    app.use(require('connect-livereload')({port}))

  mountUserStaticRoutes = (app, webRoot, staticRoutes) ->
    _(staticRoutes).each (src, dest) ->
      path = if fs.existsSync(src) then src else "#{process.cwd()}/#{webRoot}/#{src}"
      grunt.log.writeln("Mounting static assets found in `#{path}` to route `#{dest}`")
      app.use(dest, express.static(path))

  pushStateSimulator = (cwd, webRoot) ->
    (req, res, next) ->
      grunt.log.writeln("\nPushState: '#{req.path}' not found in #{cwd}/#{webRoot} - Serving up '#{webRoot}/index.html'")
      res.sendfile("#{webRoot}/index.html")

  handleProxyError = (err, req, res) ->
    res.statusCode = 500
    res.write("API Proxying to `#{req.url}` failed with: `#{err.toString()}`")
    res.end()

  prefixMatchingApiProxy = (prefix, host, port, changeOrigin, relativeUrlRoot = "", proxy) ->
    prefixMatcher = new RegExp(prefix)

    proxy.on "proxyError", handleProxyError

    return (req, res, next) ->
      if prefix and prefixMatcher.exec(req.path)
        req.url = relativeUrlRoot + req.url
        proxy.proxyRequest(req, res, {host, port, changeOrigin})
      else
        next()

  apiProxy = (host, port, changeOrigin, relativeUrlRoot = "", proxy) ->
    proxy.on "proxyError", handleProxyError

    return (req, res, next) ->
      req.url = relativeUrlRoot + req.url
      proxy.proxyRequest(req, res, {host, port, changeOrigin})

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
          if userConfig.drawRoutes?
            _(app.routes).each (route, name) -> app.routes[name] = []
            userConfig.drawRoutes(app)
            addBodyParserCallbackToRoutes(app)
