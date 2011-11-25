model = require('../model')
fields = require('../../lib/fields')
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
        
        fieldsSql = []
        for fieldName, fieldObj of modelClass.metadata().fields
            fieldsSql.push @fieldToSql(fieldObj)
        
        for index in modelClass.metadata().indexes
            fieldsSql.push @generateSqlForIndex(index)
        
        output = []
        output.push "CREATE TABLE #{@escapeFieldName(modelClass.metadata().tableName)} ("
        
        output.push fieldsSql.join(',\n')
        
        output.push ')'
        
        return output.join('\n')
    
    fieldToSql: (field) ->
        if field instanceof fields.CharField
            return "#{@escapeFieldName(field.name)} varchar(#{field.max_length}) NOT NULL"
        
        if field instanceof fields.IntegerField
            return "#{@escapeFieldName(field.name)} int(11) NOT NULL"

        throw {
            name: 'Error',
            message: "Did not understand field type: #{field.constructor.name}"
        }
    
    generateSqlForIndex: (index) ->
        if index instanceof indexes.Index
            return "KEY `#{index.name}` (#{@escapeFieldName(index.fields)})"
            
        # CONSTRAINT `created_id_refs_id_2b18c3a3` FOREIGN KEY (`created_id`) REFERENCES `repository_auditevent` (`id`),

exports.AdapterInterface = AdapterInterface
