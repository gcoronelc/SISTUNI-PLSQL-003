create table Sal_History(
  EmpNo number(4) not null,
  SalOld number(7,2) null,
  SalNew number(7,2) null,
  StartDate  date not null,
  SetUser varchar2(30) not null
);
 
create or replace trigger scott.tr_updateEmpSal
after insert or update on scott.emp
for each row
begin
  if(:old.sal<>:new.sal)then
    insert into scott.sal_history(EMPNO,SALOLD,SALNEW,STARTDATE,SETUSER)
    values(:new.empno, :old.sal, :new.sal , sysdate, USER);
  end if;
end tr_updateEmpSal;

update emp set sal=1900 where empno=7369;
update emp set sal=5000 where empno in (7788,7902);

select * from Sal_History;

update SCOTT.emp set ename='BIEN' where empno=7369;

select * from SCOTT.Sal_History;

INSERT INTO SCOTT.EMP(EMPNO, ENAME) VALUES(778,'PEDRO');

INSERT INTO SCOTT.EMP(EMPNO, ENAME, SAL) VALUES(779,'PEDRO', 5678.0);

update SCOTT.emp set sal=NULL where empno=7369;






