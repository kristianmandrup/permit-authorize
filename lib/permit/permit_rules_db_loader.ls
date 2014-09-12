lo        = require '../util/lodash_lite'
Debugger  = require '../debugger'

class PermitRulesDbLoader extends PermitRulesLoader implements Debugger
  (@file-path) ->
    super

  load-db: (@options = {}) ->
    @connect-db!
    @load-data!
    @loaded-rules = JSON.parse data
    @process-rules!

  # connect to DB
  connect-db: ->

  # load the rules from DB into a JSON structure
  load-data: ->

module.exports = PermitRulesDbLoader