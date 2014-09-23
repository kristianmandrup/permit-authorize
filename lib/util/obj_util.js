var extend = function (source, other) {
    Object.keys(other).forEach(function (key) {
        source[key] = other[key];
    });
    return source;
}

var values = function(obj) {
    if (obj == null) {
      throw new TypeError('values called with null or undefined');
    }
    return Object.keys(obj).map(function (key) {
      if (obj.hasOwnProperty(key))
        return obj[key];
      else
        return null;
    }).filter(function (value) {
      return value !== null;
    })
}

module.exports = {
    extend: extend,
    values: values
}
