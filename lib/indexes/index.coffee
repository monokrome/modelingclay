inflect = require 'inflect'

class Index
    constructor: (@fields...) ->
        @name = null
        
    setup: (nameFromModel) ->
        @name = inflect.underscore(nameFromModel)
    
    validate: (modelMetadata) ->
        modelFields = modelMetadata.fieldNames
        
        for fieldName in @fields
            if fieldName not in modelFields
                throw {
                    name: 'Error',
                    message: "Cannot find field: #{fieldName} in model: #{modelMetadata.name}."
                }
    


exports.Index = Index
