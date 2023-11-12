drop table z_hozzatartozo purge;
drop table z_dolgozik_rajta purge;
drop table z_projekt purge;
drop table z_oszt_helyszinek purge;

alter table z_osztaly 
drop constraint z_fk_oszt_vez;

drop table z_dolgozo purge;
drop table z_osztaly purge; 

create table z_osztaly
(onev varchar2(20),
oszam number(5),
vez_szsz char(11),
vez_kezdo_datum date,
constraint z_pk_osztaly primary key (oszam));


create table z_dolgozo
(vnev varchar2(30),
knev varchar2(30),
szsz char(11),
szdatum date,
lakcim varchar2(100),
nem char(1),
fizetes number(10),
fonok_szsz char(11),
osz number(5),
constraint z_pk_dolg primary key (szsz),
constraint z_fk_dolg_fonok foreign key (fonok_szsz) references z_dolgozo (szsz),
constraint z_fk_dolg_osz foreign key (osz) references z_osztaly (oszam));

alter table z_osztaly
add constraint z_fk_oszt_vez foreign key (vez_szsz) references z_dolgozo (szsz);

create table z_oszt_helyszinek
(oszam number(5),
ohelyszin varchar(20),
constraint z_pk_oszt_helyszin primary key (oszam, ohelyszin),
constraint z_fk_oszt_helysz_oszam foreign key (oszam) references z_osztaly (oszam));

create table z_projekt
(pnev varchar2(20),
pszam number(5),
phelyszin varchar(20),
osz number(5),
constraint z_pk_projekt primary key (pszam),
constraint z_fk_projekt_oszam foreign key (osz) references z_osztaly (oszam));

create table z_dolgozik_rajta
(dszsz char(11),
psz number(5),
orak number(10,2),
constraint z_pk_dolg_r primary key (dszsz, psz),
constraint z_fk_dolg_r_pszam foreign key (psz) references z_projekt (pszam),
constraint z_fk_dolg_r_dszsz foreign key (dszsz) references z_dolgozo (szsz));

create table z_hozzatartozo
(dszsz char(11),
hozzatartozo_nev varchar2(30),
nem char(1),
szdatum date,
kapcsolat varchar2(30),
constraint z_pk_hozzatart primary key (dszsz, hozzatartozo_nev),
constraint z_fk_hozzatart_dszsz foreign key (dszsz) references z_dolgozo (szsz));
