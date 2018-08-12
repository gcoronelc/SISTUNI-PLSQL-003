CREATE OR REPLACE PROCEDURE SP_CURSOR_BUCLE_01
IS 
  cursor c_demo is select * from dept;
  r dept%rowtype;
BEGIN
  open c_demo;
  LOOP
    fetch c_demo into r;
    EXIT WHEN C_DEMO%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(r.deptno || '-' ||r.dname);
  END LOOP;
  close c_demo;
END;

call SP_CURSOR_BUCLE_01();