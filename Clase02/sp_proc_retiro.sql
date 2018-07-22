-- PROCESO RETIRO
-- =======================
/*
1.- Verificar saldo
2.- Actualizar cuenta
3.- Registrar movimiento
*/

create or replace  procedure eureka.sp_proc_retiro
(
   p_cuenta     eureka.cuenta.chr_cuencodigo%type,
   p_importe    eureka.cuenta.dec_cuensaldo%type,
   p_clave        eureka.cuenta.chr_cuenclave%type,
   p_empleado eureka.empleado.chr_emplcodigo%type
)
is
  v_saldo   eureka.cuenta.dec_cuensaldo%type;
  v_nro_mov eureka.movimiento.int_movinumero%type;
  v_mensaje varchar2(1000);
begin

  -- 1.- Verificar saldo
  
  select dec_cuensaldo into v_saldo
  from cuenta where chr_cuencodigo = p_cuenta
  for update;
  
  if( v_saldo < p_importe ) then
    raise_application_error(-20000,'No hay saldo suficiente.');  
  end if;
  
  APEX_UTIL.PAUSE(2);
  
  -- 2.- Actualizar cuenta
  
  v_saldo := v_saldo - p_importe;
  update cuenta
  set dec_cuensaldo = v_saldo
  where chr_cuencodigo = p_cuenta;
  
  DBMS_OUTPUT.PUT_LINE('NUEVO SALDO' || to_char(v_saldo));
  
  -- 3.- Registrar movimiento
  
  update cuenta
  set int_cuencontmov = int_cuencontmov + 1
  where chr_cuencodigo = p_cuenta
  returning int_cuencontmov into v_nro_mov;
  
  insert into movimiento(chr_cuencodigo, int_movinumero, 
  dtt_movifecha, chr_emplcodigo, chr_tipocodigo, dec_moviimporte)
  values(p_cuenta, v_nro_mov, sysdate, p_empleado, '004', p_importe);
  
  commit;
  
exception

  when others then
    DBMS_OUTPUT.PUT_LINE('Error Nro. ORA' || to_char(sqlcode));
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
    rollback;
end;




call eureka.sp_proc_retiro('00100001', 100,'123456', '0003');



