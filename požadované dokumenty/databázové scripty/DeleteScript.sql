/*=============DROP TRIGGER=============*/
drop trigger hodnoceni_trigger;
drop trigger uzivatele_trigger;
drop trigger predmety_trigger;
drop trigger skupiny_trigger;
drop trigger obory_trigger;
drop trigger zpravy_trigger;
drop trigger transakce_trigger;
drop trigger produkty_trigger;
drop trigger jidelni_listky_trigger;

/*=============DROP TABLE=============*/
drop table UZIVATELE_SKUPINY cascade constraints;
drop table ZPRAVY cascade constraints;
drop table JIDELNI_LISTKY cascade constraints;
drop table PRODUKTY cascade constraints;
drop table TRANSAKCE cascade constraints;
drop table UCITELE_PREDMETY cascade constraints;
drop table UCITELE cascade constraints;
drop table STUDENTI cascade constraints;
drop table UZIVATELE cascade constraints;
drop table STUDIJNI_OBORY cascade constraints;
drop table SKUPINY_PREDMETY cascade constraints;
drop table PREDMETY cascade constraints;
drop table SKUPINY cascade constraints;
drop table HODNOCENI cascade constraints;
drop table OBOR_PREDMET cascade constraints;
drop table ZPRAVY_BACKUP cascade constraints;
drop table SOUBORY cascade constraints;
drop table OBLIBENE_ZPRAVY cascade constraints;
drop table LISTEK_PRODUKT cascade constraints;

/*=============DROP SEQUENCE=============*/
drop sequence INCREMENT_HODNOCENI;
drop sequence INCREMENT_OBORY;
drop sequence INCREMENT_PREDMETY;
drop sequence INCREMENT_SKUPINY;
drop sequence INCREMENT_UZIVATELE;
drop sequence INCREMENT_ZPRAVY;
drop sequence INCREMENT_SOUBORY;
drop sequence INCREMENT_KONTA;
drop sequence INCREMENT_TRANSAKCE;
drop sequence INCREMENT_PRODUKTY;
drop sequence INCREMENT_JIDELNI_LISTKY;

/*=============DROP VIEW=============*/
drop view getUzivatele;
drop view getStudenti;
drop view getUcitele;
drop view getSkupiny;
drop view getUzivateleVeSkupine;
drop view getHodnoceni;
drop view getObory;
drop view getVyucovanePredmety;
drop view getPredmetyVeSkupine;
drop view getPoctyVeSkupinach;
drop view getZpravyHierarchicky;
drop view getOborySPredmetem;
drop view GETOBORYWITHSUBJECT;
drop view GETSKUPINYPREDMETU;
drop view GETSKUPINYUZIVATELE;
drop view GETUCITELESPREDMETEM;
drop view GETUZIVATELODESILATEL;
drop view GETUZIVATELPRIJEMCE;
drop view GETVSECHNYZPRAVY;

/*=============DROP PROCEDURE=============*/
drop PROCEDURE delete_student;
drop PROCEDURE delete_ucitel;
drop PROCEDURE delete_admin;
drop PROCEDURE delete_skupina;
drop PROCEDURE insert_student;
drop PROCEDURE insert_ucitel;
drop PROCEDURE delete_field;
drop procedure delete_skupiny_predmety;
drop procedure delete_ucitele_predmety;
drop procedure delete_predmet;
drop procedure update_predmet;
drop procedure delete_uzivatel_skupina;
drop procedure delete_obor_predmet;
drop procedure delete_zprava;
drop procedure delete_hodnoceni;
drop procedure insert_skupina;
drop procedure insert_uzivatele_skupiny;
drop procedure insert_obor_predmet;
drop procedure insert_studijni_obor;
drop procedure insert_predmet;
drop procedure insert_zprava;
drop procedure insert_hodnoceni;
drop procedure insert_skupiny_predmety;
drop procedure insert_predmet_ucitel;
drop procedure UPDATE_HODNOCENI;
drop procedure UPDATE_SKUPINA;
drop procedure UPDATE_ZPRAVA;

/*=============DROP FUNCTION=============*/
drop function fnc_prumer_hodnoceni;
drop function fnc_get_nejlepe_hodnocenou_skupinu;
drop function fnc_zahashuj_uzivatele;
drop function FNC_POCET_UZIVATELU_VE_SKUPINE;
