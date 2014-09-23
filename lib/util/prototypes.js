if (!Array.prototype.unique) {
    Array.prototype.unique = function() {
        if (this == null) {
            throw new TypeError('Array.prototype.unique called on null or undefined');
        }
        this.filter(function (value, index, self) {
            return self.indexOf(value) === index;
        });
    }
}

if (!Array.prototype.find) {
    Array.prototype.find = function(predicate) {
        if (this == null) {
            throw new TypeError('Array.prototype.find called on null or undefined');
        }
        if (typeof predicate !== 'function') {
            throw new TypeError('predicate must be a function');
        }
        var list = Object(this);
        var length = list.length >>> 0;
        var thisArg = arguments[1];
        var value;

        for (var i = 0; i < length; i++) {
            value = list[i];
            if (predicate.call(thisArg, value, i, list)) {
                return value;
            }
        }
        return undefined;
    };
}

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