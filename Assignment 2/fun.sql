/* function 1 */


CREATE OR REPLACE FUNCTION fun_issue_book (borrower_id number, bookid number, currentdate date)
RETURN number
AS temp_status varchar2(20);

        BEGIN

                SELECT status into temp_status
                FROM Books
                WHERE Books.book_id = bookid;



                                IF temp_status != 'issued' THEN
                                        INSERT into Issue values(bookid,borrower_id,currentdate, NULL);
                                        return 1;

                                ELSE
                                        INSERT into Pending_request values(bookid, borrower_id, currentdate, NULL);
                                        return 0;
                                END IF;


          
        end fun_issue_book;
.
run;

/* function 2 */


CREATE OR REPLACE FUNCTION fun_issue_anyedition(borrowerid IN number,booktitle IN varchar2, author_name IN varchar2,currentdate IN date)
RETURN number
IS 

        
        DECLARE 
                flag boolean;
                available_edition number := 0;
                id number := 0;
                min_date date;

        BEGIN

                SELECT Books.edition, Books.book_id
                INTO available_edition, id 
                FROM Books, Author
                Where Books.book_title = booktitle AND Author.author_id = Books.author_id  AND Author.name = author_name AND 
                Books.edition = (
                SELECT MAX(B.edition)
                FROM Books B, Author A
                WHERE B.status = 'not issued' AND B.book_title = booktitle AND B.author_id = A.author_id AND A.name = author_name );

                IF available_edition = 0 THEN
                        SELECT MIN(Issue.return_date), Issue.book_id
                        INTO min_date, id
                        FROM Issue
                        WHERE Issue.book_id =
                        (
                                SELECT B.book_id
                                FROM Books B, Author A 
                                WHERE B.book_title = booktitle AND B.author_id = A.author_id AND A.name = author_name AND B.status = 'issued'
                        );
                        INSERT into Pending_request values(id, borrowerid, currentdate, min_date);
                        return 0;

                        
                ELSE
                        flag := TRUE;   
                        UPDATE Books SET status = 'issued' WHERE Books.book_id = id;
                        INSERT into Issue values(id,borrowerid,currentdate, NULL);
                        return 1;
                END IF;
                return (flag);
                exception WHEN others then
                return NULL;        

        END fun_issue_anyedition;
.
run;



-- /* function 3 */

CREATE OR REPLACE FUNCTION fun_most_popular(month in number, year in number)
RETURN number
IS


begin

        DECLARE
                ID number;
                tally number;
                flag boolean := TRUE;

                --type listIDs IS VARRAY(50) OF NUMBER;
                cursor c1 is
                        SELECT book_id 
                        FROM (select I.book_id, count(*) as h
                                from books Bo, issue I 
                                WHERE Bo.book_id = I.book_id AND to_number(to_char(I.issue_date,'mm')) = month AND to_number(to_char(I.issue_date,'yyyy')) = year 
                                group by I.book_id
                                )
                        where h = ( select max(count(*))
                                from books,issue
                                where to_number(to_char(issue_date,'yyyy')) = year AND to_number(to_char(issue_date,'mm')) = month AND books.book_id = issue.book_id
                                group by issue.book_id
                        ); 
                        /* link used for help : http://www.tutorialspoint.com/plsql/plsql_arrays.htm */
                        type listIDs is VARRAY (50) of Issue.book_id%type;
                        collection listIDs := listIDs();
                        ind integer := 0;

        begin

                OPEN c1;
                dbms_output.put_line('List of most popular books for month: ' || month || ' and year: ' || year );
                LOOP
                        FETCH c1 into ID;
                        EXIT when c1%notfound;
                        ind := ind +1;
                        collection.extend();
                        collection(ind) := ID;
                        dbms_output.put_line('BookID('||ind ||'):' || collection(ind));

                END LOOP;

                return 1;
                exception WHEN others then
                return NULL;   
        end;
        
end;
/


-- /* function 4 */

-- CREATE OR REPLACE FUNCTION fun_return_book(bookid IN number, currentdate IN date)
-- RETURN boolean
-- IS 


-- BEGIN


--         DECLARE
--                         newUser boolean := TRUE;
--                         min_date date;
--                         flag boolean := FALSE;
--                         total number;
--                         id number;
--                         req_id number;
--                         cursor c1 is
--                                 SELECT book_id
--                                 FROM Issue;
--                 BEGIN
--                         OPEN c1; 
--                         LOOP
--                                 FETCH c1 into id;
--                                 EXIT WHEN c1%notfound; 
                                
--                                 if id = bookid then
--                                 flag := TRUE;
                                
--                                 END IF;
--                         END LOOP;

--                                 if flag = TRUE then
--                                 UPDATE Issue SET Issue.return_date = currentdate WHERE Issue.book_id = bookid;

--                                 SELECT MIN(Pending_request.request_date), Pending_request.requester_id
--                                 INTO min_date, req_id
--                                 FROM Pending_request
--                                 WHERE Pending_request.book_id = book_id
--                                 GROUP BY Pending_request.requester_id;

--                                 END IF;

--                                 EXCEPTION 
--                                         WHEN NO_DATA_FOUND then
--                                                 dbms_output.put_line('No interested borrower found in the Pending list.');
--                                                 newUser := FALSE;
--                                          WHEN others then
                                         
--                                                 return NULL;   

--                                 IF newUser = TRUE then
--                                         INSERT into Issue values(bookid,req_id,currentdate,NULL);
--                                 END IF;

                        
--                 END;
-- END;
-- /



-- /* function 5 */


CREATE OR REPLACE FUNCTION fun_renew_book (borrowerid IN number, bookid IN number, currentdate IN date)
RETURN number
IS

flag number := 0;
req_id number := 0;
issued boolean := FALSE;
id number := 0;
min_date date;

BEGIN

        select Issue.book_id into id
        from Issue
        where Issue.book_id = bookid;

        If id = bookid Then
                select P.requester_id into req_id
                from Pending_request P
                where P.book_id = bookid;
                
                If req_id = 0 Then
                        flag := 1;
                        UPDATE Issue SET Issue.issue_date = currentdate where Issue.book_id = bookid and Issue.borrower_id=borrowerid;
                END IF;
        END IF;
        EXCEPTION
                WHEN NO_DATA_FOUND then 
                        dbms_output.put_line('MESSAGE: Book Issued Successfully. No other user is interested in this book');

                   
        RETURN flag;
        -- exception WHEN others then
        -- return NULL;   


END;
/
