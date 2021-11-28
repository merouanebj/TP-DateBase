

CREATE USER userTP03 IDENTIFIED BY BJ;
GRANT ALL PRIVILEGES TO userTP03;
/* ================================================================*/

CREATE TABLE Service (
 CodeS VARCHAR2(3) NOT NULL CHECK (CodeS LIKE 'S%') ,
 NomS VARCHAR2(20) ,
 Chef_S INTEGER ,
 CONSTRAINT PK_Service PRIMARY KEY (CodeS)
);

INSERT  INTO  Service  VALUES  ('S01',  'informatique'  ,13);  
INSERT  INTO  Service  VALUES  ('S02',  'panification'  ,14)  ;  
INSERT  INTO  Service  VALUES  ('S03',  'comptabilite'  ,3)  ; 
 INSERT  INTO  Service  VALUES  ('S04',  'construction',5); 
 INSERT  INTO  Service  VALUES  ('S05',  'technique'  ,8)  ; 
 INSERT  INTO  Service  VALUES  ('S06',  'statistique',  11); 
 
/

ALTER TABLE Service ADD NbOp INTEGER DEFAULT 0;
--NOMBRE D'OPERATION REALISE PAR UNE SERVICE
ALTER TABLE Service ADD NbEmp INTEGER DEFAULT 0;
--
--Verification
CREATE TABLE Operation (
    CodeOP VARCHAR2(5) CHECK (CodeOP LIKE 'OP%') NOT NULL ,
    Duree NUMBER(2),
    Chef INTEGER,
    DateDeb DATE,
    Budget NUMBER(8,2),
    CodeS VARCHAR2(3) NOT NULL,
    CONSTRAINT PK_Operation PRIMARY KEY (CodeOP)
);

CREATE TABLE Employe(        
    NumE INTEGER NOT NULL,    
    NomE VARCHAR2(20)    ,  
    Fonction VARCHAR2(60),
    CodeS VARCHAR2(3) CHECK (CodeS LIKE 'S%') NOT NULL    ,   
    CONSTRAINT PK_Employe PRIMARY KEY (NumE)  
    ); 
/* ================================================================*/

CREATE OR REPLACE TRIGGER Increm_NbOP 
AFTER INSERT ON OPERATION FOR EACH ROW
DECLARE 
    C OPERATION.CODES%TYPE;
BEGIN
    SELECT  CODES INTO  C
    FROM SERVICE
 WHERE CODES= :NEW.CODES;
    --Rucupere le tuple
 UPDATE SERVICE SET NbOP=NbOP+1 WHERE CODES=CC;
END;

CREATE OR REPLACE TRIGGER Increm_NbOP 
AFTER INSERT ON OPERATION FOR EACH ROW
BEGIN
 UPDATE SERVICE SET NbOP=NbOP+1 WHERE service.CODES= :new.codes;
END;
/

CREATE OR REPLACE TRIGGER Increm_NbOP 
AFTER DELETE ON OPERATION FOR EACH ROW
BEGIN
 UPDATE SERVICE SET NbOP=NbOP-1 WHERE service.CODES= :old.codes;
END;
/
SHOW ERRORS;--

CREATE OR REPLACE TRIGGER Dec_NbOP 
AFTER DELETE ON OPERATION FOR EACH ROW
DECLARE 
    C OPERATION.CODES%TYPE;
BEGIN
    SELECT  CODES INTO  C
    FROM SERVICE
 WHERE CODES= :OLD.CODES;
    --Rucupere le tuple
 UPDATE SERVICE SET NbOP=NbOP-1 WHERE CODES=CC;
END;
/
/* ================================================================*/
INSERT INTO Operation(CodeOP,duree,chef,DateDeb,Budget,codes) VALUES ('OP001',48,13,'01/10/2018',180000.00,'S01'); 
INSERT INTO Operation VALUES ('OP002',48,5,'10/09/2016',100000.00,'S04'); 
INSERT INTO Operation (CodeOP,duree,chef,DateDeb,Budget,codes)VALUES ('OP003',36,14,'05/01/2018',200000.00,'S02');
INSERT INTO Operation VALUES ('OP004',30,13,'10/09/2017',270000.00,'S01');
INSERT INTO Operation(CodeOP,duree,chef,DateDeb,Budget,codes) VALUES ('OP004',30,13,'10/09/2017',270000.00,'S01'); 
INSERT INTO Operation (CodeOP,duree,chef,DateDeb,Budget,codes)VALUES ('OP005',30,8,'01/03/2018',100000.00,'S05'); 
INSERT INTO Operation(CodeOP,duree,chef,DateDeb,Budget,codes) VALUES ('OP006',36,5,'10/09/2019',300000.00,'S04'); 
INSERT INTO Operation(CodeOP,duree,chef,DateDeb,Budget,codes) VALUES ('OP007',36,13,'10/05/2018',200000.00,'S01'); 
INSERT INTO Operation(CodeOP,duree,chef,DateDeb,Budget,codes) VALUES ('OP008',36,4,'10/01/2020',100000.00,'S05'); 
INSERT INTO Operation(CodeOP,duree,chef,DateDeb,Budget,codes) VALUES ('OP009',30,13,'10/09/2020', 150000.00,'S01'); 

SELECT * FROM SERVICE;

/* ================================================================*/

DELETE FROM OPERATION WHERE CodeOP='OP009';
SELECT * FROM SERVICE;

/*  6 ================================================================*/

CREATE OR REPLACE MAJ_NbEmp 
AFTER INSERT OR DELETE ON Employe FOR EACH ROW
BEGIN
IF INSERTING 
   THEN 
       --rucuperation de codeS de nouveux tuple insrer
       UPDATE SERVICE SET NbO=NbO+1 WHERE service.CODES= :new.codes;
END IF;   

IF DELETING 
   THEN 
       --rucuperation de codeS du tuple Supprimer
       UPDATE SERVICE SET NbO=NbO-1 WHERE CODES= :OLD.CODES;
END IF; 
END;
/

/* 7  ================================================================*/
INSERT INTO  Employe VALUES(1,'belkadi','ingenieur detat en informatique','S01');
INSERT INTO  Employe VALUES (2,'benslimane','technicien','S04'); 
INSERT INTO  Employe VALUES (3,'zerguine','chef comptable','S03');
INSERT INTO  Employe VALUES (4,'naili','ingenieur p.c.' , 'S05'); 
INSERT INTO  Employe VALUES (5,'touhari','architecte','S04'); 
INSERT INTO  Employe VALUES (6,'mehdjoubi','comptable','S03'); 
INSERT INTO  Employe VALUES(7,'messaoude','ingenieur d application en informatique ','S01');
INSERT INTO  Employe VALUES (8,'ghrissi','ingenieur g.c.','S05' ); 
INSERT INTO  Employe VALUES (9,'otmani','comptable','S06' ); 
INSERT INTO  Employe VALUES (10,'benyahia','technicien','S05' ); 
INSERT INTO  Employe VALUES (11,'kaidi','master en statistiques','S06' );
INSERT INTO  Employe VALUES (12,'sissaoui','agent adminstratif','S02' ); 
INSERT INTO  Employe VALUES(13,'benaissa','ingenieur d etat en informatique','S01' ); 
INSERT INTO  Employe VALUES (14,'achour','adminstrateur principal','S02' ); 

SELECT * FROM SERVICE;

/* 8  ================================================================*/

DELETE FROM Employe WHERE NumE=14;
SELECT * FROM SERVICE;

/* 9  ================================================================*/

ALTER TABLE OPERATION ADD NbM INTEGER DEFAULT 0;

CREATE TABLE Membre(
    NumE   INTEGER  NOT NULL,      
    CodeOP VARCHAR2(5)  NOT NULL CHECK (CodeOP LIKE 'OP%') ,      
    CONSTRAINT PK_Membre PRIMARY KEY (NumE,CodeOP)        
); 

/* 10  ================================================================*/

CREATE OR REPLACE TRIGGER MAJ_NbM 
AFTER INSERT OR DELETE ON MEMBRE FOR EACH ROW
BEGIN
IF INSERTING 
   THEN 
       --rucuperation de codeOP de nouveux tuple insrer
       UPDATE OPERATION SET NbM=NbM+1 WHERE OPERATION.CODEOP= :NEW.CODEOP;
END IF;   

IF DELETING 
   THEN 
       --rucuperation de codeOP du tuple Supprimer
       UPDATE OPERATION SET NbM=NbM-1 WHERE OPERATION.CODEOP= :OLD.CODEOP;
END IF; 
END;
/

SELECT * FROM OPERATION;
/* 11  ================================================================*/

--INSERTION DES TUPLE DE LA TABLE MEMBRE
INSERT INTO Membre VALUES(13,'OP001');
INSERT INTO Membre VALUES(7,'OP001'); 
INSERT INTO Membre VALUES(1,'OP001');
INSERT INTO Membre VALUES(5,'OP002'); 
INSERT INTO Membre VALUES(2,'OP002');


SELECT * FROM OPERATION;

/* 12 ================================================================*/

DELETE FROM MEMBRE WHERE CODEOP='OP002' AND NUME=5 ;

SELECT * FROM OPERATION WHERE CODEOP='OP002';

/* 13 ================================================================*/
--a
ALTER TABLE EMPLOYE ADD nbchef INTEGER DEFAULT 0;

--b
UPDATE EMPLOYE SET nbchef = (SELECT COUNT(*)
                             FROM OPERATION             
                             WHERE NUME=CHEF);                           
--c
SELECT * FROM EMPLOYE;

/* 14 ================================================================*/
--a
--UPDATE 
--Create a new Table Trigger

CREATE OR REPLACE TRIGGER MAJ_Nbchef
AFTER INSERT OR UPDATE OR DELETE ON OPERATION 
FOR EACH ROW
BEGIN
IF INSERTING THEN
                 UPDATE Employe SET Nbchef=Nbchef+1 WHERE Employe.NumE= :NEW.Chef;
    ELSIF UPDATEING THEN 
                 UPDATE Employe SET Nbchef=Nbchef+1 WHERE Employe.NumE= :NEW.Chef;
                 UPDATE Employe SET Nbchef=Nbchef-1 WHERE Employe.NumE= :OLD.Chef;
    ELSIF (DELETEING) THEN 
                 UPDATE Employe SET Nbchef=Nbchef-1 WHERE Employe.NumE= :OLD.Chef; 
 END IF;
END  MAJ_Nbchef;
/

CREATE  OR REPLACE TRIGGER MAJ_Nbchef
AFTER INSERT OR DELETE OR UPDATE ON Operation
FOR EACH ROW
BEGIN
IF INSERTING then UPDATE Employe  SET Nbchef=Nbchef+1 WHERE Employe.NumE= :NEW.Chef;
 END IF;
IF DELETING Then UPDATE Employe  SET Nbchef=Nbchef-1 WHERE Employe.NumE= :OLD.Chef;
 END IF ;
if UPDATING Then UPDATE Employe SET Nbchef=Nbchef+1 WHERE Employe.NumE= :NEW.Chef;
                 UPDATE Employe SET Nbchef=Nbchef-1 WHERE Employe.NumE= :OLD.Chef;
 END IF;
END ;

--c
UPDATE OPERATION SET CHEF=3 WHERE CODEOP='OP003'; 
UPDATE OPERATION SET CHEF=8 WHERE CODEOP='OP005'; 
UPDATE OPERATION SET CHEF=2 WHERE CODEOP='OP006'; 
UPDATE OPERATION SET CHEF=4 WHERE CODEOP='OP004'; 

INSERT INTO Operation(CodeOP,duree,chef,DateDeb,Budget,codes) VALUES ('OP010',36,3,'04/01/2021',200000.00,'S03'); 


--d 
SELECT * FROM EMPLOYE;
