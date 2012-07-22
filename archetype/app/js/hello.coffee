window.hello = ->
  html = JST['app/templates/hello.us'](text: 'Hello, World!')
  $('body').append(html)

$ ->
  hello()
