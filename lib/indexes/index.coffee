inflect = require 'inflect'

class Index
    constructor: (@modelClass, @fields) ->
        field_names = @fields.join('_')
        @name = "IDX_#{@modelClass.metadata().tableName}_#{field_names}"


exports.Index = Index