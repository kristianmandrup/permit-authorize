require 'sugar'
_ = require 'prelude-ls'

underscore = (...items) ->
  items = items.flatten!
  strings = items.map (item) ->
    String(item)
  _.map (.underscore!), strings

file-path = (...paths) ->
  upaths = underscore(paths)
  ['.', upaths].flatten!.join '/'

test-path = (...paths) ->
  file-path 'test', ...paths

lib-path = (...paths) ->
  file-path 'lib', ...paths

module.exports =
  util: (path) ->
    @lib 'util', path

  mw: (path) ->
    @lib 'mw', path

  rule: (path) ->
    @lib 'rule', path

  permit: (path) ->
    @lib 'permit', path

  test: (...paths) ->
    require test-path(paths)

  fixture: (path) ->
    @test 'fixtures', path

  # alias
  fix: (path) ->
    @fixture path

  factory: (path) ->
    @test 'factories', path

  # alias
  fac: (path) ->
    @factory path

  file: (...paths) ->
    require file-path(paths)

  lib: (...paths) ->
    require lib-path(paths)

  afile: (path) ->
    require ['.', path].join '/'

  # m - alias for module
  m: (path) ->
    @file path

  files: (...paths) ->
    self = @
    paths.map (path) ->
      self.file(path)

  fixtures: (...paths) ->
    self = @
    paths.map (path) ->
      self.fixture(path)

  tests: (...paths) ->
    self = @
    paths.map (path) ->
      self.test(path)
