function unique(a,b,c){//array,placeholder,placeholder
    b= a.length;
    while(c=--b)while(c--)a[b]!==a[c]||a.splice(c,1);
    return a // not needed ;)
}

//If we have nested arrays of depth = 1:
// var arr = [[1,2,3],[4,5],6];
//we can flatten it by using concat and apply
// var flat_arr = [].concat.apply([],arr);
var flatten = function(arr) {
    return [].concat.apply([],arr);
};

var flatReduce = function(arr) {
    return arr.reduce(function(a, b) {
        return a.concat(b);
    });
};


var find = function(arr, predicate) {
    if (arr == null) {
        throw new TypeError('find called with null or undefined');
    }
    if (typeof predicate !== 'function') {
        throw new TypeError('predicate must be a function');
    }
    var list = Object(arr);
    var length = list.length >>> 0;
    var thisArg = arguments[2];
    var value;

    for (var i = 0; i < length; i++) {
        value = list[i];
        if (predicate.call(thisArg, value, i, list)) {
            return value;
        }
    }
    return undefined;
};

module.exports = {
  unique: unique,
  find: find,
  flatten: flatten,
  flatReduce: flatReduce
}

