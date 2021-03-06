create or replace package util is

  type gencur is ref cursor;

  function f_emp_x_dep( v_deptno number ) return gencur;

end util;

create or replace package body util as

  function f_emp_x_dep( v_deptno number ) return gencur
  is
    v_returncursor gencur;
    v_select varchar(500);
  begin
    
    v_select := 'select * from emp where deptno = ' 
      || to_char(v_deptno );
    open v_returncursor for v_select;
    return v_returncursor;
    
  end;

end util;


declare
  v_cur util.gencur;
  r     emp%rowtype;
begin
  v_cur := util.f_emp_x_dep(30);
  fetch v_cur into r;
  dbms_output.put_line( to_char(v_cur%rowcount) || ' ' || r.ename );
  close v_cur;
end;


declare
  v_cur util.gencur;
  r     emp%rowtype;
begin
  v_cur := util.f_emp_x_dep(30);
  fetch v_cur into r;
  while v_cur%found loop
    dbms_output.put_line( to_char(v_cur%rowcount) || ' ' || r.ename );
    fetch v_cur into r;
  end loop;
  close v_cur;
end;




