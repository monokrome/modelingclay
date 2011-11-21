XRegExp = require 'xregexp'

MySqlAdapter = require('./adapters/mysql').MySqlAdapter

makeError = (errorMessage) ->
    return 

class Database
    constructor: (args) ->
    
    connect: (connectionString) ->
        connectionStringRegexp = XRegExp('''(?<engine>\\w+)://(?<username>\\w+)?:?(?<password>\\w+)?@?(?<hostname>\\w+):?(?<port>\\d+)?/(?<database>\\w+)''', 'x')
        
        match = connectionStringRegexp.exec(connectionString)
        
        if not match
            throw {
                name: 'Error',
                message: 'Connection string is invalid: engine, hostname, and database are required parameters.'
            }
        
        if match
            @connectionInfo = {
                engine: match.engine,
                hostname: match.hostname,
                port: match.port,
                username: match.username,
                password: match.password,
                database: match.database,
            }
            
            @adapter = @adapterFactory(match.engine)
            @adapter.connect(@connectionInfo.hostname,
                                @connectionInfo.username,
                                @connectionInfo.password,
                                @connectionInfo.database)
    
    adapterFactory: (engineType) ->
        switch engineType
            when "mysql"
                return new MySqlAdapter()
            else
                throw {
                    name: 'Error',
                    message: "Unknown engine type: #{engineType}"
                }
    query: ->
        if not @adapter
            throw {
                name: 'Error',
                message: "An active connection is required for query()."
            }
        
        return @adapter.query()

exports.Database = Database
     