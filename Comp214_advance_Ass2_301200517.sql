-- Assignment 2 --
--Name = Gitansh Mittal --
--Student Id = 301200517 --

--Question 1 --
SET SERVEROUTPUT ON;
DECLARE
    proj_id       dd_project.idproj%TYPE;
    proj_name     dd_project.projname%TYPE;
    num_pledges   NUMBER;
    total_dollars NUMBER;
    avg_pledge    NUMBER;
BEGIN
    proj_id := &proj_id;
    SELECT
        projname
    INTO proj_name
    FROM
        dd_project
    WHERE
        idproj = proj_id;

    SELECT
        COUNT(idpledge)
    INTO num_pledges
    FROM
        dd_pledge
    WHERE
        idproj = proj_id;

    SELECT
        SUM(pledgeamt)
    INTO total_dollars
    FROM
        dd_pledge
    WHERE
        idproj = proj_id;

    avg_pledge := total_dollars / num_pledges;
    dbms_output.put_line('NAME OF THE PROJECT -> '
                         || proj_name ||'PROJECT ID -> '
                         || proj_id
                         || 'NUMBER OF PROJECTS-> '
                         || num_pledges
                         || 'TOTAL AMOUNT OF PLEDGES-> '
                         || total_dollars
                         || 'AVERAGE AMOUNT PER PLEDGE'
                         || avg_pledge);

END;

-- QUESTION 2 --

CREATE SEQUENCE dd_projid_seq START WITH 530 NOCACHE;
    
DECLARE
    R_TYPE dd_project%rowtype;
    PROJ_NAME DD_PROJECT.PROJNAME%TYPE := 'HK ANIMAL SHELTER EXTENSION'; 
    START_P DD_PROJECT.PROJSTARTDATE%TYPE := '1-1-2013';
    END_P DD_PROJECT.PROJENDDATE%TYPE := '31-5-2013';
    FUND_P DD_PROJECT.PROJFUNDGOAL%TYPE := 65000;
    PROJ_ID DD_PROJECT.IDPROJ%TYPE;
BEGIN
    PROJ_ID:= DD_PROJID_SEQ.NEXTVAL;
    R_TYPE.IDPROJ := PROJ_ID;
    R_TYPE.PROJNAME := PROJ_NAME;
    R_TYPE.PROJSTARTDATE := START_P;
    R_TYPE.PROJENDDATE := END_P;
    R_TYPE.PROJFUNDGOAL := FUND_P;
    R_TYPE.PROJCOORD := NULL;
    
    INSERT INTO DD_PROJECT VALUES R_TYPE;
END;


-- QUESTION 3 --
DECLARE
   MONTH_INPUT NUMBER;
   YEAR_INPUT NUMBER;
   DATE_PLEDGE DATE;
   MONTH_PLEDGE NUMBER;
   YEAR_PLEDGE NUMBER;
BEGIN
    MONTH_INPUT := &MONTH_INPUT;
    YEAR_INPUT := &YEAR_INPUT;
    FOR CURSOR_PLEDGE IN (SELECT IDPLEDGE, IDDONOR, PLEDGEAMT, PLEDGEDATE, PAYMONTHS,PAYAMT
                      FROM (SELECT DD_PLEDGE.IDPLEDGE, DD_PLEDGE.IDDONOR, DD_PLEDGE.PLEDGEAMT, DD_PLEDGE.PLEDGEDATE, DD_PLEDGE.PAYMONTHS, DD_PAYMENT.PAYAMT 
                      FROM DD_PLEDGE 
                      INNER JOIN DD_PAYMENT 
                      ON DD_PLEDGE.IDPLEDGE = DD_PAYMENT.IDPLEDGE)
                      WHERE EXTRACT(YEAR FROM PLEDGEDATE) = YEAR_INPUT
                      AND
                      EXTRACT(MONTH FROM PLEDGEDATE) = MONTH_INPUT
                      ORDER BY IDPLEDGE
                     )
    LOOP       
      DATE_PLEDGE := CURSOR_PLEDGE.PLEDGEDATE;
      YEAR_PLEDGE := EXTRACT(YEAR FROM DATE_PLEDGE);
      MONTH_PLEDGE := EXTRACT(MONTH FROM DATE_PLEDGE);
      
      DBMS_OUTPUT.PUT_LINE('Pledge ID -> ' || CURSOR_PLEDGE.IDPLEDGE||
                            'Donor ID -> ' || CURSOR_PLEDGE.IDDONOR ||
                            'Amount -> ' || CURSOR_PLEDGE.PLEDGEAMT);
      IF CURSOR_PLEDGE.PAYAMT >=100 THEN
         DBMS_OUTPUT.PUT_LINE('Payment Type: Lump Sum');
      ELSE
         DBMS_OUTPUT.PUT_LINE('Payment Type: Monthly - ' || CURSOR_PLEDGE.PAYMONTHS || 'Months');
      END IF;
   END LOOP;
END;


-- QUESTION 4 --
DECLARE
    ID_PLEDGE DD_PLEDGE.IDPLEDGE%TYPE;
    ID_DONOR DD_PLEDGE.IDDONOR%TYPE;
    AMT_PLEDGE DD_PLEDGE.PLEDGEAMT%TYPE;
    TOTAL_PAID NUMBER;
    DIFFERENCE_AMT NUMBER;
BEGIN
    ID_PLEDGE := &ID_PLEDGE;
    SELECT IDDONOR,PLEDGEAMT INTO ID_DONOR,AMT_PLEDGE FROM DD_PLEDGE
    WHERE IDPLEDGE = ID_PLEDGE;
    SELECT SUM(PAYAMT) INTO TOTAL_PAID FROM DD_PAYMENT
    WHERE IDPLEDGE = ID_PLEDGE;
    DIFFERENCE_AMT := AMT_PLEDGE - TOTAL_PAID;
    DBMS_OUTPUT.PUT_LINE('PLEDGE ID -> ' || ID_PLEDGE ||
                         'DONOR ID  -> ' || ID_DONOR ||
                         'PLAEDGE AMOUNT->' ||AMT_PLEDGE||
                         'TOTAL PAID -> ' ||TOTAL_PAID||
                         'DIFFERENCE -> ' ||DIFFERENCE_AMT);
END;



-- QUESTION 5 --
DECLARE
    ID_PROJ DD_PROJECT.IDPROJ%TYPE;
    NAME_PROJ DD_PROJECT.PROJNAME%TYPE;
    START_PROJ DD_PROJECT.PROJSTARTDATE%TYPE;
    PREV_AMT DD_PROJECT.PROJFUNDGOAL%TYPE;
    NEW_AMT DD_PROJECT.PROJFUNDGOAL%TYPE;
BEGIN
    ID_PROJ := &ID_PROJ;
    NEW_AMT := &NEW_AMT;
    SELECT PROJNAME, PROJSTARTDATE, PROJFUNDGOAL INTO NAME_PROJ, START_PROJ,PREV_AMT
    FROM DD_PROJECT
    WHERE IDPROJ = ID_PROJ;
    
    UPDATE DD_PROJECT SET PROJFUNDGOAL = NEW_AMT 
    WHERE IDPROJ = ID_PROJ;
    DBMS_OUTPUT.PUT_LINE('PROJECT ID ->'||ID_PROJ||
                         'PROJECT NAME ->'||NAME_PROJ||
                         'START DATE ->'||START_PROJ||
                         'PREVIOUS GOAL ->'||PREV_AMT||
                         'NEW GOAL ->'||NEW_AMT);
END;
    