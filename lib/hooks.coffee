
ReadsConfiguration = require('./reads-configuration')
readsConfiguration = new ReadsConfiguration()

module.exports =
  trigger: (address, args...) ->
    hook = "hooks.#{address}"
    if handler = readsConfiguration.read(hook)
      try
        handler(address, args...)
      catch e
        console.warn """
                     Encountered an exception while invoking hook '#{hook}':

                     Error:

                     #{e.message}

                     Hook source:

                     #{handler.toString()}

                     """
        throw e
