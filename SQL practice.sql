
select s.*, c.CId, c.Score from student as s
left join sc as c on s.sid=c.sid
where s.sid in (select a.sid from 
(select * from sc where cid='01') as a 
inner join 
(select * from sc where cid='02') as b
on a.sid=b.sid where a.score>b.score group by a.sid) and c.cid<>'03';

select s.*, c1_score.cid, c1_score.c1, c2_score.cid, c2_score.c2 from student as s
inner join 
(select s.sid, s.cid, s.score as c1 from sc as s where s.cid='01') as c1_score 
on s.sid=c1_score.sid
inner join (select s.sid, s.cid, s.score as c2 from sc as s where s.cid='02') as c2_score
on s.sid=c2_score.sid
where c1_score.c1>c2_score.c2;

select s.*,c1.cid, c1.score, c2.cid, c2.score from student as s
inner join (select * from sc where sc.cid='02') as c2
on s.sid=c2.sid
left join (select * from sc where sc.cid='01') as c1
on s.sid=c1.sid
where c1.cid is null;


select s.sid, s.sname, a.avgs from 
(select avg(score) as avgs, sid from sc
group by sid
having avg(score)>=60) as a
left join student as s on a.sid=s.sid;


select distinct s.* from student as s
inner join sc on s.sid=sc.sid;

select s.sid, s.sname, a.course, a.total
from student as s
left join (select sum(score) as total, sid, count(distinct cid) as course
from sc
group by sid) as a on s.sid=a.sid


select distinct s.* from student as s
left join sc on s.sid=sc.sid
where sc.score is not null;

select count(tname) from teacher
where tname like 'M%';

select s.* from student as s
inner join sc on s.sid=sc.sid
inner join course as c on c.cid=sc.cid
inner join teacher as t on c.tid=t.tid
where t.tname like 'Minday';

select distinct s.* from student as s
inner join sc on s.sid=sc.sid
where sc.cid in (select sc.cid from sc where sc.sid='01') and s.sid <> '01';


select s.sname from student as s
where s.sid not in 
(select sc.sid from sc
left join course as c on sc.cid=c.cid
left join teacher as t on c.tid=t.tid
where t.tname = 'Minday')

--11 **

select t1.sid, s.sname, t1.avgscore from (select t.sid, avg(t.score) as avgscore from (select sid, score from sc where score<60)t group by t.sid)t1
join student as s on s.sid=t1.sid


--12 *
select s.* from student as s
join sc on s.sid=sc.sid
where sc.cid='01' and sc.score< 60
order by sc.score desc;


--13 **?
select sc.*, t.avgscore from (select sc.sid, avg(sc.score) as avgscore from sc group by sc.sid)t
join sc on sc.sid=t.sid
order by avgscore desc;

--how to add an column in a pivot table?

select * from sc
pivot (max(score) for cid in ([01],[02],[03])) as piv





--14 ***** other way to count pass rate? cname can't be group by?

select t.cid, max(course.cname) as cname, max(t.score) as max, Min(t.score) as min, avg(t.score) as avg,  sum(pass)*100/count(sid) as pass_rate, sum(normal)*100/count(sid) as normal_rate, sum(good)*100/count(sid) as good_rate, sum(greate)*100/count(sid) greate_rate
from (
	select *,
	case when sc.score>=60 then 1 else 0 end as 'pass',
	case when sc.score>=70 and sc.score<80 then 1 else 0 end as 'normal',
	case when sc.score>=80 and sc.score<90 then 1 else 0 end as 'good',
	case when sc.score>=90 then 1 else 0 end as 'greate'
	from sc)t
join course on t.cid=course.cid
group by t.cid

---15 **

select sid, cid, score, rank() over(partition by cid order by score desc) as rank from sc
order by cid asc, score desc

---15.1 *

select sid, cid, score, dense_rank() over(partition by cid order by score desc) as rank from sc
order by cid asc, score desc


---16 **

select a.sid, a.total, rank() over(order by a.total desc)rank from (select sid, sum(score)total from sc group by sid)a

---16 *

select a.sid, a.total, dense_rank() over(order by a.total desc)rank from (select sid, sum(score)total from sc group by sid)a

---17 ** how to avg from different column
/*
select distinct sc.sid, a.cid01, b.cid02, c.cid03, avg(a.cid01+b.cid02+c.cid03) from sc
join (select sc.sid, sc.score as cid01 from sc where sc.cid=01)a on sc.sid=a.sid
join (select sc.sid, sc.score as cid02 from sc where sc.cid=02)b on sc.sid=b.sid
join (select sc.sid, sc.score as cid03 from sc where sc.cid=03)c on sc.sid=c.sid
group by sc.sid 
*/

select
sid, 
max(case when cid=01 then score else null end) as cid01,
max(case when cid=02 then score else null end) as cid02,
max(case when cid=03 then score else null end) as cid03,
avg(score)
from sc
group by sid


---17** can group by 2 col
select sc.CId, cname,
sum(case when score<100 and score>=85 then 1 else 0 end) as '100-85',
sum(case when score<100 and score>=85 then 1 else 0 end)/count(sid) as '100-85%',
sum(case when score<85 and score>=70 then 1 else 0 end) as '85-70',
sum(case when score<85 and score>=70 then 1 else 0 end)/count(sid) as '85-70%',
sum(case when score<70 and score>=60 then 1 else 0 end) as '70-60',
sum(case when score<70 and score>=60 then 1 else 0 end)/count(sid) as '70-60%',
sum(case when score<60 and score>=0 then 1 else 0 end) as '60-0',
sum(case when score<60 and score>=0 then 1 else 0 end)/count(sid) as '60-0%'
from sc
join Course on sc.cid=course.cid
group by sc.cid, cname


---18*

select * from 
(select sc.cid, row_number() over (partition by cid order by sc.score) as rank, sc.sid, s.sname, s.sage, s.ssex from student as s
join sc on sc.sid=s.sid)top3
where top3.rank<=3

---19*
select sc.cid, count(sid) from sc
group by cid

---20*
select sc.sid, count(cid) from sc
group by sid
having count(cid)<=2

---21*
select ssex, count(ssex) from student
group by ssex


---22*
select * from student
where sname like '%a%'

---24*
select * from student
where sage>='1990-01-01' and sage<='1990-12-31'

---25*
select cid, avg(score) from sc
group by cid
order by avg(score) desc, cid

---26*
select sc.sid, student.sname, avg(score) as avg_score from sc
join student on sc.sid=student.sid
group by sc.sid, student.sname
having avg(sc.score)>=85

---27*
select sname, cid, score from sc
join student on sc.sid=student.sid
where cid=02 and score<60

---28** how to do show null? left join?
select sname, cid, score from student
left join sc on sc.sid=student.sid

---29** how to show only 1 name
select sname, cname, score, row_number() over (partition by s.sname order by score) from sc
join student as s on sc.sid=s.sid
join course as c on sc.cid=c.cid
where sc.score>=70 


---30
select distinct cname from course
join sc on course.cid=sc.cid
where score<60


---31
select s.sid, s.sname from student s
join sc on sc.sid=s.sid
where cid=01 and score>=80


---32
select count(sid) from sc
group by cid

---33 ** why should select from ()? how to add column when select *?
 
select * from 
(
select s.sid, s.sname, s.sage, s.ssex, rank() over(partition by sc.cid order by score)r from student as s
join sc on sc.sid=s.sid
join course as c on sc.cid=c.cid
join teacher as t on c.tid=t.tid
where t.tname='Minday')top1
where top1.r=1


---34
select * from 
(
select s.sid, s.sname, s.sage, s.ssex, row_number() over(partition by sc.cid order by score)r from student as s
join sc on sc.sid=s.sid
join course as c on sc.cid=c.cid
join teacher as t on c.tid=t.tid
where t.tname='Minday')top1
where top1.r=1


---35**
select distinct a.cid, a.sid, a.score from sc a 
join sc b on a.sid=b.sid
where a.score=b.score and a.cid<>b.cid


---36
select * from (select sid, cid, score, row_number() over(partition by cid order by score desc)rank from sc)top2
where top2.rank<=2


---37
select cid, count(sid) from sc
group by cid

---38
select sid, count(cid) from sc
group by sc.sid
having count(cid)>=2