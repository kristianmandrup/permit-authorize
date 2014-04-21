lo = requires.util 'lodash-lite'

underscore = (str) ->
  str.replace /-/, '_'

file-path = (...paths) ->
  underscore(lo.flatten ['.', paths] .join '/')

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

  access-request: (path) ->
    @lib 'access_request', path

  ability: (path) ->
    @lib 'ability', path

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

