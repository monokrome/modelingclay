Field = require('./field').Field

class CharField extends Field
    constructor: (@maxLength = 100) ->
        super
    
    validate: (value) =>
        if typeof value isnt 'string'
            throw @name + ' should be a string.'
        
        return true
    
    

exports.CharField = CharField
