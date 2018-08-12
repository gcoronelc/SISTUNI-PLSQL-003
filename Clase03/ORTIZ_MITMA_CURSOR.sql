--10.4

CREATE OR REPLACE PROCEDURE PR114
IS 
  cursor c_demo is select * from dept where deptno=10;
  r dept%rowtype;
BEGIN
  open c_demo;
  fetch c_demo into r;
  if(c_demo%FOUND) then
    DBMS_OUTPUT.PUT_LINE('deptno:'||r.deptno);
    DBMS_OUTPUT.PUT_LINE('dname:'||r.dname);
    DBMS_OUTPUT.PUT_LINE('dloc:'||r.loc);
  end if;  
  close c_demo;
END;

call pr114();