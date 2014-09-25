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
    return [].concat.apply([], arr);
};

contains = function(arr, item) {
    if (arr.indexOf(item) > -1)
        return true;
    else
        return false;
}

//function isBigEnough(element, index, array) {
//    return (element >= 10);
//}

//var passed = every([12, 5, 8, 130, 44], isBigEnough);

every = function(list, fun /*, thisp */) {
    var len = this.length;
    if (typeof fun != "function")
        throw new TypeError("Must be a function");

    var thisp = arguments[2];
    for (var i = 0; i < len; i++)
    {
        if (i in this &&
            !fun.call(thisp, this[i], i, this))
            return false;
    }
    return true;
};

module.exports = {
  every: every,
  unique: unique,
  contains: contains,
  flatten: flatten,
}

