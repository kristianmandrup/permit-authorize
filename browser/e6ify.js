'use strict';

var path       = require('path')
  , fs         = require('fs')
  , browserify = require('browserify')
  , es6ify     = require('es6ify')
  , jsRoot     = path.join(__dirname, 'dist', 'es6')
  , bundlePath = path.join(jsRoot, 'permit-authorize-es6.js')
  ;

es6ify.traceurOverrides = { blockBinding: true };

browserify()
  .add(es6ify.runtime)
  .transform(es6ify)
  .require(require.resolve('../lib/index.js'), { entry: true })
  .bundle()
  .on('error', function (err) { console.error(err); })
  .pipe(fs.createWriteStream(bundlePath));