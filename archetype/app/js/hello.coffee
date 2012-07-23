window.hello = ->
  html = JST['app/templates/hello.us'](text: 'Hello, World!')
  document.body.innerHTML += html

if window.addEventListener
  window.addEventListener('load', hello, false)
else
  window.attachEvent('load', hello)