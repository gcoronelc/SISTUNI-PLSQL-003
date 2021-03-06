--ESTRUCTURAS SELECTIVAS
CREATE OR REPLACE FUNCTION SCOTT.FN_CLASIFICAR_SALARIO
(P_EMPNO IN EMP.EMPNO%TYPE)
RETURN VARCHAR2
IS 
--DEL PARAMETRO NO ESTABLECES TAMA�O
 V_SAL EMP.SAL%TYPE;
 V_MSG VARCHAR2(30);
BEGIN
  SELECT SAL INTO V_SAL FROM EMP WHERE EMPNO=P_EMPNO;
  IF(V_sAL<2500)THEN
    V_MSG :='SALARIO BAJO';
  ELSIF(V_SAL<4000)THEN
    V_MSG :='SALARIO REGULAR';
  ELSE
    V_MSG := 'SALARIO BUENO';
  END IF;
  V_MSG := TO_CHAR(V_SAL) || ' - ' || V_MSG;
  RETURN V_MSG;
END; 
SELECT FN_CLASIFICAR_SALARIO(7698) FROM DUAL;