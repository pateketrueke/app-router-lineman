Router = require('router')['default']
thinner = require('thinner')

app = thinner.setup(
  router: new Router()
  el: 'body'
).scope()
