Field = require('./field').Field

class BooleanField extends Field
    constructor: (@defaultValue=false) ->
        super
    
    validate: (value) =>
        if typeof value isnt 'boolean'
            throw @name + ' should be a boolean value.'
        
        return true
    
    

exports.BooleanField = BooleanField
