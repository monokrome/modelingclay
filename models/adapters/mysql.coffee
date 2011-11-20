AdapterInterface = require('./interface').AdapterInterface

mysql = require 'mysql'

class MySqlAdapter extends AdapterInterface
    constructor: (mysql_lib = null, args) ->
        if mysql_lib isnt null
            mysql = mysql_lib
        
    connect: (@hostname, @username, password, @database) =>
        @client = mysql.createClient({
                                    host: @hostname,
                                    user: @username,
                                    password: password,
                                })
    
    disconnect: =>
        @client.end()

exports.MySqlAdapter = MySqlAdapter
   