create or replace procedure prc_ejercicio1
is
  cursor c_data is 
  select deptno, ename, sal from emp 
  order by deptno, sal desc;
  v_dep number;
begin
  v_dep := 0;
  for r in c_data loop   
    if(v_dep <> r.deptno) then
      v_dep := r.deptno;
      dbms_output.put_line(r.deptno ||' - '|| r.ename ||' - '|| r.sal);
    end if;
  end loop;
end;

call prc_ejercicio1();


