create or replace package pkg_demo as

	function suma( n1 in number, n2 in number)
	return number;

end pkg_demo;
/


create or replace package body pkg_demo as

	function suma( n1 in number, n2 in number)
	return number
	is
		v_suma number;
	begin
		v_suma := n1 + n2;
		return v_suma;
	end;

end pkg_demo;
/


select scott.pkg_demo.suma( 23, 45 ) SUMA
from dual;


DECLARE
	V_SUMA NUMBER;
	V_N1 NUMBER := 12;
	V_N2 NUMBER := 27;
BEGIN
	V_SUMA := scott.pkg_demo.suma( V_N1, V_N2 );
	DBMS_OUTPUT.PUT_LINE('SUMA: ' || V_SUMA );
END;
/







