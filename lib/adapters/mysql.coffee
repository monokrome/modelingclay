AdapterInterface = require('./interface').AdapterInterface
Query = require('../query').Query
fields = require('../../lib/fields')

mysql = require 'mysql'

class MySqlAdapter extends AdapterInterface
    constructor: (mysql_lib = null, args) ->
        if mysql_lib isnt null
            mysql = mysql_lib
        
    connect: (@hostname, @username, password, @database) ->
        @client = mysql.createClient({
                                    host: @hostname,
                                    user: @username,
                                    password: password,
                                })
    
    disconnect: ->
        @client.end()
    
    query: ->
        return new Query(this)
    
    execute: (sql_statement, sql_params, callback) ->
        @client.query(sql_statement, sql_params, callback)
    
    fieldToSql: (field) ->
        if field instanceof fields.AutoIntegerField
            return "#{@escapeFieldName(field.name)} int(11) NOT NULL AUTO_INCREMENT"
        
        return super.fieldToSql(field)


exports.MySqlAdapter = MySqlAdapter
   
