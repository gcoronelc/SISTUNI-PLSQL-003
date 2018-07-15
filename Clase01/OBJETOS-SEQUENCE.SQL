
create sequence sq_test;

create table demo( 
  id number (5),
  dato varchar2(50)
);

insert into demo
values( sq_test.nextval, 'francia' );

select * from demo;





