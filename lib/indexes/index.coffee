inflect = require 'inflect'

class Index
    constructor: (@fields...) ->
        @name = null
        
    setup: (@modelClass) ->
        modelFields = @modelClass.metadata().fieldNames
        
        for fieldName in @fields
            if fieldName not in modelFields
                throw {
                    name: 'Error',
                    message: "Cannot find field: #{fieldName} in model: #{@modelClass.metadata().name}."
                }
        
        field_names = @fields.join('_')
        @name = "IDX_#{@modelClass.metadata().tableName}_#{field_names}"
    


exports.Index = Index