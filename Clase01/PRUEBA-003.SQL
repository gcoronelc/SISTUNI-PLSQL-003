-- PROCEDIMIENTO

CREATE OR REPLACE PROCEDURE SCOTT.SP_SUMAR
(P_N1 IN NUMBER, P_N2 IN NUMBER)
IS
  V_SUMA NUMBER;
BEGIN
  -- PROCESO
  V_SUMA := P_N1 + P_N2;
  -- REPORTE
  DBMS_OUTPUT.PUT_LINE('N1 :   ' || P_N1);
  DBMS_OUTPUT.PUT_LINE('N1 :   ' || P_N1);
  DBMS_OUTPUT.PUT_LINE('SUMA : ' || V_SUMA);
END;



call SCOTT.SP_SUMAR( 23,56 );






