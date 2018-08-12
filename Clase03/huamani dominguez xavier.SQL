create table planillames(
  anio number(4),
  mes number(2),
  deptno number(2),
  emps number(2) not null,
  planilla number(10,2) not null,
  constraint pk_planillames 
    primary key (anio, mes, deptno)
)

create or replace procedure pr116 
(p_anio number, p_mes number)
is
  cursor c_dept is select deptno from dept;
  v_deptno dept.DEPTNO%Type;
  cont number;
  v_emps number;
  v_planilla number;
begin
  select count(*) into cont
  from planillames
  where anio = p_anio and mes = p_mes;
  if(cont > 0)then
    dbms_output.put_line('Ya esta procesado');
    return;
  end if;
  open c_dept;
  fetch c_dept into v_deptno;
  while c_dept%found loop
    select count(*), sum(sal) into v_emps, v_planilla
    from emp
    where deptno = v_deptno;
    insert into planillames
    values(p_anio, p_mes, v_deptno, v_emps, nvl(v_planilla,0));
    fetch c_dept into v_deptno;
  end loop;
  close c_dept;
  commit;
  dbms_output.put_line('Proceso Ok');
end;

CALL pr116(2018,2);

SELECT * FROM planillames;



