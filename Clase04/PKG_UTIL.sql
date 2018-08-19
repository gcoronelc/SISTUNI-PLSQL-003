create or replace package SCOTT.PKG_UTIL is

  type gencur is ref cursor;

  function f_emp_x_dep( v_deptno number ) return gencur;
  
  function f_emp_x_dep_v2( v_deptno number ) return gencur;
  
  function f_emp_x_dep_v3( v_deptno number ) return gencur;

end PKG_UTIL;
/

create or replace package body SCOTT.PKG_UTIL as

  function f_emp_x_dep( v_deptno number ) return gencur
  is
    v_returncursor gencur;
    v_select varchar(500);
  begin
    
    v_select := 'select * from scott.emp where deptno = ' 
      || to_char(v_deptno );
    open v_returncursor for v_select;
    return v_returncursor;
    
  end;
  
  function f_emp_x_dep_V2( v_deptno number ) return gencur
  is
    v_returncursor gencur;
    v_select varchar(500);
  begin
    
    v_select := 'select * from scott.emp ';
	v_select := v_select || 'where deptno = :codigo'; 
    open v_returncursor for v_select using v_deptno;
    return v_returncursor;
    
  end;
  
  function f_emp_x_dep_V3( v_deptno number ) return gencur
  is
    v_returncursor gencur;
  begin
 
    open v_returncursor for 
	select * from scott.emp where deptno = v_deptno;
	
    return v_returncursor;
    
  end;

end PKG_UTIL;
/

declare
  v_cur scott.PKG_UTIL.gencur;
  r     scott.emp%rowtype;
begin
  v_cur := scott.PKG_UTIL.f_emp_x_dep(30);
  fetch v_cur into r;
  dbms_output.put_line( to_char(v_cur%rowcount) || ' ' || r.ename );
  close v_cur;
end;


declare
  v_cur scott.PKG_UTIL.gencur;
  r     scott.emp%rowtype;
begin
  v_cur := scott.PKG_UTIL.f_emp_x_dep(30);
  fetch v_cur into r;
  while v_cur%found loop
    dbms_output.put_line( to_char(v_cur%rowcount) || ' ' || r.ename );
    fetch v_cur into r;
  end loop;
  close v_cur;
end;

declare
  v_cur scott.PKG_UTIL.gencur;
  r     scott.emp%rowtype;
begin
  v_cur := scott.PKG_UTIL.f_emp_x_dep_v2(30);
  fetch v_cur into r;
  while v_cur%found loop
    dbms_output.put_line( to_char(v_cur%rowcount) || ' ' || r.ename );
    fetch v_cur into r;
  end loop;
  close v_cur;
end;

declare
  v_cur scott.PKG_UTIL.gencur;
  r     scott.emp%rowtype;
begin
  v_cur := scott.PKG_UTIL.f_emp_x_dep_v3(30);
  fetch v_cur into r;
  while v_cur%found loop
    dbms_output.put_line( to_char(v_cur%rowcount) || ' ' || r.ename );
    fetch v_cur into r;
  end loop;
  close v_cur;
end;


