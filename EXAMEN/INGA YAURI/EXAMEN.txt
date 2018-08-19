--CASO1
create or replace procedure ps_caso1
is
  cursor c_moneda is select * from cuenta;
  --inner join cuenta cu on m.CHR_MONECODIGO= cu.CHR_MONECODIGO;
  cod_mon number;
  desc_mon varchar2(10);
  cont_cuenta number;
  importe number;
  cad varchar2(50);
begin
   for p in c_moneda loop
     select p.CHR_MONECODIGO,count(*), sum(nvl(DEC_CUENSALDO,0)) into cod_mon,cont_cuenta,importe
     from cuenta where CHR_MONECODIGO='01';
     
     select p.CHR_MONECODIGO,count(*), sum(nvl(DEC_CUENSALDO,0)) into cod_mon,cont_cuenta,importe
     from cuenta where CHR_MONECODIGO='02';
     
     cad := p.CHR_MONECODIGO|| '- soles -'||cont_cuenta || '-' || importe;
     
   end loop;
   
   dbms_output.put_line(cad);
end;

 call ps_caso1();



