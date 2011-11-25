utils = require '../utils'
IntegerField = require('./integer').IntegerField

class AutoIntegerField extends IntegerField
    constructor: (options) ->
        super

        @name = 'id'
    

exports.AutoIntegerField = AutoIntegerField
