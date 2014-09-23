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


module.exports = {
  unique: unique,
  contains: contains,
  flatten: flatten,
}

