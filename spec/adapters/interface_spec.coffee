AdapterInterface = require('../../lib/adapters/interface').AdapterInterface
model = require('../../lib/model')
fields = require('../../lib/fields')
indexes = require '../../lib/indexes'

class TestModel extends clay.Model
    @thing = new fields.CharField()
    @thing2 = new fields.CharField()


adapter = new AdapterInterface()

describe 'AdapterInterface', ->
    describe '#connect', ->
        it 'should throw an error', ->
            connectThrowsError = ->
                adapter.connect()
            
            expect(connectThrowsError).toThrow('Not Implemented.')
        
    describe '#disconnect', ->
        it 'should throw an error', ->
            disconnectThrowsError = ->
                adapter.disconnect()
            
            expect(disconnectThrowsError).toThrow('Not Implemented.')
    
    describe '#query', ->
        it 'should throw an error', ->
            queryThrowsError = ->
                adapter.query()
            
            expect(queryThrowsError).toThrow('Not Implemented.')
    
    describe '#execute', ->
        it 'should throw an error', ->
            executeThrowsError = ->
                adapter.execute()
            
            expect(executeThrowsError).toThrow('Not Implemented.')
    
    describe '#escapeFieldNames', ->
        it 'should work with a string', ->
            expect(adapter.escapeFieldName('some_field')).toEqual('`some_field`')
            expect(adapter.escapeFieldName('some_table.some_field')).toEqual('`some_table`.`some_field`')
    
    describe '#createTable', ->
        it 'should accept a model and return a sql string', ->
            class TestModel extends clay.Model
                @some_string = new fields.CharField()
                
                @testIndex = new indexes.Index('some_string')
            
            expect(adapter.createTable(TestModel)).toEqual("CREATE TABLE `test_model` (\n`some_string` varchar(100) NOT NULL,\n`id` int(11) NOT NULL,\nKEY `IDX_test_index` (`some_string`)\n)")
        
    describe '#fieldToSql', ->
        it 'should work with char field types', ->
            charField = new fields.CharField(@maxLength = 10)
            charField.setup('char_field')
            
            expect(adapter.fieldToSql(null, charField)).toEqual('`char_field` varchar(10) NOT NULL')
    
    describe '#indexToSql', ->
        it 'should work with basic indexes', ->
            idx = new indexes.Index('some_string')
            idx.setup('the_index_name')
            
            expect(adapter.generateSqlForIndex(null, idx)).toEqual('KEY `IDX_the_index_name` (`some_string`)')
        
        it 'should work with primary keys', ->
            idx = new indexes.PrimaryKey('some_string')
            idx.setup('the_index_name')
            
            expect(adapter.generateSqlForIndex(null, idx)).toEqual('PRIMARY KEY (`some_string`)')
