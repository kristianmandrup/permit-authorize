fs          = require 'fs'

module.exports = class RulesFileLoader
  (@file-path, @callback, options = {}) ->
    unless @file-path
      throw Error "Error: Missing filepath: #{@file_path}"

    @validate-callback @callback
    @async = options.async

  validate-callback: (cb) ->
    if typeof! cb isnt 'Function'
      throw new Error "Callback option must be a function, was: #{cb}"

  load-rules: (options) ->
    async = options.async || @async
    @debug "loadRules", @file-path

    if async then @load-rules-async! else @load-rules-sync!

  load-rules-async: ->
    @debug 'loadRulesAsync'
    self = @
    fs.read-file @file-path, 'utf8', (err, data) ->
      self.debug err, data
      if err
        @debug err
        throw Error "Error loading file: #{@file-path} - #{err}"

      self.debug "data", data
      rules = JSON.parse data
      self.debug "loaded-rules", rules
      @callback rules
    @

  load-rules-sync: ->
    try
      data = fs.read-file-sync @file-path, 'utf8' ->
      @debug "data", data
      unless typeof! data is 'String'
        throw Error
      rules = JSON.parse data
      @debug "loaded-rules", rules
      @loaded-rules = rules
      @callback rules
      @
    catch err
      throw Error "Error loading file: #{@file-path} - #{err}"
 
  load-rules-from: (path) ->
    @load-rules path

  load: (path) ->
    @load-rules path