
ReadsConfiguration = require('./reads-configuration')
readsConfiguration = new ReadsConfiguration()

module.exports =
	trigger: (address, args...) ->
		if handler = readsConfiguration.read("hooks.#{address}")
			handler(address, args...)
