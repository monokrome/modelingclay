Query = require('./query').Query

class QueryManager
    constructor: (@modelClass, @adapter) ->
    
    get: (opts) ->
        q = @adapter.query().select().from(@modelClass.metadata().tableName)

        for key, value of opts
            q.where(key, value)
        
        return q


exports.QueryManager = QueryManager
