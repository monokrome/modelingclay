model = require('../../lib/model')
fields = require('../../lib/fields')
indexes  = require('../../lib/indexes')
Index = require('../../lib/indexes/index').Index

class TestModel extends model.Model
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
            index.setup(TestModel)
            
            expect(index.name).toEqual('IDX_test_models_thing_thing2')
        
        it 'should should throw an error if a field name does not exist in the model', ->
            class TestModel2 extends model.Model
                @field = new fields.CharField()
                
                @someIndex = new indexes.Index('non_existent_field')
            
            test = ->
                TestModel2.metadata()
            
            expect(test).toThrow('Cannot find field: non_existent_field in model: TestModel2.')