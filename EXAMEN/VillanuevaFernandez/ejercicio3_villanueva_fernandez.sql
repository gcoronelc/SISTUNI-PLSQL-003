CREATE OR REPLACE PROCEDURE SP_CAMBIO_MATRICULA(
curso matricula.cur_id%TYPE,
alumno matricula.alu_id%TYPE,
cursoNuevo matricula.cur_id%TYPE
)
IS 
  Cont NUMBER;
BEGIN
  SELECT Count(*) Into Cont 
     FROM matricula
     WHERE cur_id=curso and alu_id = alumno;
  if(Cont =0)then
     RAISE NO_DATA_FOUND;
  end if;
  UPDATE matricula 
     SET cur_id = cursoNuevo
     WHERE alu_id = alumno and cur_id= curso;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE(' PROCESO OK ');
  dbms_output.put_line('curso antiguo: '|| curso ||' curso nuevo: '|| cursoNuevo);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO HAY ALUMNO MATRICULADO.');
END;

call SP_CAMBIO_MATRICULA(1,5,3);