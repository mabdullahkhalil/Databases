
0 - Setup

begin
DBMS_output.ENABLE(1000000);
end;
/



set serveroutput on size 30000;
@createtable
@fun
@pro

-- var n varchar2(50)

begin
dbms_output.put_line('==================================================');
dbms_output.put_line('1 - Populate Author, Books and Borrower');
dbms_output.put_line('==================================================');
end;
/



@populate

begin
dbms_output.put_line('==================================================');
dbms_output.put_line('2 - Execute triggers');
dbms_output.put_line('==================================================');
end;
/



@trg

BEGIN
dbms_output.put_line('==================================================');
dbms_output.put_line('3 - Populate Issue and PEnding_request');
dbms_output.put_line('==================================================');
END;
/





begin
dbms_output.put_line('==================================================');
dbms_output.put_line('4 - Insert records with fun_issue_anyedition');
dbms_output.put_line('==================================================');
end;
/


declare
 n boolean;
begin
-- DECLARE n boolean := FALSE;
n := fun_issue_anyedition(2,'DATA MANAGEMENT','CJ DATES',to_date('9/3/17','MM/DD/YY'));
n :=fun_issue_anyedition(4,'CALCULUS','H ANTON',to_date('9/4/17','MM/DD/YY'));
n :=fun_issue_anyedition(5,'ORACLE','ORACLE PRESS',to_date('9/4/17','MM/DD/YY'));
n :=fun_issue_anyedition(10,'IEEE MULTIMEDIA','IEEE',to_date('9/27/17','MM/DD/YY'));
n :=fun_issue_anyedition(2,'MIS MANAGEMENT','CJ CATES',to_date('5/3/17','MM/DD/YY'));
n :=fun_issue_anyedition(4,'CALCULUS II','H ANTON',to_date('9/4/17','MM/DD/YY'));
n :=fun_issue_anyedition(10,'ORACLE','ORACLE PRESS',to_date('9/4/17','MM/DD/YY'));
n :=fun_issue_anyedition(5,'IEEE MULTIMEDIA','IEEE',to_date('9/26/17','MM/DD/YY'));
n :=fun_issue_anyedition(2,'DATA SRUCTURE','W GATES',to_date('9/3/17','MM/DD/YY'));
n :=fun_issue_anyedition(4,'CALCULUS III','H ANTON',to_date('9/4/17','MM/DD/YY'));
n :=fun_issue_anyedition(11,'ORACLE','ORACLE PRESS',to_date('9/8/17','MM/DD/YY'));
n :=fun_issue_anyedition(6,'IEEE MULTIMEDIA','IEEE',to_date('9/17/17','MM/DD/YY'));
end;
/


print n;

begin
dbms_output.put_line('==================================================');
dbms_output.put_line('5 - Execute pro_print_borrower');
dbms_output.put_line('==================================================');
end;
/



begin
pro_print_borrower;
end;
/



begin
dbms_output.put_line('==================================================');
dbms_output.put_line('6 - Execute pro_print_fine');
dbms_output.put_line('==================================================');
end;
/



begin
pro_print_fine(to_date('10/28/17','MM/DD/YY'));
end;
/



begin
dbms_output.put_line('==================================================');
dbms_output.put_line('7 - Return books 1, 2, 4 and 10');
dbms_output.put_line('==================================================');
end;
/


declare
	n boolean;
begin
n :=fun_return_book(1,to_date('10/28/17','MM/DD/YY'));
n :=fun_return_book(2,to_date('10/28/17','MM/DD/YY'));
n :=fun_return_book(4,to_date('10/28/17','MM/DD/YY'));
n :=fun_return_book(10,to_date('10/28/17','MM/DD/YY'));
end;
/


print n;

begin
dbms_output.put_line('==================================================');
dbms_output.put_line('8 - Print the pEnding_request and issue tables');
dbms_output.put_line('==================================================');
end;
/



select * from Pending_request;
select * from Issue;

begin
dbms_output.put_line('==================================================');
dbms_output.put_line('9 - Execute pro_listborr_mon for the month of Sept and October');
dbms_output.put_line('==================================================');
end;
/



begin
dbms_output.put_line('');
dbms_output.put_line('UNSPECIFIED BORROWER ID, USING 1 BY DEFAULT');
dbms_output.put_line('');
pro_listborr_mon(1,9, 2017);
dbms_output.put_line('');
dbms_output.put_line('UNSPECIFIED BORROWER ID, USING 1 BY DEFAULT');
dbms_output.put_line('');
pro_listborr_mon(1,10, 2017);
end;
/



begin
dbms_output.put_line('==================================================');
dbms_output.put_line('10 - Execute pro_listborr');
dbms_output.put_line('==================================================');
end;
/



begin
pro_listborr;

end;
/


begin
dbms_output.put_line('==================================================');
dbms_output.put_line('11 - Execute pro_list_popular');
dbms_output.put_line('==================================================');
end;
/


begin
pro_list_popular;
end;
/









-- CLEANUP

@dropall
