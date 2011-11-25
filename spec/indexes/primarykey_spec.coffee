indexes  = require('../../lib/indexes')

describe 'PrimaryKey', ->
    it 'should extend Index', ->
        pk = new indexes.PrimaryKey()

        expect(pk).toBeInstanceOf(indexes.Index)
        
