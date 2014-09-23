flatten = require './lib/util/array_util' .flatten

underscore = (str) ->
  str.replace /-/, '_'

file-path = (...paths) ->
  flat-path = flatten ['.', paths]
  console.log flat-path
  underscore(flat-path .join '/')

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

  matcher: (path) ->
    @lib 'matcher', "#{path}_matcher"

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

