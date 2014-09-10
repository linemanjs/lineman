module.exports = (lineman) ->
  config:
    server:
      base: "generated"
      web:
        port: 8000

      apiProxy:
        enabled: false
        changeOrigin: true
        host: "localhost"
        port: 3000

      liveReload:
        enabled: false
        port: 35729
