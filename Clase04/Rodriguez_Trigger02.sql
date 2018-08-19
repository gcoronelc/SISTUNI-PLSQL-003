CREATE TABLE sal_History(
    EmpNo Number(4) not null,
    SalOld Number(7,2) null,
    SalNew Number(7,2) null,
    StarDate Date not null,
    SetUser Varchar2(30) not null
);

--

CREATE OR REPLACE TRIGGER tr_UpdateEmpSal
After Insert or Update on Emp
for each row
begin
 Insert Into sal_history (EmpNo,SalOld,SalNew, StarDate, SetUser)
 Values (:New.EmpNo,:Old.Sal,:New.Sal,sysdate,USER);
 End tr_UpdateEmpSal;
