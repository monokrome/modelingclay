exports.extend = (object, extensions...) ->
    return {} if not object?
    
    for extension in extensions
        for own key, val of extension
            if not object[key]? or typeof val isnt 'object'
                object[key] = val
            else
                object[key] = extend(object[key], val)
    
    return object

