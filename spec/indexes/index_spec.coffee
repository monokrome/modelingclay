model = require('../../lib/model')
Index = require('../../lib/indexes/index').Index

describe 'Index', ->
    describe '#constructor', ->
        it 'should accept a modelClass and list of field names, then generate an index name', ->
            class TestModel extends model.Model
                @thing = new model.CharField()
            
            index = new Index(TestModel, ['thing'])
            
            expect(index.name).toEqual('IDX_test_models_thing')
            
        