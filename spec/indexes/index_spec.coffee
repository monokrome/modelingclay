model = require('../../lib/model')
fields = require('../../lib/fields')
Index = require('../../lib/indexes/index').Index

class TestModel extends model.Model
    @thing = new fields.CharField()
    @thing2 = new fields.CharField()

describe 'Index', ->
    describe '#constructor', ->
        it 'should accept a modelClass and list of field names, then generate an index name', ->
            index = new Index(TestModel, 'thing', 'thing2')
            
            expect(index.name).toEqual('IDX_test_models_thing_thing2')
            
        it 'should should throw an error if a field name does not exist in the model', ->
            test = ->
                index = new Index(TestModel, 'non_existent_field')
            
            expect(test).toThrow('Cannot find field: non_existent_field in model: TestModel.')
            
            
        