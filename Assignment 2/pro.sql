/* PROCEDURE 1 */

set serveroutput on size 30000;


CREATE OR REPLACE PROCEDURE pro_print_borrower 
IS

begin

    DECLARE 
	    name varchar2(30);
	    title varchar2(50);
	    dateIssued date;
	    date_difference number;
	    today date;

	CURSOR c1 is 
		SELECT Borrower.name, Books.book_title, Issue.issue_date
		FROM Borrower, Books, Issue
		WHERE Borrower.borrower_id = Issue.borrower_id AND Books.book_id = Issue.book_id for update;

	begin 
		OPEN c1;
		dbms_output.put_line('Borrower Name       Book Title 	  No. of Days');
		dbms_output.put_line('-----------------------------------------------');

		LOOP
			FETCH c1 into name,title, dateIssued;
			EXIT WHEN c1%notfound; 

		

			SELECT sysdate
			INTO today
			FROM dual;

			date_difference := (today - dateIssued);

			IF date_difference >=0 then
				dbms_output.put_line(name || '______' || title || '_______'|| date_difference);
			END IF;

		END LOOP;
		close c1;
		end;
end;
/
/* PROCEDURE 2 */

CREATE OR REPLACE PROCEDURE pro_print_fine(current_date IN date)
IS 

begin

	DECLARE
	name varchar2(30);
	id number;
	dateIssued date;
	dateReturn date;
	date_difference number;
	fine number := 0;
	len number;

	CURSOR c1 is
		SELECT B.name, I.book_id, I.issue_date, I.return_date
		FROM Borrower B, Books Bk, Issue I
		WHERE B.borrower_id = I.borrower_id AND Bk.book_id = I.book_id;

	begin

		OPEN c1;
		dbms_output.put_line('Borrower Name  	Book ID  	Issue Date 		Fine Paid/To be Paid');

		LOOP

			FETCH c1 into name, id, dateIssued, dateReturn;
			EXIT WHEN c1%notfound;


			IF (dateReturn != NULL) then
				date_difference := (dateReturn - dateIssued);
			ELSE
				date_difference := (current_date - dateIssued);
			END IF;

			IF (date_difference > 5) then 
				fine := (date_difference - 5) * 5;
			END IF;

			dbms_output.put_line(name || '    		' || id || '    ' || dateIssued || '    	'|| fine);

		END LOOP;

		CLOSE c1;



	end;

end;
/

/* PROCEDURE 3 */
CREATE OR REPLACE PROCEDURE pro_listborr_mon(borrowerid IN number, month IN number, year IN number)
IS 

begin

	DECLARE
		name varchar2(30);
		title varchar2(50);
		ID number;
		bookID number;
		dateIssued date;
		dateReturn date;
		ind number := 1;

		CURSOR c1 is 
			SELECT B.name, B.borrower_id, Bk.book_id, Bk.book_title, I.issue_date, I.return_date
			FROM Borrower B, Books Bk, Issue I
			WHERE I.borrower_id = borrowerid AND B.borrower_id = I.borrower_id AND Bk.Book_id = I.book_id AND to_number(to_char(I.issue_date,'mm')) = month AND to_number(to_char(I.issue_date,'yyyy')) = year;

	begin

	OPEN c1;

	LOOP

		FETCH c1 into name, ID, bookID,title,dateIssued, dateReturn;
		EXIT WHEN c1%notfound;



		dbms_output.put_line('( ' ||ind || ')Borrower ID: ' || ID);
		dbms_output.put_line('Borrower Name: ' || name);
		dbms_output.put_line('Book ID: ' || bookID);
		dbms_output.put_line('Title: ' || title);
		dbms_output.put_line('Issue Date: ' || dateIssued);
		dbms_output.put_line('Return Date: ' || dateReturn);
		ind := ind +1;

	END LOOP;

	CLOSE c1;


	end;


end;
/	

/* PROCEDURE 4 */


CREATE OR REPLACE PROCEDURE pro_listborr
IS

begin

	DECLARE

		name varchar2(30);
		bookID number;
		dateIssued date;
		ind number := 1;

		cursor c1 is
			SELECT B.name, I.book_id, I.issue_date
			FROM Borrower B, Issue I
			WHERE I.return_date IS NULL AND I.borrower_id = B.borrower_id; 

		begin
			OPEN c1;
			LOOP
				FETCH c1 into name, bookID, dateIssued;
				EXIT WHEN c1%notfound;

				dbms_output.put_line(ind || ')Borrower Name: '|| name);
				dbms_output.put_line('Book ID: '|| bookID);
				dbms_output.put_line('Issue Date: '|| dateIssued);
				ind := ind +1;

			END LOOP;

			CLOSE c1;


		end;


end;
/
