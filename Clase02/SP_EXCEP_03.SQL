CREATE OR REPLACE PROCEDURE SCOTT.SP_EXCEP_03
( EMPNO NUMBER )
IS
  SALARIO NUMBER;
BEGIN
  SELECT SAL INTO SALARIO
  FROM EMP 
  WHERE EMPNO = EMPNO;
  DBMS_OUTPUT.PUT_LINE('SALARIO: ' || SALARIO);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('CODIGO NO EXISTE.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

CALL SCOTT.SP_EXCEP_03( 7369 );