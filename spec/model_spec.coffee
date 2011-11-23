fields = require('../lib/fields')


class User extends model.Model
    @username = new fields.CharField()
    @password = new fields.CharField()


describe 'Model', ->
    describe 'a subclass called User', ->
        it '#metadata should setup the model data', ->
            delete User.__metadata
            
            expect(User.__metadata).not.toBeDefined()
            User.metadata()
            
            expect(User.__metadata).toBeDefined()
        
        it '#constructor should call metadata()', ->
            delete User.__metadata
            
            expect(User.__metadata).not.toBeDefined()
            new User()
            
            expect(User.__metadata).toBeDefined()
            
        
        it 'should define a metadata object', ->
            meta = User.metadata()
            
            expect(meta).toBeDefined()
            expect(meta.name).toEqual('User')
            expect(meta.tableName).toEqual('users')
            
            expect(meta.fields).toBeDefined()
        
        it 'should store fields in metadata', ->
            expect(User.metadata().fields).toBeDefined()
            
            modelFields = User.metadata().fields
            
            expect(modelFields.username).toBeDefined()
            expect(modelFields.username).toBeInstanceOf(fields.CharField)
            expect(modelFields.username.name).toEqual('username')
            
            expect(User.metadata().fieldNames).toContain('username', 'password')
        
        it 'should define a class member called objects which is a QueryManager', ->
            expect(User.objects).toBeInstanceOf(model.QueryManager)
    

