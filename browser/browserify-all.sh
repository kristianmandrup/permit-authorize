browserify ../lib/index.js --s permitAuthorize > dist/permit-authorize.js
browserify ../lib/index.js --s permitAuthorize | uglifyjs -c > dist/permit-authorize.min.js