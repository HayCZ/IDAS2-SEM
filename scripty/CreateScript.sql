-- Generated by Oracle SQL Developer Data Modeler 19.1.0.081.091--   at:        2019-05-16 02:29:04 CEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g

/*=============StrukturaDB============*/
CREATE TABLE hodnoceni
(
    id_hodnoceni      INTEGER NOT NULL,
    hodnota_hodnoceni INTEGER NOT NULL,
    popis             VARCHAR2(100),
    id_uzivatel       INTEGER NOT NULL,
    id_skupina        INTEGER NOT NULL
);

ALTER TABLE hodnoceni
    ADD CONSTRAINT hodnocen�_pk PRIMARY KEY (id_hodnoceni);

CREATE TABLE obor_predmet
(
    studijni_obor_id_obor INTEGER NOT NULL,
    predmet_id_predmet    INTEGER NOT NULL
);

ALTER TABLE obor_predmet
    ADD CONSTRAINT obor_predmet_pk PRIMARY KEY (studijni_obor_id_obor,
                                                predmet_id_predmet);

CREATE TABLE predmety
(
    id_predmet INTEGER      NOT NULL,
    nazev      VARCHAR2(50) NOT NULL,
    popis      VARCHAR2(250)
);

ALTER TABLE predmety
    ADD CONSTRAINT predmet_pk PRIMARY KEY (id_predmet);

CREATE TABLE skupiny
(
    id_skupina INTEGER      NOT NULL,
    nazev      VARCHAR2(50) NOT NULL,
    popis      VARCHAR2(250),
    id_predmet INTEGER      NOT NULL
);

ALTER TABLE skupiny
    ADD CONSTRAINT skupina_pk PRIMARY KEY (id_skupina);

CREATE TABLE studenti
(
    id_uzivatel INTEGER      NOT NULL,
    rok_studia  VARCHAR2(50) NOT NULL,
    id_obor     INTEGER      NOT NULL
);

ALTER TABLE studenti
    ADD CONSTRAINT student_pk PRIMARY KEY (id_uzivatel);

CREATE TABLE studijni_obory
(
    id_obor INTEGER      NOT NULL,
    nazev   VARCHAR2(50) NOT NULL,
    popis   VARCHAR2(250)
);

ALTER TABLE studijni_obory
    ADD CONSTRAINT studijni_obor_pk PRIMARY KEY (id_obor);

CREATE TABLE ucitele
(
    id_uzivatel INTEGER      NOT NULL,
    katedra     VARCHAR2(50) NOT NULL,
    id_predmet  INTEGER      NOT NULL
);

ALTER TABLE ucitele
    ADD CONSTRAINT ucitel_pk PRIMARY KEY (id_uzivatel);

CREATE TABLE uzivatel_skupina
(
    uzivatel_id_uzivatel INTEGER NOT NULL,
    skupina_id_skupina   INTEGER NOT NULL
);

ALTER TABLE uzivatel_skupina
    ADD CONSTRAINT uzivatel_skupina_pk PRIMARY KEY (uzivatel_id_uzivatel,
                                                    skupina_id_skupina);

CREATE TABLE uzivatele
(
    id_uzivatel     INTEGER      NOT NULL,
    jmeno           VARCHAR2(50) NOT NULL,
    prijmeni        VARCHAR2(50) NOT NULL,
    email           VARCHAR2(50) NOT NULL,
    heslo           VARCHAR2(50) NOT NULL,
    datum_vytvoreni DATE         NOT NULL,
    uzivatel_typ    VARCHAR2(50) NOT NULL
);

ALTER TABLE uzivatele
    ADD CONSTRAINT uzivatel_pk PRIMARY KEY (id_uzivatel);

CREATE TABLE zpravy
(
    id_zprava              INTEGER       NOT NULL,
    nazev                  VARCHAR2(50)  NOT NULL,
    telo                   VARCHAR2(250) NOT NULL,
    datum_vytvoreni        DATE          NOT NULL,
    id_uzivatel_odesilatel INTEGER       NOT NULL,
    id_uzivatel_prijemce   INTEGER,
    id_skupina_prijemce    INTEGER
);

ALTER TABLE zpravy
    ADD CONSTRAINT zprava_pk PRIMARY KEY (id_zprava);

ALTER TABLE hodnoceni
    ADD CONSTRAINT hodnoceni_skupina FOREIGN KEY (id_skupina)
        REFERENCES skupiny (id_skupina);

ALTER TABLE obor_predmet
    ADD CONSTRAINT obor_predmet_predmet_fk FOREIGN KEY (predmet_id_predmet)
        REFERENCES predmety (id_predmet);

ALTER TABLE obor_predmet
    ADD CONSTRAINT obor_predmet_studijni_obor_fk FOREIGN KEY (studijni_obor_id_obor)
        REFERENCES studijni_obory (id_obor);

ALTER TABLE zpravy
    ADD CONSTRAINT odesilatel_zprava FOREIGN KEY (id_uzivatel_odesilatel)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE skupiny
    ADD CONSTRAINT predmet_skupina FOREIGN KEY (id_predmet)
        REFERENCES predmety (id_predmet);

ALTER TABLE zpravy
    ADD CONSTRAINT prijemce_skupina FOREIGN KEY (id_skupina_prijemce)
        REFERENCES skupiny (id_skupina);

ALTER TABLE zpravy
    ADD CONSTRAINT prijemce_zprava FOREIGN KEY (id_uzivatel_prijemce)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE studenti
    ADD CONSTRAINT student_obor FOREIGN KEY (id_obor)
        REFERENCES studijni_obory (id_obor);

ALTER TABLE ucitele
    ADD CONSTRAINT ucitel_predmet FOREIGN KEY (id_predmet)
        REFERENCES predmety (id_predmet);

ALTER TABLE hodnoceni
    ADD CONSTRAINT uzivatel_hodnoceni FOREIGN KEY (id_uzivatel)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE uzivatel_skupina
    ADD CONSTRAINT uzivatel_skupina_skupina_fk FOREIGN KEY (skupina_id_skupina)
        REFERENCES skupiny (id_skupina);

ALTER TABLE uzivatel_skupina
    ADD CONSTRAINT uzivatel_skupina_uzivatel_fk FOREIGN KEY (uzivatel_id_uzivatel)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE studenti
    ADD CONSTRAINT uzivatel_student FOREIGN KEY (id_uzivatel)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE ucitele
    ADD CONSTRAINT uzivatel_ucitel FOREIGN KEY (id_uzivatel)
        REFERENCES uzivatele (id_uzivatel);
/*=============StrukturaDB============*/
/*=============Sekvence============*/
CREATE SEQUENCE increment_hodnoceni
    START WITH 1;

CREATE SEQUENCE increment_uzivatele
    START WITH 1;

CREATE SEQUENCE increment_predmety
    START WITH 1;

CREATE SEQUENCE increment_skupiny
    START WITH 1;

CREATE SEQUENCE increment_obory
    START WITH 1;

CREATE SEQUENCE increment_zpravy
    START WITH 1;
/*=============Sekvence============*/
/*==================Procedury===============*/

/*Neov��en� procedury*/

/*----Insert procedury----*/
CREATE OR REPLACE PROCEDURE insert_hodnoceni(hodnoceni_in INTEGER, popis_in in VARCHAR2, id_uzivatel_in INTEGER,
                                             id_skupina_in INTEGER)
    IS
BEGIN
    INSERT INTO HODNOCENI(hodnota_hodnoceni, popis, id_uzivatel, id_skupina)
    VALUES (hodnoceni_in, popis_in, id_uzivatel_in, id_skupina_in);
END;
/
CREATE OR REPLACE PROCEDURE insert_zprava(nazev_in in VARCHAR2, telo_in in VARCHAR2, datum_vytvoreni_in in DATE,
                                          id_odesilatel_in INTEGER, id_prijemce_in INTEGER, id_skupina_in INTEGER)
    IS
BEGIN
    INSERT INTO ZPRAVY(nazev, telo, datum_vytvoreni, id_uzivatel_odesilatel, id_uzivatel_prijemce,
                       id_skupina_prijemce)
    VALUES (nazev_in, telo_in, datum_vytvoreni_in, id_odesilatel_in, id_prijemce_in, id_skupina_in);
END;
/
/*DELETE procedure incomplete*/
CREATE OR REPLACE PROCEDURE insert_predmet(nazev_in in VARCHAR2, popis_in in VARCHAR2)
    IS
BEGIN
    INSERT INTO PREDMETY(nazev, popis)
    VALUES (nazev_in, popis_in);
END;
/
CREATE OR REPLACE PROCEDURE insert_studijni_obor(nazev_in in VARCHAR2, popis_in in VARCHAR2)
    IS
BEGIN
    INSERT INTO STUDIJNI_OBORY(nazev, popis)
    VALUES (nazev_in, popis_in);
END;
/
/*
Vazebn� tabulka p�edm�t x studijn� obor
*/
CREATE OR REPLACE PROCEDURE insert_obor_predmet(id_obor_in INTEGER, id_predmet_in INTEGER)
    IS
BEGIN
    INSERT INTO OBOR_PREDMET(studijni_obor_id_obor, predmet_id_predmet)
    VALUES (id_obor_in, id_predmet_in);
END;
/
/*
Vazebn� tabulka u�ivatel x skupina*/
CREATE OR REPLACE PROCEDURE insert_uzivatel_skupina(id_uzivatel_in INTEGER, id_skupina_in INTEGER)
    IS
BEGIN
    INSERT INTO UZIVATEL_SKUPINA(uzivatel_id_uzivatel, skupina_id_skupina)
    VALUES (id_uzivatel_in, id_skupina_in);
END;
/
CREATE OR REPLACE PROCEDURE insert_skupina(nazev_in in VARCHAR2, popis_in in VARCHAR2, id_predmet_in INTEGER)
    IS
BEGIN
    INSERT INTO SKUPINY(nazev, popis, id_predmet)
    VALUES (nazev_in, popis_in, id_predmet_in);
END;
/
/*=====Insert procedury=====*/
/*=====Delete procedury=====*/
CREATE OR REPLACE PROCEDURE delete_predmet(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM PREDMETY WHERE PREDMETY.ID_PREDMET = id_in;
    /*skupiny*/
    delete_obor_predmet(id_in, 0);
END;
/
CREATE OR REPLACE PROCEDURE delete_hodnoceni(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM HODNOCENI WHERE HODNOCENI.ID_UZIVATEL = id_in;
END;
/
CREATE OR REPLACE PROCEDURE delete_zprava(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM ZPRAVY WHERE ZPRAVY.ID_ZPRAVA = id_in;
END;
/

/* DELETE obor_predmet
    id_in: element ID;
    Element type:
        0 - Obor
        1> - Predmet
 */
CREATE OR REPLACE PROCEDURE delete_obor_predmet(id_in IN NUMBER, element_type_in IN NUMBER)
    IS
BEGIN
    IF element_type_in = 0 THEN
        DELETE FROM OBOR_PREDMET WHERE OBOR_PREDMET.PREDMET_ID_PREDMET = id_in;
    ELSE
        DELETE FROM OBOR_PREDMET WHERE OBOR_PREDMET.STUDIJNI_OBOR_ID_OBOR = id_in;
    END IF;
END;
/

/* DELETE uzivatel_skupina
    id_in: element ID;
    Element type:
        0 - uzivatel
        1> - skupina
 */
CREATE OR REPLACE PROCEDURE delete_uzivatel_skupina(id_in IN NUMBER, element_type_in IN NUMBER)
    IS
BEGIN
    IF element_type_in = 0 THEN
        DELETE FROM UZIVATEL_SKUPINA WHERE UZIVATEL_SKUPINA.UZIVATEL_ID_UZIVATEL = id_in;
    ELSE
        DELETE FROM UZIVATEL_SKUPINA WHERE UZIVATEL_SKUPINA.SKUPINA_ID_SKUPINA = id_in;
    END IF;
END;
/
/*=====Delete procedury=====*/
/*Ov��en� procedury - pot� p�esun na spr�vn� m�sto*/

CREATE OR REPLACE PROCEDURE insert_student(jmeno_in IN VARCHAR2, prijmeni_in IN VARCHAR2, email_in VARCHAR2,
                                           heslo_in VARCHAR2, datum_vytvoreni_in DATE, rok_studia_in VARCHAR2,
                                           id_obor_in INTEGER)
    IS
    user_id INTEGER;
BEGIN
    INSERT INTO UZIVATELE(jmeno, prijmeni, email, heslo, datum_vytvoreni, uzivatel_typ)
    VALUES (jmeno_in, prijmeni_in, email_in, heslo_in, datum_vytvoreni_in, 'student');
    SELECT MAX(id_uzivatel) into user_id from UZIVATELE;
    INSERT INTO STUDENTI(id_uzivatel, rok_studia, id_obor)
    VALUES (user_id, rok_studia_in, id_obor_in);

END;
/
CREATE OR REPLACE PROCEDURE insert_ucitel(jmeno_in IN VARCHAR2, prijmeni_in IN VARCHAR2, email_in VARCHAR2,
                                          heslo_in VARCHAR2, datum_vytvoreni_in DATE, katedra_in VARCHAR2,
                                          id_predmet_in INTEGER)
    IS
    user_id INTEGER;
BEGIN
    INSERT INTO UZIVATELE(jmeno, prijmeni, email, heslo, datum_vytvoreni, uzivatel_typ)
    VALUES (jmeno_in, prijmeni_in, email_in, heslo_in, datum_vytvoreni_in, 'ucitel');
    SELECT max(id_uzivatel) into user_id from UZIVATELE;
    INSERT INTO UCITELE(id_uzivatel, katedra, id_predmet)
    VALUES (user_id, katedra_in, id_predmet_in);
END;
/
CREATE OR REPLACE PROCEDURE delete_ucitel(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM UCITELE WHERE UCITELE.id_uzivatel = id_in;
    DELETE FROM ZPRAVY WHERE zpravy.id_uzivatel_odesilatel = id_in OR id_uzivatel_prijemce = id_in;
    DELETE FROM UZIVATEL_SKUPINA WHERE UZIVATEL_ID_UZIVATEL = id_in;
    DELETE FROM HODNOCENI WHERE HODNOCENI.ID_UZIVATEL = id_in;
    DELETE FROM UZIVATELE WHERE UZIVATELE.id_uzivatel = id_in;
END;
/
CREATE OR REPLACE PROCEDURE delete_student(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM STUDENTI WHERE STUDENTI.id_uzivatel = id_in;
    DELETE FROM ZPRAVY WHERE zpravy.id_uzivatel_odesilatel = id_in OR id_uzivatel_prijemce = id_in;
    DELETE FROM UZIVATEL_SKUPINA WHERE UZIVATEL_ID_UZIVATEL = id_in;
    DELETE FROM HODNOCENI WHERE HODNOCENI.ID_UZIVATEL = id_in;
    DELETE FROM UZIVATELE WHERE UZIVATELE.id_uzivatel = id_in;
END;
/
CREATE OR REPLACE PROCEDURE delete_admin(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM ZPRAVY WHERE zpravy.id_uzivatel_odesilatel = id_in OR id_uzivatel_prijemce = id_in;
    DELETE FROM UZIVATEL_SKUPINA WHERE UZIVATEL_ID_UZIVATEL = id_in;
    DELETE FROM HODNOCENI WHERE HODNOCENI.ID_UZIVATEL = id_in;
    DELETE FROM UZIVATELE WHERE UZIVATELE.id_uzivatel = id_in;
END;
/
CREATE OR REPLACE PROCEDURE delete_group(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM ZPRAVY WHERE zpravy.id_skupina_prijemce = id_in;
    DELETE FROM UZIVATEL_SKUPINA WHERE skupina_id_skupina = id_in;
    DELETE FROM HODNOCENI WHERE HODNOCENI.ID_SKUPINA = id_in;
    DELETE FROM SKUPINY WHERE SKUPINY.id_skupina = id_in;
END;
/
CREATE OR REPLACE PROCEDURE delete_field(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM STUDENTI WHERE STUDENTI.id_obor = id_in;
    DELETE FROM OBOR_PREDMET WHERE OBOR_PREDMET.studijni_obor_id_obor = id_in;
    DELETE FROM STUDIJNI_OBORY WHERE STUDIJNI_OBORY.id_obor = id_in;
END;
/
/*=====Procedury=====*/


/*=======Pohledy=====*/
CREATE OR REPLACE VIEW getFields AS
SELECT o.id_obor    "id_obor",
       o.nazev      "nazev_obor",
       o.popis      "popis_obor",
       p.id_predmet "id_predmet",
       p.nazev      "nazev_predmet",
       p.popis      "popis_predmet"
from OBOR_PREDMET ob
         JOIN STUDIJNI_OBORY o ON o.id_obor = ob.studijni_obor_id_obor
         JOIN PREDMETY p on ob.predmet_id_predmet = p.id_predmet;

CREATE OR REPLACE VIEW getUsers AS
SELECT u.id_uzivatel,
       u.jmeno,
       u.prijmeni,
       u.heslo,
       u.email,
       u.datum_vytvoreni,
       u.uzivatel_typ,
       s.rok_studia,
       so.id_obor,
       so.nazev     "nazev_obor",
       so.popis     "popis_obor",
       uc.katedra,
       p.id_predmet "id_vyucujici_predmet",
       p.nazev      "nazev_vyucujici_predmet",
       p.popis      "popis_vyucujici_predmet"
FROM UZIVATELE u
         LEFT JOIN STUDENTI s ON u.id_uzivatel = s.id_uzivatel
         LEFT JOIN UCITELE uc on u.id_uzivatel = uc.id_uzivatel
         LEFT JOIN STUDIJNI_OBORY so ON s.id_obor = so.id_obor
         LEFT JOIN PREDMETY p on uc.id_predmet = p.id_predmet;

CREATE OR REPLACE VIEW getStudents AS
SELECT u.id_uzivatel "id_uzivatel",
       u.jmeno,
       u.prijmeni,
       u.email,
       u.datum_vytvoreni,
       u.uzivatel_typ,
       s.rok_studia,
       so.id_obor,
       so.nazev,
       so.popis
FROM UZIVATELE u
         JOIN STUDENTI s ON u.id_uzivatel = s.id_uzivatel
         JOIN STUDIJNI_OBORY so ON s.id_obor = so.id_obor;

CREATE OR REPLACE VIEW getTeachers AS
SELECT u.id_uzivatel,
       u.jmeno,
       u.prijmeni,
       u.email,
       u.datum_vytvoreni,
       u.uzivatel_typ,
       uc.katedra,
       p.id_predmet "id_vyucujici_predmet",
       p.nazev      "nazev_vyucujici_predmet",
       p.popis      "popis_vyucujici_predmet"
FROM UZIVATELE u
         JOIN UCITELE uc ON u.id_uzivatel = uc.id_uzivatel
         JOIN PREDMETY p ON uc.id_predmet = p.id_predmet;

CREATE OR REPLACE VIEW getGroups AS
SELECT s.id_skupina,
       s.nazev      "nazev_skupina",
       s.popis      "popis_skupina",
       p.id_predmet "id_skupina_predmet",
       p.nazev      "nazev_skupina_predmet",
       p.popis      "popis_skupina_predmet"
FROM SKUPINY S
         JOIN PREDMETY P ON S.ID_PREDMET = P.ID_PREDMET;

CREATE OR REPLACE VIEW getUsersInGroups AS
SELECT *
FROM UZIVATEL_SKUPINA us
         JOIN (SELECT * FROM GETGROUPS) g on us.skupina_id_skupina = g.id_skupina
         JOIN (SELECT * FROM GETUSERS) u on us.uzivatel_id_uzivatel = u.id_uzivatel;

CREATE OR REPLACE VIEW getRatings AS
SELECT h.id_hodnoceni,
       h.hodnota_hodnoceni,
       h.popis,
       u.*,
       g.*
FROM HODNOCENI h
         JOIN (select * from getusers) u ON u.id_uzivatel = h.id_uzivatel
         JOIN (select * from getgroups) g ON g.id_skupina = h.id_skupina;

/*CREATE OR REPLACE VIEW getGroups AS
SELECT
u.id_uzivatel, u.jmeno, u.prijmeni, u.email, u.datum_vytvoreni, u.uzivatel_typ,
st.rok_studia,
so.id_obor, so.nazev "Nazev_obor", so.popis "Popis_obor",
uc.katedra,
p.id_predmet , p.nazev "nazev_predmet", p.popis "popis_predmet",
s.id_skupina, s.nazev "Nazev_skupina", s.popis "Popis_skupina",
pr.id_predmet "id_predmet_skupiny", pr.nazev "nazev_predmetu_skupina", pr.popis "popis_predmetu_skupiny"
FROM UZIVATEL_SKUPINA us
JOIN UZIVATELE u ON us.uzivatel_id_uzivatel = u.id_uzivatel
JOIN SKUPINY s ON us.skupina_id_skupina = s.id_skupina
LEFT JOIN STUDENTI st ON u.id_uzivatel = st.id_uzivatel
LEFT JOIN UCITELE uc ON u.id_uzivatel = uc.id_uzivatel
LEFT JOIN STUDIJNI_OBORY so ON st.id_obor = so.id_obor
LEFT JOIN PREDMETY p ON uc.id_predmet = p.id_predmet
JOIN PREDMETY pr ON s.id_predmet = pr.id_predmet; */

/*=======Pohledy=====*/
/*=======Triggery=====*/

CREATE OR REPLACE TRIGGER hodnoceni_trigger
    BEFORE INSERT
    ON HODNOCENI
    FOR EACH ROW
BEGIN
    IF (:NEW.hodnota_hodnoceni < 0 OR :NEW.hodnota_hodnoceni > 10) then
        raise_application_error(-200001, 'Hodnota hodnocen� mus� b�t v rozmez� 0-10');
    end if;

    SELECT increment_hodnoceni.nextval
    INTO :new.id_hodnoceni
    FROM dual;
END;
/


CREATE OR REPLACE TRIGGER uzivatele_trigger
    BEFORE INSERT
    ON UZIVATELE
    FOR EACH ROW
declare
    email_count integer;
BEGIN
    select COUNT(*) into email_count FROM uzivatele where email = :NEW.email;

    if (LENGTH(:NEW.jmeno) < 3 or LENGTH(:NEW.jmeno) > 30) then
        raise_application_error(-20001, 'Jm�no mus� b�t v rozsahu 3 a� 30 znak�');
    elsif (LENGTH(:NEW.prijmeni) < 3 or LENGTH(:NEW.prijmeni) > 30) then
        raise_application_error(-20001, 'P�ijmen� mus� b�t v rozsahu 3 a� 30 znak�');
    elsif (LENGTH(:NEW.heslo) < 2) then
        raise_application_error(-20001, 'P��li� slab� heslo. Minim�ln� po�et znak� je 2');
    elsif (email_count > 0) then
        raise_application_error(-20001, 'Email ji� existuje');
    end if;

    :NEW.datum_vytvoreni := sysdate;
    SELECT increment_uzivatele.nextval
    INTO :NEW.id_uzivatel
    FROM dual;
END;
/


CREATE OR REPLACE TRIGGER predmety_trigger
    BEFORE INSERT
    ON PREDMETY
    FOR EACH ROW
BEGIN

    if (LENGTH(:NEW.nazev) < 3 or LENGTH(:NEW.nazev) > 50) then
        raise_application_error(-20001, 'N�zev mus� b�t v rozsahu 3 a� 50 znak�');
    end if;

    SELECT increment_predmety.nextval
    INTO :new.id_predmet
    FROM dual;
END;
/


CREATE OR REPLACE TRIGGER skupiny_trigger
    BEFORE INSERT
    ON SKUPINY
    FOR EACH ROW
BEGIN
    if (LENGTH(:NEW.nazev) < 3 or LENGTH(:NEW.nazev) > 30) then
        raise_application_error(-20001, 'N�zev mus� b�t v rozsahu 3 a� 30 znak�');
    end if;

    SELECT increment_skupiny.nextval
    INTO :new.id_skupina
    FROM dual;
END;
/


CREATE OR REPLACE TRIGGER obory_trigger
    BEFORE INSERT
    ON STUDIJNI_OBORY
    FOR EACH ROW
BEGIN
    if (LENGTH(:NEW.nazev) < 3 or LENGTH(:NEW.nazev) > 30) then
        raise_application_error(-20001, 'N�zev mus� b�t v rozsahu 3 a� 30 znak�');
    end if;

    SELECT increment_obory.nextval
    INTO :new.id_obor
    FROM dual;
END;
/

/*Ot�zka. D�lku mi vlastn� kontroluje VARCHAR(50). M�l bych to tady v�bec o�et�ovat ?*/
CREATE OR REPLACE TRIGGER zpravy_trigger
    BEFORE INSERT
    ON ZPRAVY
    FOR EACH ROW
BEGIN
    if (LENGTH(:NEW.nazev) <= 0 or LENGTH(:NEW.nazev) > 30) then
        raise_application_error(-20001, 'N�zev zpr�vy nesm� b�t pr�zdn� nebo v�t�� jak 30 znak�');
    elsif (LENGTH(:NEW.telo) <= 0 or LENGTH(:NEW.telo) > 250) then
        raise_application_error(-20001, 'T�lo zpr�vy nesm� b�t pr�zdn� nebo v�t�� jak 150 znak�');
    end if;

    :new.datum_vytvoreni := sysdate;
    SELECT increment_zpravy.nextval
    INTO :new.id_zprava
    FROM dual;
END;
/*=======Triggery=====*/
/*=======Funkce=====*/
CREATE OR REPLACE FUNCTION fnc_rating_average(id integer)
    RETURN integer
    IS
    average integer;
BEGIN
    SELECT AVG(hodnota_hodnoceni) into average FROM getRatings where id_skupina = id;
    return average;
END;
/*=======Funkce=====*/



