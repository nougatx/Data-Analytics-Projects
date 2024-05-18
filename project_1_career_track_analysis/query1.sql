select *
from
(select
a.student_track_id, a.student_id, a.track_name, a.date_enrolled, a.track_completed, a.days_for_completion, 
case
when days_for_completion = 0 then 'same day'
when days_for_completion between 1 and 7 then '1 to 7 days'
when days_for_completion between 8 and 30 then '8 to 30 days'
when days_for_completion between 31 and 60 then '31 to 60 days'
when days_for_completion between 61 and 90 then '61 to 90 days'
when days_for_completion between 91 and 365 then '91 to 365 days'
when days_for_completion > 365 then '366+days'
end as completion_bucket
from 
(select
row_number() over (order by cts.student_id, cti.track_name) as student_track_id,
cts.student_id, cti.track_name, cts.date_enrolled, cts.date_completed,
if(cts.date_completed is null, "0", "1") as track_completed,
datediff(cts.date_completed, cts.date_enrolled) as days_for_completion
from
career_track_student_enrollments as cts
join
career_track_info cti 
on cts.track_id = cti.track_id ) as a) as b
where b.days_for_completion is not null;

show databases;
