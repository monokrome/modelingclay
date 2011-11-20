MySqlAdapter = require('../../../models/adapters/mysql').MySqlAdapter

mysqlMOCK = {
    createClient: ->
        return {
            end: ->
                return true
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

