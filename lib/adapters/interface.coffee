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
            fieldsSql.push @fieldToSql(modelClass, fieldObj)
        
        for index in modelClass.metadata().indexes
            fieldsSql.push @generateSqlForIndex(modelClass, index)
        
        output = []
        output.push "CREATE TABLE #{@escapeFieldName(modelClass.metadata().tableName)} ("
        
        output.push fieldsSql.join(',\n')
        
        output.push ')'
        
        return output.join('\n')
    
    fieldToSql: (modelClass, field) ->
        if field instanceof fields.CharField
            return "#{@escapeFieldName(field.name)} varchar(#{field.maxLength}) NOT NULL"
        
        if field instanceof fields.BooleanField
            return "#{@escapeFieldName(field.name)} tinyint(1) NOT NULL"

        if field instanceof fields.IntegerField
            return "#{@escapeFieldName(field.name)} int(11) NOT NULL"

        throw {
            name: 'Error',
            message: "Did not understand field type: #{field.constructor.name}"
        }
    
    generateSqlForIndex: (modelClass, index) ->
        if index instanceof indexes.PrimaryKey
            return "PRIMARY KEY (#{@escapeFieldName(index.fields)})"
            
        if index instanceof indexes.Index
            return "KEY `IDX_#{index.name}` (#{@escapeFieldName(index.fields)})"
        

exports.AdapterInterface = AdapterInterface
