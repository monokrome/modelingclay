Join = require('../lib/join').Join

describe 'Join', ->
    describe '#toString', ->
        it 'should work with a basic join', ->
            j = new Join('table_a', 'field_a', 'table_b', 'field_b')
            
            expect(j.toString()).toEqual('JOIN `table_b` ON (`table_a`.`field_a` = `table_b`.`field_b`)')
        
        it 'should work with a left join', ->
            j = new Join('table_a', 'field_a', 'table_b', 'field_b', type='left')
            
            expect(j.toString()).toEqual('LEFT JOIN `table_b` ON (`table_a`.`field_a` = `table_b`.`field_b`)')
        
        it 'should work with a custom comparator', ->
            j = new Join('table_a', 'field_a', 'table_b', 'field_b', type='left', comparator='<>')
            
            expect(j.toString()).toEqual('LEFT JOIN `table_b` ON (`table_a`.`field_a` <> `table_b`.`field_b`)')
