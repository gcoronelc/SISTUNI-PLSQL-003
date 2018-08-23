create or replace procedure sp_consultar(
  p_cursor1 out nocopy sys_refcursor,
  p_cursor2 out nocopy sys_refcursor)
as begin
 open p_cursor1 for
  select 
   c.chr_monecodigo,
   m.vch_monedescripcion,
   count(c.chr_cuencodigo),
   sum(c.dec_cuensaldo)
  from cuenta c, moneda m
  where c.chr_monecodigo = m.chr_monecodigo
  group by c.chr_monecodigo, m.vch_monedescripcion;
 open p_cursor2 for
  select
   c.chr_sucucodigo,
   s.vch_sucunombre,
   c.chr_monecodigo,
   count(chr_cuencodigo),
   sum(c.dec_cuensaldo)
  from cuenta c, sucursal s
  where c.chr_sucucodigo = s.chr_sucucodigo
  group by c.chr_sucucodigo, s.vch_sucunombre, c.chr_monecodigo; 
end;






declare
 v_cursor1 SYS_REFCURSOR;
 v_cursor2 SYS_REFCURSOR;

 v_codigo cuenta.chr_monecodigo%TYPE;
 v_descripcion moneda.vch_monedescripcion%TYPE;
 v_cuentas NUMBER;
 v_importe NUMBER;

 v_codigo2 cuenta.chr_sucucodigo%TYPE;
 v_descripcion2 sucursal.vch_sucunombre%TYPE;
 v_moneda cuenta.chr_monecodigo%TYPE;
 v_cuentas2 NUMBER;
 v_importe2 NUMBER;
begin
 sp_consultar(v_cursor1,v_cursor2);
 dbms_output.put_line('Resumen por moneda');
 dbms_output.put_line('Codigo | descripcion | cuentas | importe');
 loop
  fetch v_cursor1 into v_codigo, v_descripcion, v_cuentas, v_importe;
  exit when v_cursor1%NOTFOUND;  
  dbms_output.put_line(v_codigo || ' | ' || v_descripcion|| ' | ' || v_cuentas || ' | ' || v_importe);
 end loop;
 close v_cursor1;
  dbms_output.put_line('================================================================================');
  dbms_output.put_line('Resumen por sucursal');
  dbms_output.put_line('Codigo | descripcion | moneda | cuentas | importe');
 loop
  fetch v_cursor2 into v_codigo2, v_descripcion2, v_moneda, v_cuentas2, v_importe2;
  exit when v_cursor2%NOTFOUND;
  dbms_output.put_line(v_codigo2 || ' | ' || v_descripcion2 || ' | ' || v_moneda || ' | ' || v_cuentas2|| ' | ' ||v_importe2);
 end loop;
 close v_cursor2;
end;
