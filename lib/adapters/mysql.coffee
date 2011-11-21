AdapterInterface = require('./interface').AdapterInterface
Query = require('../query').Query

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

exports.MySqlAdapter = MySqlAdapter
   