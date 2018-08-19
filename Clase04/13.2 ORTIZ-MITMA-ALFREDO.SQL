create table scott.Sal_History(
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
  insert into scott.sal_history
  (EMPNO,SALOLD,SALNEW,STARTDATE,SETUSER)
  values(:new.empno, :old.sal, :new.sal , sysdate, USER);
end tr_updateEmpSal;

update scott.emp set sal=1200 where empno=7369;

update scott.emp set sal=5000 where empno in (7788,7902);

select * from scott.Sal_History;


update scott.emp set ename='PRUEBA' where empno=7369;


