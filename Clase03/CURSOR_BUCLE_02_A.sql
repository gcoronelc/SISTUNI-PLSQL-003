CREATE OR REPLACE PROCEDURE SP_EMP_MAS_GANA_X_DEP
AS
  cursor c_dept is select * from dept;
  V_FILA VARCHAR2(1000);
  V_SALARIO NUMBER(8,2);
BEGIN
  for r in c_dept loop
    -- SALARIO MAYOR
    SELECT MAX(SAL) INTO V_SALARIO 
    FROM EMP WHERE deptno = R.DEPTNO;
    -- AVERIGUAR EL EMPLEADO
    FOR A IN (  SELECT ENAME FROM EMP 
                WHERE deptno = R.DEPTNO 
                AND SAL = V_SALARIO ) LOOP
      V_FILA := r.deptno||' - ' || V_SALARIO || ' - ' || A.ENAME;
      dbms_output.put_line(V_FILA);            
    END LOOP;
  end loop;
END;

CALL SP_EMP_MAS_GANA_X_DEP();


