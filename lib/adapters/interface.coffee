model = require('../model')
indexes = require '../indexes'

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
    
    escapeFieldName: (fields...) ->
        escape = (str) ->
            if str.indexOf('.') == -1
                return "`#{str}`"
            else
                parts = str.split('.')
                return "`#{parts.join('`.`')}`"
        
        return escape(field) for field in fields
    
    createTable: (modelClass) ->
        if not modelClass instanceof model.Model
            throw {
                name: 'Error',
                message: 'Must be a subclass of Model!'
            }
        
        if not modelClass.metadata().fields
            throw {
                name: 'Error',
                message: 'Models should contain fields.'
            }
        
        output = ["CREATE TABLE #{@escapeFieldName(modelClass.metadata().tableName)} ("]
        # log modelClass.metadata.fields
        for fieldName, fieldObj of modelClass.metadata().fields
            output.push @fieldToSql(fieldObj)
        
        output.push ')'
        
        return output.join('\n')
    
    fieldToSql: (field) ->
        if field instanceof model.CharField
            return "#{@escapeFieldName(field.name)} varchar(#{field.max_length}) NOT NULL"
        
        throw {
            name: 'Error',
            message: "Did not understand field type: #{fieldType}"
        }
    
    generateSqlForIndex: (index) ->
        if index instanceof indexes.Index
            return "KEY `#{index.name}` (#{@escapeFieldName(index.fields)})"

exports.AdapterInterface = AdapterInterface
