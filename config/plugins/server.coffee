module.exports = (lineman) ->
  config:
    server:
      base: "generated"
      web:
        port: 8000

      apiProxy:
        enabled: false
        host: "localhost"
        port: 3000
