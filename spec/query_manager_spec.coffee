class User extends clay.Model
    @name = clay.fields.CharField()


describe 'clay.QueryManager', ->
    beforeEach ->
        @manager = new clay.QueryManager(User, new clay.adapters.MySqlAdapter())
    
    describe 'get', ->
        it 'should accept a hash of fields', ->
            result = @manager.get({id: 10})
            expect(result).toBeInstanceOf(clay.Query)
            expect(result.toString()).toEqual('SELECT * FROM `user` WHERE (`id` = ?)')


