AdapterInterface = require('../../lib/adapters/interface').AdapterInterface
model = require('../../lib/model')

describe 'AdapterInterface', ->
    describe '#connect', ->
        it 'should throw an error', ->
            adapter = new AdapterInterface()
            
            connectThrowsError = ->
                adapter.connect()
            
            expect(connectThrowsError).toThrow('Not Implemented.')
        
    describe '#disconnect', ->
        it 'should throw an error', ->
            adapter = new AdapterInterface()
            
            disconnectThrowsError = ->
                adapter.disconnect()
            
            expect(disconnectThrowsError).toThrow('Not Implemented.')
    
    describe '#query', ->
        it 'should throw an error', ->
            adapter = new AdapterInterface()
            
            queryThrowsError = ->
                adapter.query()
            
            expect(queryThrowsError).toThrow('Not Implemented.')
    
    describe '#execute', ->
        it 'should throw an error', ->
            adapter = new AdapterInterface()
            
            executeThrowsError = ->
                adapter.execute()
            
            expect(executeThrowsError).toThrow('Not Implemented.')
    
    describe '#createTable', ->
        it 'should accept a model and return a sql string', ->
            class TestModel extends model.Model
                @some_string = new model.CharField()
            
            adapter = new AdapterInterface()
            
            sql = adapter.createTable(TestModel)
            
            expect(sql).toEqual("CREATE TABLE `test_models` (\n`some_string` varchar(100) NOT NULL\n)")
        
    describe '#fieldToSql', ->
        it 'should work with basic field types', ->
            adapter = new AdapterInterface()
            
            charField = new model.CharField(@max_length = 10)
            charField.setup('char_field')
            
            expect(adapter.fieldToSql(charField)).toEqual('`char_field` varchar(10) NOT NULL')