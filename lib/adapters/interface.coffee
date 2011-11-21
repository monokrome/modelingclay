model = require('../model')

class AdapterInterface
    constructor: (args) ->
        
    connect: (@host, @username, @password, @database) ->
        throw {
            name: 'Error',
            message: 'Not Implemented.'
        }
    
    disconnect: ->
        throw {
            name: 'Error',
            message: 'Not Implemented.'
        }
    
    query: () ->
        throw {
            name: 'Error',
            message: 'Not Implemented.'
        }
    
    execute: (query_string, params, callback) ->
        throw {
            name: 'Error',
            message: 'Not Implemented.'
        }
    
    createTable: (modelClass) ->
        if not modelClass instanceof model.Model
            throw {
                name: 'Error',
                message: 'Must be a subclass of Model!'
            }
        
        if not modelClass.metadata?
            throw {
                name: 'Error',
                message: 'You need to call define() for this Model first.'
            }
        
        if not modelClass.metadata.fields
            throw {
                name: 'Error',
                message: 'Models should contain fields.'
            }
        
        output = ["CREATE TABLE `#{modelClass.metadata.tableName}` ("]
        # log modelClass.metadata.fields
        for fieldName, fieldObj of modelClass.metadata.fields
            output.push @fieldToSql(fieldObj)
        
        output.push ')'
        
        return output.join('\n')
    
    fieldToSql: (field) ->
        if field instanceof model.CharField
            return "`#{field.name}` varchar(#{field.max_length}) NOT NULL"
        
        throw {
            name: 'Error',
            message: "Did not understand field type: #{fieldType}"
        }

exports.AdapterInterface = AdapterInterface
