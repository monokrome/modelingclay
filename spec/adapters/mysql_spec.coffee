MySqlAdapter = require('../../../models/adapters/mysql').MySqlAdapter
Query = require('../../../models/query').Query

mysql = require 'mysql'

mysqlMOCK = {
    createClient: ->
        return {
            end: ->
                return true
            execute: (sql, params, callback) ->
                # lol do nothing.
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
    
    describe '#execute', ->
        it 'should exec the query', ->
            spyOn(mysql.Client.prototype, '_connect');
            spyOn(mysql.Client.prototype, 'query').andCallThrough()
            
            adapter = new MySqlAdapter(mysql)
            adapter.connect('hostname', 'username', 'password', 'database')
            
            testCallback = ->
            
            adapter.execute('SELECT * FROM foo WHERE(x = ?)', [1], testCallback)
            
            expect(mysql.Client.prototype.query).toHaveBeenCalledWith('SELECT * FROM foo WHERE(x = ?)', [1], testCallback)
            