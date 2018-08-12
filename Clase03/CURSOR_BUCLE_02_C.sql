CREATE OR REPLACE PROCEDURE SP_EMP_MAS_GANA_X_DEP
AS
  cursor c_dept is 
    select * from EMP 
    WHERE (deptno, SAL) IN (SELECT deptno, MAX(SAL) 
                            FROM EMP GROUP BY DEPTNO);
  V_FILA VARCHAR2(1000);
BEGIN
  for r in c_dept loop
    V_FILA := r.deptno||' - ' || R.SAL || ' - ' || R.ENAME;
    dbms_output.put_line(V_FILA);            
  end loop;
END;

CALL SP_EMP_MAS_GANA_X_DEP();


