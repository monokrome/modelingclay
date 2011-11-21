Field = require('./field').Field

class CharField extends Field
    constructor: (@max_length = 100, opts...) ->
        super opts
        
    validate: (value) =>
        if typeof value isnt 'string'
            throw @name + ' should be a string.'
        
        return true

exports.CharField = CharField