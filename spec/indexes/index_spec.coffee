model = require('../../lib/model')
fields = require('../../lib/fields')
indexes  = require('../../lib/indexes')
Index = require('../../lib/indexes/index').Index

class TestModel extends clay.Model
    @thing = new fields.CharField()
    @thing2 = new fields.CharField()

describe 'Index', ->
    describe '#constructor', ->
        it 'should accept a list of field names', ->
            index = new Index('thing', 'thing2')
            
            expect(index.name).toBeNull()
            expect(index.fields).toEqual(['thing', 'thing2'])
            
    
    describe '#setup', ->
        it 'should generate the index name', ->
            index = new Index('thing', 'thing2')
            index.setup('index_name')
            
            expect(index.name).toEqual('index_name')
    
    describe '#validate', ->
        it 'should should throw an error if a field name does not exist in the model', ->
            class TestModel2 extends clay.Model
                @field = new fields.CharField()
                
                @someIndex = new indexes.Index('non_existent_field')
            
            test = ->
                TestModel2.metadata()
            
            expect(test).toThrow('Cannot find field: non_existent_field in model: TestModel2.')
