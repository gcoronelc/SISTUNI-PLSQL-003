CREATE OR REPLACE
PROCEDURE SP_EXAM1
IS
  CURSOR c_moneda
  IS
    SELECT * FROM moneda;
  r_moneda moneda%rowtype;
BEGIN
  OPEN c_moneda;
  LOOP
    FETCH c_moneda INTO r_moneda;
    EXIT
  WHEN c_moneda%notfound;
    dbms_output.put_line(r_moneda.chr_monecodigo || ' - ' ||r_moneda.vch_monedescripcion);
  END LOOP;
  CLOSE c_moneda;
END;
CALL SP_EXAM1 ();




CREATE OR REPLACE
PROCEDURE SP_EXAMEN2
IS
  CURSOR c_sucursal
  IS
    SELECT * FROM sucursal;
    r sucursal%rowtype;
BEGIN
  OPEN c_sucursal;
  LOOP
    FETCH c_sucursal INTO r;
    EXIT
  WHEN c_sucursal%notfound;
    dbms_output.put_line(r.chr_sucucodigo|| ' - ' ||r.vch_sucunombre);
  END LOOP;
  CLOSE c_sucursal;
END;
CALL SP_EXAMEN2();
