--10.4

CREATE OR REPLACE PROCEDURE PR114
( P_DEPTNO NUMBER := 10)
IS 
  cursor c_demo (PC_DEPTNO NUMBER := 20) is 
  select * from dept where deptno = PC_DEPTNO;
  r dept%rowtype;
BEGIN
  open c_demo( P_DEPTNO );
  fetch c_demo into r;
  if(c_demo%FOUND) then
    DBMS_OUTPUT.PUT_LINE('deptno:'||r.deptno);
    DBMS_OUTPUT.PUT_LINE('dname:'||r.dname);
    DBMS_OUTPUT.PUT_LINE('dloc:'||r.loc);
  end if;  
  close c_demo;
END;

call pr114();

call pr114(20);

call pr114(2000);

