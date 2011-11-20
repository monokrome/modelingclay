_s = require('underscore.string');

class Join
    constructor: (@primary_table, @primary_field, @secondary_table, @secondary_field, @type='', @comparator='=') ->
    
    toString: ->
        return "#{@type.toUpperCase()} JOIN `#{@secondary_table}` ON (`#{@primary_table}`.`#{@primary_field}` #{@comparator} `#{@secondary_table}`.`#{@secondary_field}`)".trim()


exports.Join = Join