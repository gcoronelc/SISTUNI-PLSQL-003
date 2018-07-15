 CREATE OR REPLACE FUNCTION scott.FN104 
 (P_EMPNO scott.EMP.EMPNO%TYPE)
 RETURN VARCHAR2
 IS
 V_SAL scott.EMP.SAL%TYPE;
 V_MSG VARCHAR2(30);
 BEGIN
 SELECT SAL INTO V_SAL FROM EMP WHERE EMPNO= P_EMPNO;
 
 IF(V_SAL < 2500) THEN
  V_MSG := 'salario bajo';
 ELSIF(V_SAL <4000) THEN
 V_MSG := 'salario regular';
 ELSE
 V_MSG := 'salario bueno';
 end if;
 v_msg := to_char(v_Sal) ||' - '||v_msg;
 return v_msg;
 END;
 
 
 SELECT scott.FN104(7499) FROM DUAL; 
 
 
 