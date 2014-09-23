if (!Object.prototype.values) {
  Object.prototype.values = function() {
    if (this == null) {
      throw new TypeError('Array.prototype.values called on null or undefined');
    }
    var self = this;
    return Object.keys(this).map(function (key) {
      if (self.hasOwnProperty(key))
        return self[key];
      else
        return null;
    }).filter(function (value) {
      return value !== null;
    })
  };
}

console.log({a: 1, b: 2}.values());