MySqlAdapter = require('../../../models/adapters/mysql').MySqlAdapter
Query = require('../../../models/adapters/query').Query

mysqlMOCK = {
    createClient: ->
        return {
            end: ->
                return true
            ping: (callback) ->
                callback()
        }
}

describe 'MySqlAdapter', ->
    describe '#connect', ->
        it 'should create a client', ->
            spyOn(mysqlMOCK, 'createClient').andCallThrough()
            
            adapter = new MySqlAdapter(mysqlMOCK)
            adapter.connect('hostname', 'username', 'password', 'database')
            
            expect(mysqlMOCK.createClient).toHaveBeenCalledWith({
                                        host: 'hostname',
                                        user: 'username',
                                        password: 'password',
                                    })
            
            expect(adapter.client).toBeDefined()
        
    describe '#disconnect', ->
        it 'should call through to mysql lib', ->
            adapter = new MySqlAdapter(mysqlMOCK)
            adapter.connect('hostname', 'username', 'password', 'database')
             
            spyOn(adapter.client, 'end')
            
            adapter.disconnect()
            
            expect(adapter.client.end).toHaveBeenCalled()
    
    describe '#query', ->
        it 'should return a new instance of Query', ->
            adapter = new MySqlAdapter()
            
            expect(adapter.query()).toBeInstanceOf(Query)
        