SELECT * FROM personphone;
SELECT COUNT (DISTINCT businessEntityID ) FROM personphone;

#T_data contains join query for empdepthistory and Dept
  WITH t_data AS (
  SELECT BusinessEntityID, ModifiedDate, MAX(DepartmentName) AS DepartmentName, MAX(PayRate) AS PayRate, MAX(seq) AS seq
   FROM
   (
        SELECT ROW_NUMBER() OVER (PARTITION BY v.BusinessEntityID ORDER BY v.ModifiedDate) AS seq
             , v.BusinessEntityID
             , IF(v.data_type = 'DEPT', val, NULL) AS DepartmentName
             , IF(v.data_type = 'PAY',  val, NULL) AS PayRate
             , v.ModifiedDate   
          FROM ( 
                SELECT 'DEPT' AS data_type, edh.BusinessEntityID, edh.StartDate AS ModifiedDate, d.`Name` AS Val
                  FROM employeedepartmenthistory edh 
                  JOIN department d 
                    ON edh.DepartmentID = d.DepartmentID  
                 UNION ALL
                SELECT 'PAY' AS data_type, eph.BusinessEntityID, eph.RateChangeDate AS ModifiedDate, eph.Rate AS Val
                  FROM employeepayhistory eph
               ) v 
               ) w
   GROUP BY BusinessEntityID, ModifiedDate
       ),
       t_dept_filtered AS (
                SELECT BusinessEntityID, DepartmentName, seq
                  FROM t_data
                 WHERE DepartmentName IS NOT NULL         
       ),
       t_dept_range AS (
        SELECT BusinessEntityID, DepartmentName, seq AS seq_start
             , IFNULL(LEAD(seq) OVER (PARTITION BY BusinessEntityID ORDER BY seq), 999999) AS seq_end
          FROM t_dept_filtered

       )  
       ,
       t_payr_filtered AS (
                SELECT BusinessEntityID, PayRate, seq
                  FROM t_data
                 WHERE PayRate IS NOT NULL        
       ),
       t_payr_range AS (
        SELECT BusinessEntityID, PayRate, seq AS seq_start
             , IFNULL(LEAD(seq) OVER (PARTITION BY BusinessEntityID ORDER BY seq), 999999) AS seq_end
          FROM t_payr_filtered)    
              
SELECT a.BusinessEntityID
     , p.FirstName
     , p.LastName   
     , p.MiddleName
     ,e.NationalIdnumber
     ,b.DepartmentName
     ,c.PayRate
     ,e.jobtitle
     ,e.Hiredate
     ,e.birthdate
     ,e.maritalstatus
     ,e.salariedflag
     ,e.Gender
     ,p.namestyle
     ,a.ModifiedDate
     ,em.emailaddress
     ,ph.phonenumber
     ,e.loginid
     ,e.vacationhours
     ,e.sickleavehours
  FROM t_data a
  JOIN person p
    ON a.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN t_dept_range b
    ON a.BusinessEntityID = b.BusinessEntityID
   AND a.seq >= b.seq_start
   AND a.seq < b.seq_end
  LEFT OUTER JOIN t_payr_range c
    ON a.BusinessEntityID = c.BusinessEntityID
   AND a.seq >= c.seq_start
   AND a.seq < c.seq_end   
   LEFT OUTER JOIN Emailaddress em
   ON em.BusinessEntityID = p.BusinessEntityID
   LEFT OUTER JOIN personphone ph
   ON ph.BusinessEntityID = p.BusinessEntityID
   LEFT OUTER JOIN employee e
   ON e.BusinessEntityID = p.BusinessEntityID
 ORDER BY 2,1;
 

CREATE TABLE `dimemp` (
  `EmployeeKey` BIGINT AUTO_INCREMENT NOT NULL,
  `BusinessEntityid` INT(11) NOT NULL,
  `FirstName` VARCHAR(50) DEFAULT NULL,
  `LastName` VARCHAR(50) DEFAULT NULL,
  `MiddleName` VARCHAR(50) DEFAULT NULL,
  `NameStyle` TINYINT(1) DEFAULT NULL,
  `Title` VARCHAR(50) DEFAULT NULL,
  `HireDate` DATE DEFAULT NULL,
  `BirthDate` DATE DEFAULT NULL,
  `LoginID` VARCHAR(256) DEFAULT NULL,
  `EmailAddress` VARCHAR(50) DEFAULT NULL,
  `Phone` VARCHAR(25) DEFAULT NULL,
  `MaritalStatus` CHAR(1) DEFAULT NULL,
  `SalariedFlag` TINYINT(1) DEFAULT NULL,
  `Gender` CHAR(1) DEFAULT NULL,
  `VacationHours` SMALLINT(6) DEFAULT NULL,
  `SickLeaveHours` SMALLINT(6) DEFAULT NULL,
  `DepartmentName` VARCHAR(50) DEFAULT NULL,
 `version` VARCHAR(50) DEFAULT NULL,
  `modifiedDate` DATE DEFAULT NULL,
  PRIMARY KEY (`EmployeeKey`)
) ;

TRUNCATE TABLE dimemp;

ALTER TABLE dimemp 


SELECT * FROM dimemp;