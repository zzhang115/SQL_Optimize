drop database if exists insertDataMillion;
create database insertDataMillion;
use insertDataMillion;

SET max_heap_table_size = 1024*1024*2000;
CREATE TABLE InsertTable (
`id` int(11) NOT NULL auto_increment,
`name` varchar(50) default NULL,
`addr` varchar(50) default NULL,
PRIMARY KEY (`id`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;


delimiter @
create procedure insert_InsertTable(in item integer)
begin
declare counter int;
set counter = item;
while counter >= 1 do
insert into InsertTable values(counter,concat('Record.',counter), '723 25th ave');
set counter = counter - 1;
end while;
end
@

delimiter @
call insert_InsertTable(1000000);
@
