class User extends model.Model
	@username = new model.CharField()
	@password = new model.CharField()
  

model.define(User)

describe 'Model', ->
	describe 'a subclass called User', ->
		it 'should define a metadata object', ->
			meta = User.metadata
			
			expect(meta).toBeDefined()
			expect(meta.name).toEqual('User')
			expect(meta.tableName).toEqual('users')
			
			expect(meta.fields).toBeDefined()
		
		it 'should store fields in metadata', ->
			expect(User.metadata.fields).toBeDefined()
			
			fields = User.metadata.fields
			
			expect(fields.username).toBeDefined()
			expect(fields.username).toBeInstanceOf(model.CharField)
			expect(fields.username.name).toEqual('username')
		
		it 'should define a class member called objects which is a QueryManager', ->
			expect(User.objects).toBeInstanceOf(model.QueryManager)
	

describe 'CharField', ->
	describe 'validate', ->
		make_field = (name = 'test_field') ->
			field = new model.CharField()
			field.name = name
			
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