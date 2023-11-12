--szemelyaz nem lehet null es kulcs number(5) 4igen 6 nem
-- vnev nem lehet null varchar(2) 20
--knev nem lehet null varchar(2) 20
--szulhely  varchar(2) 20
--szig szam char(8)
--cim number(5)
create table szemely(szemely_azon number(5) primary key not null, 
                    vezeteknev varchar2(20) not null,
                    keresztknev varchar2(20) not null,
                    szul_hely varchar2(20),
                    szig_szam char(8),
                    cim number(5));
                    
drop table szemely;

alter table szemely
add constraint szemely_uq unique(szig_szam);

select *
from szemely;

insert into szemely values(1, 'Kovács', 'István', 'Budapest', '123456AA', 10001);
insert into szemely values(2, 'Kiss', 'Anna', 'Budapest', '123456AB', 10002);
insert into szemely values(3, 'Nagy', 'József', 'Debrecen', '123456AC', 10003);
insert into szemely values(4, 'Kiss', 'Kata', 'Debrecen', '123456AD', 10004);
insert into szemely values(5, 'Horváth', 'Péter', 'Debrecen', '123456AE', 10003);
insert into szemely values(6, 'Balogh', 'Éva', 'Budapest', '123456AF', 10005);
insert into szemely values(7, 'Szabó', 'Szilvia', 'Sopron', '123456AG', 10006);

--cimazon number(5) kulcs nem lhete null
--iranitoszam number(4) nem lehet null
--helysegnev nem lehet null varchar2(20)
--kozteruletnev varchar2(20) nem null
--hazsam number(3) nem lehet null
create table cim(cim_azon number(5) primary key not null, 
                 iranyitoszam number(4) not null,
                 helyseg_nev varchar2(20) not null,
                 kozterulet_nev varchar2(30) not null,
                 haz_szam number(3) not null);
                 
select *
from cim;

insert into cim values(10001, 4220, 'Hajdúböszörmény', 'Kossuth utca', 4);
insert into cim values(10002, 4032, 'Debrecen', 'Apafi utca', 6);
insert into cim values(10003, 1063, 'Budapest', 'Szív utca', 16);
insert into cim values(10004, 1118, 'Budapest', 'GAzdagréti  tér', 3);
insert into cim values(10005, 4032, 'Debrecen', 'Kassai út', 26);
insert into cim values(10006, 1074, 'Budapest', 'Akácfa utca', 13);

alter table szemely 
add constraint szemely_fk FOREIGN key(cim) REFERENCES cim(cim_azon);

---------

create table kedvenc(kedvenc_azon number(5) PRIMARY KEY not null,
                    gazd_azon number(5) not null,
                    faj varchar2(15) not null,
                    nev varchar2(15),
                    kor number(3));
                    
insert into kedvenc values(201, 1, 'kutya', 'Fifi', 3);
insert into kedvenc values(202, 1, 'kutya', 'Bodri', 5);
insert into kedvenc values(203, 1, 'macska', 'Cili', '');
insert into kedvenc values(204, 1, 'hal', '','');
insert into kedvenc values(205, 2, 'kutya', 'Blöki', 5);

select *
from kedvenc;

alter table kedvenc
add constraint kedvenc_fk FOREIGN key(gazd_azon) REFERENCES szemely(szemely_azon);

commit;
select *
from szemely join cim
on szemely.cim = cim.cim_azon;

update szemely 
set szul_hely = 'Debrecen' 
where szemely_Azon = 7;

select *
from szemely sz left outer join kedvenc k
on sz.szemely_azon = k.gazd_azon
where k.kedvenc_azon is null;

create table ut as 
select *
from hajo.s_ut;

select *
from ut; 

delete from ut 
where ut_id = 0530001;

select gazd_azon
from kedvenc
group by gazd_azon 
having count(*)>2;

savepoint first_savepoint;

delete from kedvenc
where kor = 3;

select *
from kedvenc;

rollback first_savepoint;

alter table kedvenc
add(szin varchar2(20));

update kedvenc
set szin = 'fekete'
where kor is null and nev is null;

update kedvenc
set szin = 'valószínû'
where faj = 'macska';

update kedvenc
set szin = 'piros'
where faj = 'kutya';

