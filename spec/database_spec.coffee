Database = require('../../models/database').Database
MySqlAdapter = require('../../models/adapters/mysql').MySqlAdapter
Query = require('../../models/query').Query


describe 'Database', ->
    describe '#connect', ->
        it 'should accept a connection string and parse it correctly', ->
            db = new Database()
            db.connect('mysql://foo:bar@localhost:3306/test')
            
            expect(db.connectionInfo).toBeDefined()
            
            connInfo = db.connectionInfo
            
            expect(connInfo.engine).toEqual('mysql')
            expect(connInfo.username).toEqual('foo')
            expect(connInfo.password).toEqual('bar')
            expect(connInfo.hostname).toEqual('localhost')
            expect(connInfo.port).toEqual('3306')
            expect(connInfo.database).toEqual('test')
        
        it 'should accept a partial connection string and parse it correctly', ->
            db = new Database()
            db.connect('mysql://@localhost/test')

            expect(db.connectionInfo).toBeDefined()

            connInfo = db.connectionInfo

            expect(connInfo.engine).toEqual('mysql')
            expect(connInfo.username).toEqual(undefined)
            expect(connInfo.password).toEqual(undefined)
            expect(connInfo.hostname).toEqual('localhost')
            expect(connInfo.port).toEqual(undefined)
            expect(connInfo.database).toEqual('test')
        
        it 'should require at minimum the engine, hostname, and database', ->
            db = new Database()
            
            withoutDatabase = ->
                db.connect('mysql://@localhost')
                
            withoutHostname = ->
                db.connect('mysql://')
            
            withoutEngine = ->
                db.connect('@localhost/database')
            
            expect(withoutDatabase).toThrow('Connection string is invalid: engine, hostname, and database are required parameters.')
            expect(withoutHostname).toThrow('Connection string is invalid: engine, hostname, and database are required parameters.')
            expect(withoutEngine).toThrow('Connection string is invalid: engine, hostname, and database are required parameters.')
            
        
        it 'should choose the appropriate engine', ->
            spyOn(MySqlAdapter.prototype, 'connect')
            
            db = new Database()
            db.connect('mysql://@localhost/test')
            
            expect(db.adapter).toBeDefined()
            expect(db.adapter).toBeInstanceOf(MySqlAdapter)
            
            expect(MySqlAdapter.prototype.connect).toHaveBeenCalledWith('localhost', undefined, undefined, 'test')
            
        
    describe '#adapterFactory', ->
        it 'should return MySqlAdapter instance when "mysql" is passed', ->
            db = new Database()
            
            expect(db.adapterFactory("mysql")).toBeInstanceOf(MySqlAdapter)
        
        it 'should raise an error when the type is not understood', ->
            db = new Database()
            
            testUnknownEngineType = ->
                db.adapterFactory("unknown")
            
            expect(testUnknownEngineType).toThrow('Unknown engine type: unknown')
    
    describe '#query', ->
        it 'should return a new instance of Query', ->
            db = new Database()
            db.connect('mysql://localhost/test')
            
            expect(db.query()).toBeInstanceOf(Query)
            
        
        it 'should raise an error when not connected', ->
            db = new Database()
            
            testQueryRaisesError = ->
                db.query()
            
            expect(testQueryRaisesError).toThrow('An active connection is required for query().')
            