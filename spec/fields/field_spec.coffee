fields = require '../../lib/fields'

describe 'Field', ->
    describe '#setup', ->
        it 'should accept a field name and underscorize it', ->
            f = new fields.Field()
            
            expect(f.name).toBeNull();
            
            f.setup('someName')
            
            expect(f.name).toEqual('some_name')
            