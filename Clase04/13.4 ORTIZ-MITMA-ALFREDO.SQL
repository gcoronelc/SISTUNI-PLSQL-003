create or replace view SCOTT.v_empleados as
select e.empno, e.ename, d.deptno, d.dname
from SCOTT.emp e 
inner join dept d
on e.deptno = d.deptno;

SELECT * FROM SCOTT.v_empleados;

INSERT INTO SCOTT.v_empleados(EMPNO, ENAME) VALUES(6666,'6666');

SELECT * FROM SCOTT.EMP;

INSERT INTO SCOTT.v_empleados(DEPTNO, DNAME) VALUES(66,'AREA 66');

INSERT INTO SCOTT.v_empleados(EMPNO, ENAME, DEPTNO, DNAME) 
VALUES(8888,'8888',88,'AREA 88');


create or replace trigger SCOTT.tr_vista
  instead of insert or delete on SCOTT.v_empleados
  for each row
declare
  cuenta number;
begin
  if inserting then
    select count(*) into cuenta from SCOTT.dept where deptno= :new.deptno;
    if cuenta =0 then
      insert into SCOTT.dept(deptno,dname)
      values(:new.deptno, :new.dname);
    end if;
	
    select count(*) into cuenta from SCOTT.emp where empno= :new.empno;
    if cuenta =0 then
      insert into SCOTT.emp(empno, ename, deptno)
      values(:new.empno, :new.ename, :new.deptno);
    end if;
  elsif deleting then
    delete from SCOTT.emp where empno = :old.empno;
  end if;
end tr_vista;

select * from SCOTT.v_empleados;

INSERT INTO SCOTT.v_empleados(EMPNO, ENAME, DEPTNO, DNAME) 
VALUES(8888,'8888',88,'AREA 88');



