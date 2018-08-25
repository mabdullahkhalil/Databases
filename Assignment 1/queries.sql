rem CS 340 Programming Assignment 1
rem Muhammad ABdullah
rem s19100142


SET SERVEROUTPUT ON
spool output.txt

BEGIN
 Dbms_Output.Put_Line('Query # 1 ');
END;
/

select P.pat_id
from PATENT P, CATEGORIES C 
where (P.subcat = C.subcat and (C.catnamelong = 'Chemical' Or C.catnamelong = 'Drugs AND Medical')) ;
 
BEGIN
 Dbms_Output.Put_Line('Query # 2');
END;
/

select I.lastname, I.firstname, I.country, I.postate
from INVENTOR I,PATENT P, CATEGORIES C 
where ((I.patentnum = P.pat_id)) and (P.subcat = C.subcat) and (C.catnamelong = 'Chemical' Or C.catnamelong = 'Drugs AND Medical');


BEGIN
 Dbms_Output.Put_Line('Query # 3');
END;
/

select I.lastname, I.firstname, I.country, I.postate
from INVENTOR I,PATENT P, CATEGORIES C 
where ((I.patentnum = P.pat_id)) and (P.subcat = C.subcat) and (C.catnamelong = 'Chemical');



BEGIN
 Dbms_Output.Put_Line('Query # 4 ');
END;
/

-- DBMS_OUTPUT.PUT_LINE('Query #1')
select P.pat_id
from PATENT P, INVENTOR I
where (I.patentnum=p.pat_id and (I.postate= 'CA' or I.postate= 'NJ')) ;



BEGIN
 Dbms_Output.Put_Line('Query # 5');
END;
/

-- DBMS_OUTPUT.PUT_LINE('Query #1')
select P.pat_id
from PATENT P, INVENTOR I
where (I.patentnum=p.pat_id and (I.postate= 'CA' or I.postate= 'NJ') and (I.invseq=1 or I.invseq=2)) ;


BEGIN
 Dbms_Output.Put_Line('Query # 6');
END;
/


select compname 
from company
where company.assignee in 
(select assignee
   from (select assignee, count(*) as ptnumber
		   from patent
		   group by assignee
		   order by count(*) desc)
		   where ptnumber = (
			   select max(count(*))
			   from patent
			   group by assignee));


BEGIN
 Dbms_Output.Put_Line('Query # 7');
END;
/


select compname 
from company
where company.assignee in 
(  select assignee
   from (select p.assignee, count(*) as chemcat
     	 from patent p, CATEGORIES c
 		 where  (p.cat=c.cat )and( p.subcat=c.subcat) and (c.catnamelong='Chemical')
	     group by p.assignee
	     order by count(*) desc)
   where  rownum = 1 and chemcat = (
	   select max(count(*))
	   from patent pp, CATEGORIES cc
	   where (pp.cat=cc.cat )and( pp.subcat=cc.subcat) and (cc.catnamelong='Chemical')
	   group by assignee));





BEGIN
 Dbms_Output.Put_Line('Query # 8');
END;
/


select compname 
from company
where company.assignee in 
(  select assignee
   from (select p.assignee
     	 from patent p, CATEGORIES c
 		 where (p.cat=c.cat )and( p.subcat=c.subcat) and (c.catnamelong='Chemical')
	     group by p.assignee
	     having count(*)>2));
  

BEGIN
 Dbms_Output.Put_Line('Query # 9');
END;
/


select cc.compname,c.subcatname,count(*)
from categories c,company cc, patent p
where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Coating'
group by cc.compname,c.subcatname
having count(*) = 
(
	select max(count(*))
from categories c,company cc, patent p
	where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Coating'
	group by cc.compname
)
UNION
select cc.compname,c.subcatname,count(*)
from categories c,company cc, patent p
where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Agriculture AND Food AND Textiles'
group by cc.compname,c.subcatname
having count(*) = 
(
	select max(count(*))
from categories c,company cc, patent p
	where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Agriculture AND Food AND Textiles'
	group by cc.compname
)
UNION
select cc.compname,c.subcatname,count(*)
from categories c,company cc, patent p
where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Gas'
group by cc.compname,c.subcatname
having count(*) = 
(
	select max(count(*))
from categories c,company cc, patent p
	where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Gas'
	group by cc.compname
)
UNION
select cc.compname,c.subcatname,count(*)
from categories c,company cc, patent p
where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Organic Compounds'
group by cc.compname,c.subcatname
having count(*) = 
(
	select max(count(*))
from categories c,company cc, patent p
	where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Organic Compounds'
	group by cc.compname
)
UNION
select cc.compname,c.subcatname,count(*)
from categories c,company cc, patent p
where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Resins'
group by cc.compname,c.subcatname
having count(*) = 
(
	select max(count(*))
from categories c,company cc, patent p
	where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Resins'
	group by cc.compname
)
UNION
select cc.compname,c.subcatname,count(*)
from categories c,company cc, patent p
where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Miscellaneous-chemical'
group by cc.compname,c.subcatname
having count(*) = 
(
	select max(count(*))
from categories c,company cc, patent p
	where c.catnamelong= 'Chemical' and p.cat=c.cat and p.assignee=cc.assignee and c.subcatname='Miscellaneous-chemical'
	group by cc.compname
);




BEGIN
 Dbms_Output.Put_Line('Query # 10');
END;
/


select firstname, lastname, count(*) 
from inventor
where inventor.patentnum in ( select P.pat_id
from PATENT P, CATEGORIES C 
where (P.subcat = C.subcat and (C.catnamelong = 'Electrical AND Electronic')))
group by firstname, lastname
having count(*) = 
(
	select max(count(*))
	from inventor
	group by firstname,lastname
);



BEGIN
 Dbms_Output.Put_Line('Query # 11 ');
END;
/

select firstname, lastname, count(*) 
from inventor
where inventor.patentnum in ( select P.pat_id
from PATENT P, CATEGORIES C 
where (P.cat = C.cat and (C.catnamelong = 'Chemical')))
group by firstname, lastname
having count(*) = 
(
	select max(count(*))
	from inventor
	group by firstname,lastname
)
UNION
select firstname, lastname, count(*) 
from inventor
where inventor.patentnum in ( select P.pat_id
from PATENT P, CATEGORIES C 
where (P.cat = C.cat and (C.catnamelong = 'Mechanical')))
group by firstname, lastname
having count(*) = 
(
	select max(count(*))
	from inventor
	group by firstname,lastname
)
UNION
select firstname, lastname, count(*) 
from inventor
where inventor.patentnum in ( select P.pat_id
from PATENT P, CATEGORIES C 
where (P.cat = C.cat and (C.catnamelong = 'Electrical AND Electronic')))
group by firstname, lastname
having count(*) = 
(
	select max(count(*))
	from inventor
	group by firstname,lastname
)
UNION
select firstname, lastname, count(*) 
from inventor
where inventor.patentnum in ( select P.pat_id
from PATENT P, CATEGORIES C 
where (P.cat = C.cat and (C.catnamelong = 'Others')))
group by firstname, lastname
having count(*) = 
(
	select max(count(*))
	from inventor
	group by firstname,lastname
)
UNION
select firstname, lastname, count(*) 
from inventor
where inventor.patentnum in ( select P.pat_id
from PATENT P, CATEGORIES C 
where (P.cat = C.cat and (C.catnamelong = 'Computers AND Communications')))
group by firstname, lastname
having count(*) = 
(
	select max(count(*))
	from inventor
	group by firstname,lastname
)
UNION
select firstname, lastname, count(*) 
from inventor
where inventor.patentnum in ( select P.pat_id
from PATENT P, CATEGORIES C 
where (P.cat = C.cat and (C.catnamelong = 'Drugs AND Medical')))
group by firstname, lastname
having count(*) = 
(
	select max(count(*))
	from inventor
	group by firstname,lastname
);


------------------------------
BEGIN
 Dbms_Output.Put_Line('Query # 12 ');
END;
/

select cc.compname
from COMPANY CC, CATEGORIES c, patent p
where C.catnamelong='Electrical AND Electronic' and c.subcatname='Electrical Devices'  and p.cat=c.cat and cc.assignee=p.assignee
intersect
select cc.compname
from COMPANY cc, CATEGORIES c, patent p
where C.catnamelong='Electrical AND Electronic' and c.subcatname='Power Systems'  and p.cat=c.cat and cc.assignee=p.assignee
intersect
select cc.compname
from COMPANY cc, CATEGORIES c, patent p
where C.catnamelong='Electrical AND Electronic' and c.subcatname='Measuring AND Testing' and p.cat=c.cat and cc.assignee=p.assignee
intersect
select cc.compname
from COMPANY cc, CATEGORIES c, patent p
where C.catnamelong='Electrical AND Electronic' and c.subcatname='Nuclear AND X-rays' and p.cat=c.cat and cc.assignee=p.assignee
intersect
select cc.compname
from COMPANY cc, CATEGORIES c, patent p
where C.catnamelong='Electrical AND Electronic' and c.subcatname='Semiconductor Devices' and p.cat=c.cat and cc.assignee=p.assignee;





BEGIN
 Dbms_Output.Put_Line('Query # 14');
END;
/
select distinct cited
from citations 
where cited in 
(select cited
	from (select cited, count(*) as temp
		from citations
		group by cited)
	where temp = 
	(select max(count(*))
		from citations
		group by cited));


BEGIN
 Dbms_Output.Put_Line('Query # 15');
END;
/

select cited,c.catnamelong,count(*)
from citations, patent p, categories c
where cited in 
(select cited
	from (select cited, count(*) as temp
		from citations
		group by cited)
	where temp = 
	(select max(count(*))
		from citations
		group by cited)) and citations.citing=p.pat_id and p.cat=c.cat and  catnamelong ='Others'
group by citations.cited, c.catnamelong
UNION
select cited,c.catnamelong,count(*)
from citations, patent p, categories c
where cited in 
(select cited
	from (select cited, count(*) as temp
		from citations
		group by cited)
	where temp = 
	(select max(count(*))
		from citations
		group by cited)) and citations.citing=p.pat_id and p.cat=c.cat and  catnamelong ='Drugs AND Medical'
group by citations.cited, c.catnamelong
UNION
select cited,c.catnamelong,count(*)
from citations, patent p, categories c
where cited in 
(select cited
	from (select cited, count(*) as temp
		from citations
		group by cited)
	where temp = 
	(select max(count(*))
		from citations
		group by cited)) and citations.citing=p.pat_id and p.cat=c.cat and  catnamelong ='Mechanical'
group by citations.cited, c.catnamelong
UNION
select cited,c.catnamelong,count(*)
from citations, patent p, categories c
where cited in 
(select cited
	from (select cited, count(*) as temp
		from citations
		group by cited)
	where temp = 
	(select max(count(*))
		from citations
		group by cited)) and citations.citing=p.pat_id and p.cat=c.cat and  catnamelong ='Electrical AND Electronic'
group by citations.cited, c.catnamelong
UNION
select cited,c.catnamelong,count(*)
from citations, patent p, categories c
where cited in 
(select cited
	from (select cited, count(*) as temp
		from citations
		group by cited)
	where temp = 
	(select max(count(*))
		from citations
		group by cited)) and citations.citing=p.pat_id and p.cat=c.cat and  catnamelong ='Computers AND Communications'
group by citations.cited, c.catnamelong
UNION
select cited,c.catnamelong,count(*)
from citations, patent p, categories c
where cited in 
(select cited
	from (select cited, count(*) as temp
		from citations
		group by cited)
	where temp = 
	(select max(count(*))
		from citations
		group by cited)) and citations.citing=p.pat_id and p.cat=c.cat and  catnamelong ='Chemical'
group by citations.cited, c.catnamelong;




BEGIN
 Dbms_Output.Put_Line('Query # 16 ');
END;
/

select pat_id
from patent, citations
where patent.pat_id=citations.citing
group by pat_id
having count(*)=(
select max(count(*))
from patent, citations
where patent.pat_id=citations.citing
group by pat_id);



BEGIN
 Dbms_Output.Put_Line('Query # 17 ');
END;
/

select firstname,lastname, invseq, city, postate
from inventor, citations
where patentnum = cited
group by firstname, lastname, invseq, city, postate
having count(cited) = 
(
select max(count(cited))
from citations
group by cited);



BEGIN
 Dbms_Output.Put_Line('Query # 18');
END;
/

select firstname, lastname, count(*) 
from inventor
where inventor.invseq=1
group by firstname, lastname
having count(*) = 
(
	select max(count(*))
	from inventor
	group by firstname,lastname
);


BEGIN
 Dbms_Output.Put_Line('Query # 19');
END;
/



select firstname, lastname, count(*) 
from inventor, patent,categories
where inventor.invseq=1 and patent.pat_id=inventor.patentnum and patent.cat=categories.cat and catnamelong in (select distinct catnamelong
from categories)
group by firstname, lastname
having count(*) = 
(
	select max(count(*))
	from inventor
	group by firstname,lastname
);



----------------------------------------------

BEGIN
 Dbms_Output.Put_Line('Query # 20');
END;
/



select distinct pat_id
from patent p ,categories c
where not exists 
(select cited
from citations
where p.pat_id = citations.cited) and c.catnamelong='Chemical' and p.cat=c.cat;
---------------------------------------------------------------
BEGIN
 Dbms_Output.Put_Line('Query # 21');
END;
/
select cat, subcat, count(*) as total
from patent,inventor
where inventor.postate='CA'
group by cat, subcat
order by cat;



BEGIN
 Dbms_Output.Put_Line('Query # 22');
END;
/
select avg(temp)
from (
select P.assignee, count(*) as temp
from Patent P, Inventor I
where P.pat_id = I.patentnum and I.postate = 'NJ'
group by P.assignee
);

BEGIN
 Dbms_Output.Put_Line('Query # 23');
END;
/
select count(*) as temp, compname 
from company, patent 
where company.assignee = patent.assignee
group by company.compname
having count(*) >
(
	select avg(temp)
from (
select P.assignee, count(*) as temp
from Patent P, Inventor I
where P.pat_id = I.patentnum and I.postate = 'NY'
group by P.assignee
)
);


BEGIN
 Dbms_Output.Put_Line('Query # 24');
END;
/


select avg(temp)
from(
select patentnum, count(*) as temp 
from (
select pat_id
from patent, categories
where patent.cat = categories.cat and patent.subcat = categories.subcat and categories.catnamelong = 'Electrical AND Electronic') x,
inventor
where x.pat_id = inventor.patentnum
group by patentnum);


BEGIN
 Dbms_Output.Put_Line('Query # 25 ');
END;
/

select distinct firstname, lastname
from inventor
where patentnum not in 
(
	select citing
	from citations
	where citing = cited
);


create VIEW viewA
as select p.pat_id,i.firstname,i.lastname,p.gyear,c.compname,cc.catnamelong,cc.subcatname
from patent p, inventor i, company c,categories cc
where p.pat_id=i.patentnum and p.assignee=c.assignee and p.cat=cc.cat and p.subcat=cc.subcat and i.invseq=1;

create view viewB
as select cc.assignee,cc.compname,c.catnamelong,c.subcatname,count(*) as number_of_patents
from company cc, categories c, patent p
where p.assignee=cc.assignee and p.cat=c.cat and p.subcat=c.subcat
group by cc.assignee,cc.compname,c.catnamelong,c.subcatname;

spool off;


