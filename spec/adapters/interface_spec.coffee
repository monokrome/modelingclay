AdapterInterface = require('../../lib/adapters/interface').AdapterInterface
model = require('../../lib/model')
fields = require('../../lib/fields')
indexes = require '../../lib/indexes'

class TestModel extends model.Model
    @thing = new fields.CharField()
    @thing2 = new fields.CharField()

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
    
    describe '#escapeFieldNames', ->
        it 'should work with a string', ->
            adapter = new AdapterInterface()
            
            expect(adapter.escapeFieldName('some_field')).toEqual('`some_field`')
            expect(adapter.escapeFieldName('some_table.some_field')).toEqual('`some_table`.`some_field`')
    
    describe '#createTable', ->
        it 'should accept a model and return a sql string', ->
            class TestModel extends model.Model
                @some_string = new fields.CharField()
                
                @testIndex = new indexes.Index('some_string')
            
            adapter = new AdapterInterface()
            
            sql = adapter.createTable(TestModel)
            
            expect(sql).toEqual("CREATE TABLE `test_models` (\n`some_string` varchar(100) NOT NULL,\n`id` int(11) NOT NULL,\nKEY `IDX_test_index` (`some_string`)\n)")
        
    describe '#fieldToSql', ->
        it 'should work with basic field types', ->
            adapter = new AdapterInterface()
            
            charField = new fields.CharField(@max_length = 10)
            charField.setup('char_field')
            
            expect(adapter.fieldToSql(charField)).toEqual('`char_field` varchar(10) NOT NULL')
    
    describe '#indexToSql', ->
        it 'should work with basic indexes', ->
            adapter = new AdapterInterface()
            
            idx = new indexes.Index('some_string')
            idx.setup('the_index_name')
            
            sql = adapter.generateSqlForIndex(idx)
            
            expect(sql).toEqual('KEY `IDX_the_index_name` (`some_string`)')
        
        it 'should work with primary keys', ->
            adapter = new AdapterInterface()
            
            idx = new indexes.PrimaryKey('some_string')
            idx.setup('the_index_name')
            
            sql = adapter.generateSqlForIndex(idx)
            
            expect(sql).toEqual('PRIMARY KEY (`some_string`)')



