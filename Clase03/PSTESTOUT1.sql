CREATE OR REPLACE PROCEDURE PSTESTOUT1 
(P_RAISE IN BOOLEAN, P_DATO OUT VARCHAR2)
IS
  EXCEP1 EXCEPTION;
BEGIN
  P_DATO := 'PLSQL es PODEROSO';
  IF P_RAISE THEN
    RAISE EXCEP1;
  ELSE 
    RETURN;
  END IF;
END;
/

DECLARE 
  V_DATO VARCHAR2(100) := 'PERU CAMPEON';
BEGIN
  PSTESTOUT1(TRUE,V_DATO);
  DBMS_OUTPUT.PUT_LINE(V_DATO);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(V_DATO);
END;

