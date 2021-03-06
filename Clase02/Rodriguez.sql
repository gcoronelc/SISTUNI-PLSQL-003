-- EJERCICIO 7.3
CREATE OR REPLACE PROCEDURE UPDATE_SAL_EMP2
(CODIGO EMP.EMPNO%TYPE, SALARIO EMP.SAL%TYPE)
IS
  CONT NUMBER;
  EXCEP1 EXCEPTION;
BEGIN
  SELECT COUNT(*) INTO CONT
  FROM EMP
  WHERE EMPNO=CODIGO;
  
  IF (CONT=0) THEN
  RAISE EXCEP1;
  END IF;
  UPDATE EMP
    SET SAL =SALARIO
    WHERE EMPNO=CODIGO;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Proceso OK');
 
 EXCEPTION
  WHEN EXCEP1 THEN
    DBMS_OUTPUT.PUT_LINE('C�digo no existe');
END;

EXEC UPDATE_SAL_EMP2(9999,5000);
-- EJERCICIO 7.4

CREATE OR REPLACE PROCEDURE UPDATE_SAL_EMP3
(CODIGO EMP.EMPNO%TYPE, SALARIO EMP.SAL%TYPE)
IS
  CONT NUMBER;
  
BEGIN
  SELECT COUNT(*) INTO CONT
  FROM EMP
  WHERE EMPNO=CODIGO;
  
  IF (CONT=0) THEN
  RAISE_APPLICATION_ERROR(-20000 ,'No existe empleado.');
  END IF;
  UPDATE EMP
    SET SAL =SALARIO
    WHERE EMPNO=CODIGO;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Proceso OK');
END;


EXEC UPDATE_SAL_EMP3(9999,5000);
BEGIN UPDATE_SAL_EMP3(9999,5000); END;

-- EJERCICIO 7.5
CREATE OR REPLACE PROCEDURE UPDATE_SAL_EMP4
(CODIGO EMP.EMPNO%TYPE, SALARIO EMP.SAL%TYPE)
IS
  CONT NUMBER;
  
BEGIN
  SELECT COUNT(*) INTO CONT
  FROM EMP
  WHERE EMPNO=CODIGO;
  
  IF (CONT=0) THEN
  RAISE_APPLICATION_ERROR(-20000 ,'No existe empleado.');
  END IF;
  UPDATE EMP
    SET SAL =SALARIO
    WHERE EMPNO=CODIGO;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Proceso OK');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error Nro. ORA' || to_char(sqlcode));
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;

exec UPDATE_SAL_EMP4(9999,5000);

