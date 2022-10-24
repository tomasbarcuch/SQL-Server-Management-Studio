/*select * from 
(values 
('0', 'a2'), 
('1', 'b2'), 
('2', 'c2')
) x(col1, col2)*/

Select row.code, s.id, row.statusid, s.name from (select * from status  S
where s.id = 'a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd'
) S 
inner join (select statusid,code from (values 
('a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd','100'), 
('a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd','110'),
('a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd','400')
) x(statusid,code)) row on S.id = row.[statusid]