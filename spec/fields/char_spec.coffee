fields = require('../../lib/fields')


describe 'CharField', ->
    describe '#validate', ->
        make_field = (name = 'test_field') ->
            field = new fields.CharField()
            field.setup(name)
            
            return field
        
        it 'should have sane defaults', ->
            field = make_field()
            
            expect(field.name).toEqual('test_field')
            expect(field.max_length).toEqual(100)
        
        it 'should raise error when value is not a string', ->
            field = make_field()
            test = -> throw field.validate(10)
            
            expect(test).toThrow('test_field should be a string.')
        
        it 'should return true when the value is a string', ->
            field = make_field()
            
            expect(field.validate('some string')).toBeTruthy()