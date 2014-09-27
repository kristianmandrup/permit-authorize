timer = require '../../util' .timer.timer-on

test =
  abra: ->
    console.log 'abra'
  go: 0

  x: ->
    timer-on @, except: 'x' #, ['abra']
    @

class Aba
  (@v) ->

  blip: ->
    console.log 'blip'

  time: ->
    timer-on @, except: 'time'
    @

aba = new Aba
aba.blip!
aba.time!.blip!

test.x!.abra!
