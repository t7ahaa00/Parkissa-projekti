USE parkissa;
SET SQL_SAFE_UPDATES = 0;
#***********************PARKKIPAIKKOJEN HALLINTA**************************

#-----------------------PARKKIPAIKAN LISÄÄMINEN--------------------------

INSERT INTO parkinglot VALUES(null,65.060778,25.461132,'OAMK parkkipaikka',40);

#-----------------------PARKKIPAIKAN PAIKKOJEN LUOMINEN------------------

#createParkingGrid(parkipaikan_nimi,rivien_lukumäärä,paikkojen_määrä_rivissä);
#HUOM! päivittää myös parkkipaikkojen lukumäärän vastaamaan annettua rivit*paikat rivissä määrää

CALL createParkingGrid('OAMK parkkipaikka',9,10);

#-----------------------PARKKIPAIKAN LOGIN PÄIVITTÄMINEN------------------
 
#CALL createLog(Parkkipaikan nimi);

CALL createLog('OAMK parkkipaikka');

#-----------------------VAPAIDEN PARKKIPAIKKOJEN LASKEMINEN--------------

SELECT COUNT(*) FROM grid 
	WHERE idparkinglot = (SELECT idparkinglot FROM parkinglot WHERE name = 'OAMK parkkipaikka') 
    AND occupied = false;

#-----------------------PARKKIPAIKAN TILAN MUUTTAMINEN-------------------

UPDATE grid SET grid.occupied = NOT grid.occupied 
	WHERE idparkinglot in (SELECT idparkinglot FROM parkinglot WHERE name = 'OAMK parkkipaikka')
	AND slotName='A4';

#***********************KÄYTTÄJÄHALLINTA*********************************

#-----------------------ADMIN LISÄÄMINEN---------------------------------
INSERT INTO user VALUES(null,'admin.admin@parkissa.fi');
INSERT INTO admin VALUES (LAST_INSERT_ID(), null, 'admin', 'salainenSalasana');

#-----------------------ADMIN LISÄÄMINEN PARKKIPAIKALLE------------------
INSERT INTO parkinglot_has_user VALUES(
(SELECT idparkinglot FROM parkinglot WHERE name = 'OAMK parkkipaikka'),
(SELECT iduser FROM user WHERE email = 'admin.admin@parkissa.fi'));

#-----------------------HALTIJAN LISÄÄMINEN------------------------------
INSERT INTO user VALUES(null,'ylläpitäjä.ylläpitäjä@firma.net');
INSERT INTO staff VALUES (LAST_INSERT_ID(), null, 'ylläpitäjä', 'password');

#-----------------------HALTIJAN LISÄÄMINEN PARKKIPAIKALLE---------------
INSERT INTO parkinglot_has_user VALUES(
(SELECT idparkinglot FROM parkinglot WHERE name = 'OAMK parkkipaikka'),
(SELECT iduser FROM user WHERE email = 'ylläpitäjä.ylläpitäjä@firma.net'));

#-----------------------KÄYTTÄJÄN LISÄÄMINEN-----------------------------
INSERT INTO user VALUES(null,'matti.meikäläinen@gmail.com');
INSERT INTO visitor VALUES (LAST_INSERT_ID(), null, '044-123456', 'matti','meikäläinen');

#-----------------------KÄYTTÄJÄN LISÄÄMINEN PARKKIPAIKALLE--------------
INSERT INTO parkinglot_has_user VALUES(
(SELECT idparkinglot FROM parkinglot WHERE name = 'OAMK parkkipaikka'),
(SELECT iduser FROM user WHERE email = 'matti.meikäläinen@gmail.com'));

