inflect = require 'inflect'

utils = require '../utils'

class Field
    constructor: (args) ->
        @name = null
    
    setup: (name) ->
        @name = inflect.underscore(name)
    
    validate: (value) ->
        return true

exports.Field = Field