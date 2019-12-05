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
    popis      VARCHAR2(250)
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
    katedra     VARCHAR2(50) NOT NULL
);

ALTER TABLE ucitele
    ADD CONSTRAINT ucitel_pk PRIMARY KEY (id_uzivatel);

create table UCITELE_PREDMETY
(
    UCITELE_ID_UCITEL  int
        constraint UCITELE_PREDMETY_UCITELE_ID_UZIVATEL_fk
            references UCITELE,
    PREDMET_ID_PREDMET int
        constraint UCITELE_PREDMETY_PREDMETY_ID_PREDMET_fk
            references PREDMETY,
    constraint UCITELE_PREDMET_pk
        primary key (UCITELE_ID_UCITEL, PREDMET_ID_PREDMET)
);

CREATE TABLE uzivatele_skupiny
(
    uzivatele_id_uzivatel INTEGER NOT NULL,
    skupiny_id_skupina    INTEGER NOT NULL
);

ALTER TABLE uzivatele_skupiny
    ADD CONSTRAINT uzivatele_skupiny_pk PRIMARY KEY (uzivatele_id_uzivatel,
                                                    skupiny_id_skupina);

CREATE TABLE uzivatele
(
    id_uzivatel     INTEGER      NOT NULL,
    jmeno           VARCHAR2(50) NOT NULL,
    prijmeni        VARCHAR2(50) NOT NULL,
    email           VARCHAR2(50) NOT NULL,
    heslo           VARCHAR2(50) NOT NULL,
    datum_vytvoreni DATE         NOT NULL,
    uzivatel_typ   VARCHAR2(50)
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
    id_skupina_prijemce    INTEGER,
    id_rodic               INTEGER,
    id_souboru             INTEGER
);

CREATE TABLE zpravy_backup
(
    id_zprava              INTEGER       NOT NULL,
    nazev                  VARCHAR2(50)  NOT NULL,
    telo                   VARCHAR2(250) NOT NULL,
    datum_vytvoreni        DATE          NOT NULL,
    id_uzivatel_odesilatel INTEGER       NOT NULL,
    id_uzivatel_prijemce   INTEGER,
    id_skupina_prijemce    INTEGER
);

create table SKUPINY_PREDMETY
(
    SKUPINY_ID_SKUPINA  int
        constraint SKUPINY_PREDMETY_SKUPINY_ID_SKUPINA_fk
            references SKUPINY,
    PREDMETY_ID_PREDMET int
        constraint SKUPINY_PREDMETY_PREDMETY_ID_PREDMET_fk
            references PREDMETY,
    constraint SKUPINA_PREDMETY_pk
        primary key (SKUPINY_ID_SKUPINA, PREDMETY_ID_PREDMET)
);

ALTER TABLE obor_predmet
    ADD CONSTRAINT obor_predmet_pk PRIMARY KEY (studijni_obor_id_obor,
                                                predmet_id_predmet);
alter table obor_predmet
    add constraint OBOR_PREDMET_PREDMETY_ID_PREDMET_fk
        foreign key (STUDIJNI_OBOR_ID_OBOR) references PREDMETY;

alter table obor_predmet
    add constraint OBOR_PREDMET_STUDIJNI_OBORY_ID_OBOR_fk
        foreign key (STUDIJNI_OBOR_ID_OBOR) references STUDIJNI_OBORY;

ALTER TABLE zpravy
    ADD CONSTRAINT zprava_pk PRIMARY KEY (id_zprava);

ALTER TABLE zpravy
    ADD CONSTRAINT prijemce_skupina FOREIGN KEY (id_skupina_prijemce)
        REFERENCES skupiny (id_skupina);

ALTER TABLE zpravy
    ADD CONSTRAINT prijemce_zprava FOREIGN KEY (id_uzivatel_prijemce)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE zpravy
    ADD CONSTRAINT odesilatel_zprava FOREIGN KEY (id_uzivatel_odesilatel)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE zpravy_backup
    ADD CONSTRAINT zprava_backup_pk PRIMARY KEY (id_zprava);

ALTER TABLE hodnoceni
    ADD CONSTRAINT hodnoceni_skupina FOREIGN KEY (id_skupina)
        REFERENCES skupiny (id_skupina);

ALTER TABLE studenti
    ADD CONSTRAINT student_obor FOREIGN KEY (id_obor)
        REFERENCES studijni_obory (id_obor);

ALTER TABLE hodnoceni
    ADD CONSTRAINT uzivatel_hodnoceni FOREIGN KEY (id_uzivatel)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE uzivatele_skupiny
    ADD CONSTRAINT uzivatel_skupina_skupina_fk FOREIGN KEY (skupiny_id_skupina)
        REFERENCES skupiny (id_skupina);

ALTER TABLE uzivatele_skupiny
    ADD CONSTRAINT uzivatel_skupina_uzivatel_fk FOREIGN KEY (uzivatele_id_uzivatel)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE studenti
    ADD CONSTRAINT uzivatel_student FOREIGN KEY (id_uzivatel)
        REFERENCES uzivatele (id_uzivatel);

ALTER TABLE ucitele
    ADD CONSTRAINT uzivatel_ucitel FOREIGN KEY (id_uzivatel)
        REFERENCES uzivatele (id_uzivatel);

create table soubory
(
    id_souboru    NUMBER        not null
        constraint soubory_pk
            primary key,
    nazev_souboru VARCHAR2(255) not null,
    typ_souboru   VARCHAR2(255) not null,
    pripona       VARCHAR2(255) not null,
    data          BLOB          not null,
    upraveno      DATE          not null,
    nahrano       DATE          not null
)
/
/*ISKAM*/
create table konta
(
    id_konto     NUMBER not null
        constraint KONTO_PK
            primary key,
    id_uzivatele NUMBER not null
        constraint KONTO_UZIVATELE_ID_UZIVATEL_FK
            references UZIVATELE,
    cislo_karty  NUMBER not null
)
/

create table produkty
(
    id_produktu  NUMBER        not null
        constraint PRODUKT_PK
            primary key,
    nazev        VARCHAR2(255) not null,
    popis        VARCHAR2(255) not null,
    skladem      NUMBER,
    typ          NUMBER        not null,
    platnost_dny NUMBER
)
/

create table transakce
(
    id_transakce  NUMBER        not null
        constraint TRANSAKCE_PK
            primary key,
    id_konta      NUMBER        not null
        constraint TRANSAKCE_KONTO_ID_KONTO_FK
            references konta,
    id_produktu   NUMBER        not null
        constraint TRANSAKCE_PRODUKT_ID_PRODUKTU_FK
            references produkty,
    typ_transakce NUMBER        not null,
    castka        FLOAT         not null,
    datum         DATE          not null,
    popis         VARCHAR2(255) not null
)
/

create table jidelni_listky
(
    id_listku   NUMBER not null
        constraint JIDELNI_LISTEK_PK
            primary key,
    id_produktu NUMBER not null
        constraint JIDELNI_LISTEK_PRODUKT_ID_PRODUKTU_FK
            references produkty,
    datum       DATE   not null
)
/


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

CREATE SEQUENCE increment_soubory
    START WITH 1;

CREATE SEQUENCE increment_konta
    START WITH 1;

CREATE SEQUENCE increment_transakce
    START WITH 1;

CREATE SEQUENCE increment_produkty
    START WITH 1;

CREATE SEQUENCE increment_jidelni_listky
    START WITH 1;


/*=============Sekvence============*/
/*==================Procedury===============*/
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
CREATE OR REPLACE PROCEDURE insert_uzivatele_skupiny(id_uzivatel_in INTEGER, id_skupina_in INTEGER)
    IS
BEGIN
    INSERT INTO UZIVATELE_SKUPINY(uzivatele_id_uzivatel, skupiny_id_skupina)
    VALUES (id_uzivatel_in, id_skupina_in);
END;
/
CREATE OR REPLACE PROCEDURE insert_skupina(nazev_in in VARCHAR2, popis_in in VARCHAR2, id_predmet_in INTEGER)
    IS
BEGIN
    INSERT INTO SKUPINY(nazev, popis)
    VALUES (nazev_in, popis_in);
END;
/
CREATE OR REPLACE PROCEDURE insert_konta(uzivatel_id_in in int, cislo_karty_in in VARCHAR2)
    IS
BEGIN
    INSERT INTO konta(id_uzivatele, cislo_karty)
    VALUES (uzivatel_id_in, cislo_karty_in);
END;
/
/*=====Insert procedury=====*/
/*=====Delete procedury=====*/
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
CREATE OR REPLACE PROCEDURE delete_uzivatel_skupina(id_in IN NUMBER, element_type_in IN NUMBER)
    IS
BEGIN
    IF element_type_in = 0 THEN
        DELETE FROM UZIVATELE_SKUPINY WHERE UZIVATELE_SKUPINY.UZIVATELE_ID_UZIVATEL = id_in;
    ELSE
        DELETE FROM UZIVATELE_SKUPINY WHERE UZIVATELE_SKUPINY.SKUPINY_ID_SKUPINA = id_in;
    END IF;
END;
/
/*=====Delete procedury=====*/

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
                                          heslo_in VARCHAR2, datum_vytvoreni_in DATE, katedra_in VARCHAR2)
    IS
    user_id INTEGER;
BEGIN
    INSERT INTO UZIVATELE(jmeno, prijmeni, email, heslo, datum_vytvoreni, uzivatel_typ)
    VALUES (jmeno_in, prijmeni_in, email_in, heslo_in, datum_vytvoreni_in, 'ucitel');
    SELECT max(id_uzivatel) into user_id from UZIVATELE;
    INSERT INTO UCITELE(id_uzivatel, katedra)
    VALUES (user_id, katedra_in);
END;
/
CREATE OR REPLACE PROCEDURE delete_ucitel(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM UCITELE WHERE UCITELE.id_uzivatel = id_in;
    DELETE FROM ZPRAVY WHERE zpravy.id_uzivatel_odesilatel = id_in OR id_uzivatel_prijemce = id_in;
    DELETE FROM UZIVATELE_SKUPINY WHERE UZIVATELE_ID_UZIVATEL = id_in;
    DELETE FROM HODNOCENI WHERE HODNOCENI.ID_UZIVATEL = id_in;
    DELETE FROM UZIVATELE WHERE UZIVATELE.id_uzivatel = id_in;
END;
/
CREATE OR REPLACE PROCEDURE delete_student(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM STUDENTI WHERE STUDENTI.id_uzivatel = id_in;
    DELETE FROM ZPRAVY WHERE zpravy.id_uzivatel_odesilatel = id_in OR id_uzivatel_prijemce = id_in;
    DELETE FROM UZIVATELE_SKUPINY WHERE UZIVATELE_ID_UZIVATEL = id_in;
    DELETE FROM HODNOCENI WHERE HODNOCENI.ID_UZIVATEL = id_in;
    DELETE FROM UZIVATELE WHERE UZIVATELE.id_uzivatel = id_in;
END;
/
CREATE OR REPLACE PROCEDURE delete_admin(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM ZPRAVY WHERE zpravy.id_uzivatel_odesilatel = id_in OR id_uzivatel_prijemce = id_in;
    DELETE FROM UZIVATELE_SKUPINY WHERE UZIVATELE_ID_UZIVATEL = id_in;
    DELETE FROM HODNOCENI WHERE HODNOCENI.ID_UZIVATEL = id_in;
    DELETE FROM UZIVATELE WHERE UZIVATELE.id_uzivatel = id_in;
END;
/
CREATE OR REPLACE PROCEDURE delete_group(id_in IN NUMBER)
    IS
BEGIN
    DELETE FROM ZPRAVY WHERE zpravy.id_skupina_prijemce = id_in;
    DELETE FROM UZIVATELE_SKUPINY WHERE skupiny_id_skupina = id_in;
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
CREATE OR REPLACE VIEW getObory AS
SELECT o.id_obor    "id_obor",
       o.nazev      "nazev_obor",
       o.popis      "popis_obor",
       p.id_predmet "id_predmet",
       p.nazev      "nazev_predmet",
       p.popis      "popis_predmet"
from OBOR_PREDMET ob
         JOIN STUDIJNI_OBORY o ON o.id_obor = ob.studijni_obor_id_obor
         JOIN PREDMETY p on ob.predmet_id_predmet = p.id_predmet;

CREATE OR REPLACE VIEW getUzivatele AS
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
       uc.katedra
FROM UZIVATELE u
         LEFT JOIN STUDENTI s ON u.id_uzivatel = s.id_uzivatel
         LEFT JOIN UCITELE uc on u.id_uzivatel = uc.id_uzivatel
         LEFT JOIN STUDIJNI_OBORY so ON s.id_obor = so.id_obor;

CREATE OR REPLACE VIEW getStudenti AS
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

CREATE OR REPLACE VIEW getUcitele AS
SELECT u.id_uzivatel,
       u.jmeno,
       u.prijmeni,
       u.email,
       u.datum_vytvoreni,
       u.uzivatel_typ,
       uc.katedra
FROM UZIVATELE u
         JOIN UCITELE uc ON u.id_uzivatel = uc.id_uzivatel;

CREATE OR REPLACE VIEW getGroups AS
SELECT s.id_skupina,
       s.nazev "nazev_skupina",
       s.popis "popis_skupina"
FROM SKUPINY S;

CREATE OR REPLACE VIEW getUsersInGroups AS
SELECT *
FROM UZIVATELE_SKUPINY us
         JOIN (SELECT * FROM GETGROUPS) g on us.skupiny_id_skupina = g.id_skupina
         JOIN (SELECT * FROM GETUSERS) u on us.uzivatele_id_uzivatel = u.id_uzivatel;

CREATE OR REPLACE VIEW getHodnoceni AS
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
    BEFORE INSERT OR UPDATE
    ON HODNOCENI
    FOR EACH ROW
BEGIN
    IF (:NEW.hodnota_hodnoceni < 1 OR :NEW.hodnota_hodnoceni > 5) then
        raise_application_error(-200001, 'Hodnota hodnocen� mus� b�t v rozmez� 1-5');
    end if;

    if (inserting) then
        SELECT increment_hodnoceni.nextval
        INTO :new.id_hodnoceni
        FROM dual;
    end if;
END;
/


CREATE OR REPLACE TRIGGER uzivatele_trigger
    BEFORE INSERT OR UPDATE
    ON UZIVATELE
    FOR EACH ROW
BEGIN
    if (LENGTH(:NEW.jmeno) < 3 or LENGTH(:NEW.jmeno) > 30) then
        raise_application_error(-20001, 'Jm�no mus� b�t v rozsahu 3 a� 30 znak�');
    elsif (LENGTH(:NEW.prijmeni) < 3 or LENGTH(:NEW.prijmeni) > 30) then
        raise_application_error(-20001, 'P�ijmen� mus� b�t v rozsahu 3 a� 30 znak�');
    elsif (LENGTH(:NEW.heslo) < 2) then
        raise_application_error(-20001, 'P��li� slab� heslo. Minim�ln� po�et znak� je 2');
    end if;

    :NEW.heslo := fnc_zahashuj_uzivatele(:NEW.email, :NEW.heslo);

    if (inserting) then
        :NEW.datum_vytvoreni := sysdate;
        SELECT increment_uzivatele.nextval
        INTO :NEW.id_uzivatel
        FROM dual;

    end if;
END;
/


CREATE OR REPLACE TRIGGER predmety_trigger
    BEFORE INSERT OR UPDATE
    ON PREDMETY
    FOR EACH ROW
BEGIN

    if (LENGTH(:NEW.nazev) < 3 or LENGTH(:NEW.nazev) > 50) then
        raise_application_error(-20001, 'N�zev mus� b�t v rozsahu 3 a� 50 znak�');
    end if;

    if (inserting) then
        SELECT increment_predmety.nextval
        INTO :new.id_predmet
        FROM dual;
    end if;
END;
/


CREATE OR REPLACE TRIGGER skupiny_trigger
    BEFORE INSERT OR UPDATE
    ON SKUPINY
    FOR EACH ROW
BEGIN
    if (LENGTH(:NEW.nazev) < 3 or LENGTH(:NEW.nazev) > 30) then
        raise_application_error(-20001, 'N�zev mus� b�t v rozsahu 3 a� 30 znak�');
    end if;

    if (inserting) then
        SELECT increment_skupiny.nextval
        INTO :new.id_skupina
        FROM dual;
    end if;
END;
/


CREATE OR REPLACE TRIGGER obory_trigger
    BEFORE INSERT OR UPDATE
    ON STUDIJNI_OBORY
    FOR EACH ROW
BEGIN
    if (LENGTH(:NEW.nazev) < 3 or LENGTH(:NEW.nazev) > 30) then
        raise_application_error(-20001, 'N�zev mus� b�t v rozsahu 3 a� 30 znak�');
    end if;

    if (inserting) then
        SELECT increment_obory.nextval
        INTO :new.id_obor
        FROM dual;
    end if;
END;
/

/*Ot�zka. D�lku mi vlastn� kontroluje VARCHAR(50). M�l bych to tady v�bec o�et�ovat ?*/
CREATE OR REPLACE TRIGGER zpravy_trigger
    BEFORE INSERT OR DELETE OR UPDATE
    ON ZPRAVY
    FOR EACH ROW
BEGIN
    if (deleting) then
        INSERT INTO ZPRAVY_BACKUP(id_zprava, nazev, telo, datum_vytvoreni, id_uzivatel_odesilatel, id_uzivatel_prijemce,
                                  id_skupina_prijemce)
        VALUES (:old.id_zprava, :old.nazev, :old.telo, :old.datum_vytvoreni, :old.id_uzivatel_odesilatel,
                :old.id_uzivatel_prijemce, :old.id_skupina_prijemce);
    else
        if (LENGTH(:NEW.nazev) <= 0 or LENGTH(:NEW.nazev) > 30) then
            raise_application_error(-20001, 'N�zev zpr�vy nesm� b�t pr�zdn� nebo v�t�� jak 30 znak�');
        elsif (LENGTH(:NEW.telo) <= 0 or LENGTH(:NEW.telo) > 250) then
            raise_application_error(-20001, 'T�lo zpr�vy nesm� b�t pr�zdn� nebo v�t�� jak 150 znak�');
        end if;

        if (inserting) then
            :new.datum_vytvoreni := sysdate;
            SELECT increment_zpravy.nextval
            INTO :new.id_zprava
            FROM dual;
        end if;
    end if;

END;
/
CREATE OR REPLACE TRIGGER soubory_trigger
    BEFORE INSERT OR UPDATE
    ON SOUBORY
    FOR EACH ROW
BEGIN
    if (inserting) then
        SELECT increment_soubory.nextval
        INTO :NEW.id_souboru
        FROM dual;
    end if;
END;
/
CREATE OR REPLACE TRIGGER konta_trigger
    BEFORE INSERT OR UPDATE
    ON KONTA
    FOR EACH ROW
BEGIN
    if (inserting) then
        SELECT increment_konta.nextval
        INTO :NEW.id_konto
        FROM dual;
    end if;
END;
/
CREATE OR REPLACE TRIGGER transakce_trigger
    BEFORE INSERT OR UPDATE
    ON TRANSAKCE
    FOR EACH ROW
BEGIN
    if (inserting) then
        SELECT increment_transakce.nextval
        INTO :NEW.id_transakce
        FROM dual;
    end if;
END;
/
CREATE OR REPLACE TRIGGER produkty_trigger
    BEFORE INSERT OR UPDATE
    ON PRODUKTY
    FOR EACH ROW
BEGIN
    if (inserting) then
        SELECT increment_produkty.nextval
        INTO :NEW.id_produktu
        FROM dual;
    end if;
END;
/
CREATE OR REPLACE TRIGGER jidelni_listky_trigger
    BEFORE INSERT OR UPDATE
    ON JIDELNI_LISTKY
    FOR EACH ROW
BEGIN
    if (inserting) then
        SELECT increment_jidelni_listky.nextval
        INTO :NEW.id_listku
        FROM dual;
    end if;
END;
/
/*=======Triggery=====*/
/*=======Funkce=====*/
CREATE OR REPLACE FUNCTION fnc_zahashuj_uzivatele(uziv_jmeno_in in varchar2, heslo_in in varchar2) return varchar2
    IS
BEGIN
    RETURN ltrim(to_char(dbms_utility.get_hash_value(upper(uziv_jmeno_in) || '/' || upper(heslo_in),
                                                     1000000000, power(2, 30)),
                         rpad('X', 29, 'X') || 'X'));
END;
/
CREATE OR REPLACE FUNCTION fnc_prumer_hodnoceni(id integer)
    RETURN number
    IS
    prumer number;
BEGIN
    SELECT AVG(hodnota_hodnoceni) into prumer FROM getHodnoceni where id_skupina = id;
    return prumer;
END;
/
CREATE OR REPLACE FUNCTION fnc_get_nejlepe_hodnocenou_skupinu
    RETURN integer
    IS
    max_hodnota  integer := 0;
    max_id     integer;
    temp_hodnota integer;
begin
    FOR id IN (SELECT id_skupina from skupiny)
        LOOP
            temp_hodnota := fnc_prumer_hodnoceni(id.id_skupina);
            if (temp_hodnota > max_hodnota) then
                max_hodnota := temp_hodnota; max_id := id.id_skupina;
            end if;
        end loop;
    return max_id;
end;
/*=======Funkce=====*/



