Debugger          = require '../../../util' .Debugger
PermitRulesLoader = require './permit_rules_loader'

module.exports = class PermitRulesDbLoader extends PermitRulesLoader implements Debugger
  (@file-path) ->
    super

  load-db: (@options = {}) ->
    @connect-db!
    @load-data!

  # connect to DB
  connect-db: ->

  # load the rules from DB into a JSON structure
  load-data: ->
