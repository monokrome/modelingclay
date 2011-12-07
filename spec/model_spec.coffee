fields = require('../lib/fields')
indexes = require('../lib/indexes')
relations = require('../lib/relations')
QueryManager = require('../lib/query_manager').QueryManager


class User extends clay.Model
    @username = new fields.CharField()
    @password = new fields.CharField()
    
    @someIndex = new indexes.Index('username')


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
            expect(meta.tableName).toEqual('user')
            
            expect(meta.fields).toBeDefined()
            expect(meta.indexes).toBeDefined()
            expect(meta.primaryKey).toBeDefined()
        
        it 'should store fields in metadata', ->
            expect(User.metadata().fields).toBeDefined()
            
            modelFields = User.metadata().fields
            
            expect(modelFields).toHaveKey('username')
            expect(modelFields.username).toBeInstanceOf(fields.CharField)
            expect(modelFields.username.name).toEqual('username')
            
            expect(User.metadata().fieldNames).toContain('username', 'password')
        
        it 'should store indexes in the metadata', ->
            expect(User.metadata().fields).toBeDefined()
            
            modelIndexes = User.metadata().indexes
            
            expect(modelIndexes.length).toEqual(1)
            
            for index in modelIndexes
                expect(index.fields).toContain('username')
        
        it 'should automatically add an integer based primary key when one does not exist', ->
            expect(User.metadata()).toHaveKey('fields')
            expect(User.metadata()).toHaveKey('indexes')

            modelFields = User.metadata().fields
            modelIndexes = User.metadata().indexes

            expect(modelFields).toHaveKey('id')
            expect(modelFields.id).toBeInstanceOf(fields.AutoIntegerField)

            expect(User.metadata().indexNames).toContain('someIndex')
    
    describe '#installRelation', ->
        it 'should add fields to the model for storing relational data', ->
            class Message extends clay.Model
                @body = new fields.CharField()
            
            rel = new relations.HasMany(Message)

            User.metadata().installRelation(rel)

            modelRelations = User.metadata().relations
            expect(modelRelations.length).toEqual(1)
            expect(modelRelations).toContain(rel)

            expect(Message.metadata().fieldNames).toContain('user_id')
            expect(Message.metadata().fields).toHaveKey('user_id')
            expect(Message.metadata().fields.user_id).toBeInstanceOf(fields.ForeignKeyField)
    
    describe 'objects', ->
        it 'should be of instance QueryManager', ->
            class Message extends clay.Model
                @body = new fields.CharField()
            

            expect(Message).toHaveKey('objects')
            expect(Message.objects).toBeInstanceOf(QueryManager)

            

