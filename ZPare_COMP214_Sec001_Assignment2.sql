/* Question 1 -> 3-9 */

set serveroutput on
DECLARE

project_name dd_project.projname%type;
project_id dd_project.idproj%type := 500;
pledge_count dd_pledge.pledgeamt%type;
pledge_average dd_pledge.pledgeamt%type;
pledge_sum dd_pledge.pledgeamt%type;

BEGIN

SELECT dd_project.idproj, dd_project.projname, count(pledgeamt), sum(pledgeamt), avg(pledgeamt)
into project_id, project_name, pledge_count, pledge_sum, pledge_average
from dd_pledge, dd_project
where dd_pledge.idproj = dd_project.idproj
and dd_project.idproj = project_id
group by dd_project.idproj, projname;

DBMS_OUTPUT.PUT_LINE(' ID: ' || project_id ||' -- Name: ' || project_name ||' -- Number of Pledges Made: ' || pledge_count ||' -- Total Dollars Pledged: ' || pledge_sum||
' -- Average Pledged Amount: ' ||  pledge_average );
end;

/* Question 2 -> 3-10 */

CREATE SEQUENCE dd_project_seq
MINVALUE 1
START WITH 530
INCREMENT BY 1
NOCACHE;
  
DECLARE

project_new type_project;

TYPE type_project IS RECORD(
project_name dd_project.projname%type := 'HK Animal Shelter Extension',
project_start dd_project.projstartdate%type := '01-JAN-13',
project_end dd_project.projenddate%type := '31-MAY-13',
project_funding dd_project.projfundgoal%type := '65000');

Begin

INSERT INTO dd_project (idproj, projname, projstartdate, projenddate, projfundgoal)
VALUES 	(dd_project_seq.NEXTVAL, project_new.project_name, project_new.project_start, project_new.project_end, project_new.project_funding);
commit; 
end;

/* Question 3 -> 3-11*/

DECLARE
pledges dd_pledge%ROWTYPE;
start_month dd_pledge.pledgedate%type := '01-MAR-13';
end_month dd_pledge.pledgedate%type := '30-MAR-13';
  
BEGIN
  FOR pledges IN 
    (SELECT idpledge, iddonor, pledgeamt, 
	  CASE
      WHEN paymonths = 0 THEN 'Lump Sum'
      ELSE 'Monthly - ' || paymonths
      END AS monthly_payment
      FROM dd_pledge
      WHERE pledgedate >= start_month AND pledgedate <= end_month
      ORDER BY paymonths)
      LOOP
      DBMS_OUTPUT.PUT_LINE('ID: ' || pledges.idpledge || ' -- Donor ID: '
        || pledges.iddonor || ' -- Pledge Amount: ' ||to_char(pledges.pledgeamt,
        '$9999.99') || ' -- Monthly Payment: ' || pledges.monthly_payment);
      END LOOP;
      end;
/* Question 4 -> 3-12*/

DECLARE
  pledges dd_pledge%ROWTYPE;
  total_topay dd_pledge.pledgeamt%type;
  balance dd_pledge.pledgeamt%type;
  paid_months number(5);

BEGIN
  SELECT *
  INTO pledges
  FROM dd_pledge
  WHERE idpledge = 111;
  
  paid_months := pledges.paymonths;

  IF pledges.paymonths = 0 THEN 
  total_topay := pledges.pledgeamt;  
  ELSE total_topay := paid_months * (pledges.pledgeamt/pledges.paymonths);
  END IF;
  balance := pledges.pledgeamt - total_topay;
  
  DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || pledges.idpledge || ' -- Donor ID: ' || pledges.iddonor ||
' -- Amount paid: ' || total_topay || ' ' || ' -- Balance: ' || balance);

end;
/* Question 5 -> 3-13*/

DECLARE
  project_name dd_project.projname%type;
  start_date dd_project.projstartdate%type;
  fundraising_goal dd_project.projfundgoal%type;
  project_id dd_project.idproj%type := '503';
  new_goal dd_project.projfundgoal%type := '250000';
    
BEGIN
  SELECT projname, projstartdate, projfundgoal
  INTO project_name, start_date, fundraising_goal
  FROM dd_project
  WHERE idproj = project_id;
  
  UPDATE dd_project
  SET projfundgoal = new_goal;
  
  DBMS_OUTPUT.PUT_LINE('Project Name: ' || project_name ||' -- Start Date: ' ||
  start_date || ' -- Old Goal: ' || fundraising_goal || ' -- New Goal: ' ||
  new_goal);
end;


