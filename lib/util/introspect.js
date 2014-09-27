function methodsOf(foo) {
    var methods = [];
    for (var key in foo.prototype) {
        if (typeof foo.prototype[key] === "function") {
            methods.push(key);
        }
    }
    for (var key in foo) {
        if (typeof foo[key] === "function") {
            methods.push(key);
        }
    }
    return methods;
}

module.exports = methodsOf

