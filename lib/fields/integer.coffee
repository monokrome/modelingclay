utils = require '../utils'
Field = require('./field').Field

class IntegerField extends Field
    constructor: (options) ->
        super
        
        defaultOptions = 
            default: 0
            min: false
            max: false
        
        @options = utils.extend defaultOptions, options
    
    validate: (value) =>
        if typeof value isnt 'number'
            throw @name + ' should be a number.'
        
        if @options.min != false and @options.min > value
            throw "#{@name} should be greater than #{@options.min}."
        
        if @options.max != false and @options.max < value
            throw "#{@name} should be less than #{@options.max}."
        
        return true
    
    

exports.IntegerField = IntegerField