###
# Since lineman delegates to grunt and testem and will someday to others,
# when a user wants to send options directly to that downstream cli, they
# ought to be able to with a -- ("double-tack"), like this:
#
# $ lineman spec-ci -- -f config/spec.json
#
# Should forward everything after -- to testem as additional args
###
_ = require("lodash")

module.exports =
  find: (args = process.argv) ->
    return [] unless _(args).include("--")
    _(args).rest(_(args).lastIndexOf("--") + 1)
