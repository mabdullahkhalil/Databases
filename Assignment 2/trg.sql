CREATE OR REPLACE TRIGGER TRG_MAXBOOKS BEFORE INSERT ON Issue

for each row

DECLARE
	borrowerStatus varchar2(20);
	tally number;

begin
	select Status
	into borrowerStatus
	from Borrower
	where borrower_id = :new.borrower_id;
	
	select count(*)
	into tally
	from Issue I
	where I.borrower_id = :new.borrower_id;

	if (borrowerStatus = 'faculty' AND tally = 3) then
		RAISE_APPLICATION_ERROR(num=> -20500, msg=> 'Faculty cannot issue more than 3 books');
	elsif (borrowerStatus = 'student' AND tally = 2) then
		RAISE_APPLICATION_ERROR(num=> -20501, msg=> 'student cannot issue more than 2 books');
	end if;

end trg_maxbooks;
/


/* trigger 2 */

CREATE OR REPLACE TRIGGER TRG_ISSUE AFTER INSERT ON Issue

for each row

begin

	UPDATE Books SET status = 'issued' where book_id = :new.book_id;

end;
/


/* trigger 3 */

CREATE OR REPLACE TRIGGER TRG_NOTISSUE AFTER UPDATE OF return_date ON Issue

for each row

begin
	
	UPDATE books SET status = 'not issued' where book_id = :old.book_id;

end;
/
