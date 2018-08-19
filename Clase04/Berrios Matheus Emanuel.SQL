CREATE OR REPLACE TRIGGER scott.tr_test_emp 
AFTER INSERT OR DELETE OR UPDATE ON scott.emp
for each row
when (new.sal > 6000)
BEGIN

  IF inserting THEN
    dbms_output.PUT_LINE('nuevo empleado se ha insertado');
  ELSIF updating THEN
    dbms_output.put_line('un empleado se ha modificado');
  ELSIF deleting then 
    dbms_output.put_line('un empleado se ha eliminado');
  end if;
  
END tr_test_emp;

insert into scott.emp( empno, ename ) 
values( 7777, 'Yo 7777' );

select * from scott.emp;

update scott.emp 
set sal = 7777
where empno = 7777;

delete from scott.emp where empno = 7777;

commit;

update scott.emp set sal = 1.2 * sal;





