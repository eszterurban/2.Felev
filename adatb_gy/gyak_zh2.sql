--Afrikában és Ázsiában melyik a legnagyobb lakosságú ország
select orszag
from OLIMPIA.o_orszagok
where (foldresz,lakossag) in (select foldresz, max(lakossag)
                                from OLIMPIA.o_orszagok
                                group by foldresz
                                HAVING foldresz in('Afrika', 'Ázsia'));
                
--listázzuk ki azokat az országokat, amelyek nem indítottak versenyzõket
select orszag
from OLIMPIA.o_orszagok o left outer join olimpia.o_versenyzok v
on o.azon = v.orszag_azon
where v.azon is null;

--listázzuk ki azokat az orszagazonosítókat amik nem szerepelnek az éremtáblában.
select o.azon
from olimpia.o_orszagok o left outer join OLIMPIA.o_erem_tabla e
on o.azon = e.orszag_azon
where e.orszag_azon is null;

-- listázzuk ki azokat a csapatneveket, amelyek esetén meg vannak adva a csapattagok
select nev
from OLIMPIA.o_versenyzok v
where v.egyen_csapat = 'c' and azon in (select azon
                                        from olimpia.o_csapattagok cs
                                        where v.azon= cs.csapat_azon);

--diák besorolású tagok közzül ki a legidõsebb
select keresztnev, vezeteknev
from konyvtar.tag
where szuletesi_datum = (select  min(szuletesi_datum)
                            from konyvtar.tag
                            where besorolas = 'diák');

--listázzuk ki egy listában a szerzpk keresztnevét és születési hónapját
--illetve a tagok keresztnevét és születési hónapját. 
--Minden név-hónap páros annyiszor szerepeljen ahányszor a táblában is elõfordul
select keresztnev, to_char(szuletesi_datum, 'mm')
from KONYVTAR.szerzo
union all
select keresztnev, to_char(szuletesi_datum, 'mm')
from KONYVTAR.tag;

--listázzuk ki egy listában a szerzpk keresztnevét és születési hónapját
--illetve a tagok keresztnevét és születési hónapját. 
--Minden név-hónap páros egyszer szerepeljen
select keresztnev, to_char(szuletesi_datum, 'mm')
from KONYVTAR.szerzo
union
select keresztnev, to_char(szuletesi_datum, 'mm')
from KONYVTAR.tag;

--melyek azok a keresztnevek, amelyek szerzõ keresztneve is és egyben
-- valamelyik tagé is
select keresztnev
from KONYVTAR.szerzo
INTERSECT
select keresztnev
from KONYVTAR.tag;

-- gyerek tagok közzül ki a legidõsebb
select keresztnev, vezeteknev
from konyvtar.tag
where besorolas = 'gyerek' and szuletesi_datum = (SELECT min(szuletesi_datum)
                                                        from konyvtar.tag
                                                        where besorolas='gyerek');
                                                        
-- kik azok a szerzõk akik 3-nál kevesebb könyvet írtak
select count(konyv_azon), sz.vezeteknev, sz.keresztnev
from konyvtar.szerzo sz left OUTER join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon 
group by ksz.szerzo_azon, sz.vezeteknev, sz.keresztnev
having count(konyv_azon) < 3;
                                                    
-- kik azok a szerzõk, akik a legkevesebb könyvet írták
select count(konyv_azon), sz.vezeteknev, sz.keresztnev
from konyvtar.szerzo sz left OUTER join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon 
group by ksz.szerzo_azon, sz.vezeteknev, sz.keresztnev
order by count(konyv_azon)
fetch first rows with ties;

-- 10 legidõsebb szerzõ neve és szuletesi datuma
select to_char(szuletesi_datum, 'yyyy.mm.dd'), vezeteknev, keresztnev 
from konyvtar.szerzo
order by szuletesi_datum
fetch first 10 rows with ties;

-- listázzuk ki az egyes keresztnevekbõl hány db van a konyvtar sémában
select keresztnev, count(*)
from (select keresztnev
        from konyvtar.tag
        union all
        select keresztnev
        from konyvtar.szerzo)
group by keresztnev
order by count(*);

--Hozzunk l?tre egy szem?ly t?bl?t a k?vetkez? param?terekkel: 
--szemely_azon number(5) ->el?dleges kulcs, vezeteknev varchar2(15), 
--keresztnev varchar2(15), -> ezek nem vehetnek fel NULL ?rt?ket, szuletesi_hely varchar2(20), 
--szig_szam char(8), cim number(5).
create table szemely(szemely_azon number(5) primary key not NULL,
                        vezeteknev varchar2(15) not null,
                        keresztnev varchar2(15) not null,
                        szuletesi_datum varchar2(20),
                        szig_szam char(8),
                        cim number(5));
drop table szemely;
alter table szemely
rename COLUMN szuletesi_datum to szuletesi_hely;

--Adjuk hozz? a k?vetkez? megszor?t?sokat:
--szig sz?m unique ?> szemely_uq
alter table szemely
add CONSTRAINT szemely_uq UNIQUE(szig_szam);

--sz?rjuk be a k?vetkez? sorokat a szemely t?bl?ba:
--1, Kov?cs, Istv?n, Budapest, 123456AA, 10001
--2, Kiss, Anna, Budapest, 123456AB, 10002
--3, Nagy, J?zsef, Debrecen, 123456AC, 10003
--4, Horv?th, P?ter, Gy?r, 123456AD, 10004
--5, Kiss, Kata, Debrecen, 123456AE, 10003
--6, Balogh, ?va, Budapest, 123456AF, 10005
--7, Szab?, Szilvia, Sopron, 123456AG, 10006

insert into szemely VALUES (1, 'Kovács', 'István', 'Budapest', '123456AA', 10001);
insert into szemely VALUES (2, 'Kiss', 'Anna', 'Budapest', '123456AB', 10002);
insert into szemely VALUES (3, 'Nagy', 'József', 'Debrecen', '123456AC', 10003);
insert into szemely VALUES (4, 'Horváth', 'Péter', 'Gyõr', '123456AD', 10004);
insert into szemely VALUES (5, 'Kiss', 'Kata', 'Debrecen', '123456AE', 10003);
insert into szemely VALUES (6, 'Balogh', 'Éva', 'Budapest', '123456AF', 10005);
insert into szemely VALUES (7, 'Szabó', 'Szilvia', 'Sopron', '123456AG', 10006);

--Hozzunnk l?tre egy c?m t?bl?t a k?vetkez? param?terekkel: cim_azon number(5) ->el?dleges kulcs,
--iranyitoszam char(4), helyseg_nev varchar2(30), kozterulet_nev varchar2(40), 
--haz_szam number(3) ezek k?zz?l egyik sem vehet fel null ?rt?ket.


CREATE TABLE cim(cim_azon NUMBER(5) PRIMARY KEY NOT NULL,
                iranyitoszam CHAR(4) NOT NULL,
                helyseg_nev VARCHAR2(30) NOT NULL,
                kozterulet_nev VARCHAR2(40) NOT NULL,
                haz_szam NUMBER(3) NOT NULL);


--sz?rjuk be a k?vetkez? elemeket:
--10001, 4220, Hajd?b?sz?rm?ny, Kossuth utca, 3
--10002, 4032, Debrecen, Apafi utca, 6
--10003, 1063, Budapest, Sz?v utca, 16
--10004, 1118, Budapest, Gazdagr?ti t?r, 3
--10005, 4032, Debrecen, Kassai ?t, 26
--10006, 1074, Budapest, Ak?cfa utca, 13


insert into cim values(10001, '4220', 'Hajd?b?sz?rm?ny', 'Kossuth utca', 3);
insert into cim values(10002, '4032', 'Debrecen', 'Apafi utca', 6);
insert into cim values(10003, '1063', 'Budapest', 'Sz?v utca', 16);
insert into cim values(10004, '1118', 'Budapest', 'Gazdagr?ti t?r', 3);
insert into cim values(10005, '4032', 'Debrecen', 'Kassai ?t', 26);
insert into cim values(10006, '1074', 'Budapest', 'Ak?cfa utca', 13);


alter table szemely
add constraint szemely_fk foreign key(cim) references cim(cim_azon);

--Hozzunnk l?tre egy kedvenc t?bl?t a k?vetkez? param?terekkel: kedvenc_azon number(5) -> els?dleges kulcs, gazda_azon number(5), 
--faj varchar2(15) -> ezek nem vehetnek fel null ?rt?ket,  nev varchar2(15), kor number(3). 

CREATE TABLE kedvenc(kedvenc_azon NUMBER(5) PRIMARY KEY NOT NULL,
                     gazda_azon NUMBER(5) NOT NULL,
                    faj VARCHAR2(15) NOT NULL,
                    nev VARCHAR2(15),
                    kor NUMBER(3));


--sz?rjuk be a k?vetkez? elemeket:
--201, 1, kutya, Fifi, 3
--202, 1, kutya, Bodri, 5
--203, 1, macska, Cila, ?
--204, 1, hal, ?, ?
--205, 2, kutya, Bl?ki, ?
--206, 2, macska, Duci, 5
--207, 3, mad?r, ?, 6
--208, 1, kutya, Nudli, 7
--209, 5, hal, ?, ?
--210, 5, hal, ?, ?
--211, 7, mad?r, ?, ?

insert into kedvenc values(201, 1, 'kutya', 'Fifi', 3);
insert into kedvenc values(202, 1, 'kutya', 'Bodri', 5);
insert into kedvenc values(203, 1, 'macska', 'Cila', '');
insert into kedvenc values(204, 1, 'hal', '', '');
insert into kedvenc values(205, 2, 'kutya', 'Bl?ki', '');
insert into kedvenc values(206, 2, 'macska', 'Duci', 5);
insert into kedvenc values(207, 3, 'mad?r', '', 6);
insert into kedvenc values(208, 1, 'kutya', 'Nudli', 7);
insert into kedvenc values(209, 5, 'hal', '', '');
insert into kedvenc values(210, 5, 'hal', '', '');
insert into kedvenc values(211, 7, 'mad?r', '', '');

  
select *
from kedvenc;
 
 --adjuk hozz? a k?vetkez? megszor?t?st:
--k?ls? kulcs gazda_azon -> szemely(szemely_azon)
ALTER TABLE kedvenc
ADD CONSTRAINT kedvenc_fk FOREIGN KEY(gazda_azon) REFERENCES szemely(szemely_azon);

commit;

--M?dos?tsuk a 7 azonos?t?j? szem?ly sz?let?si hely?t Debrecenre
update szemely
set szuletesi_hely='Debrecen'
where szemely_azon=7;

--k?rdezz?k le azokat a szem?lyeket, akiknek nincs kedvenc?k
select sz.vezeteknev, sz.keresztnev
from szemely sz left outer join kedvenc k
on sz.szemely_azon=k.gazda_azon
where k.kedvenc_azon is null;

--l?tezik-e olyan szem?ly, akinek 2-n?l t?bb kedvence van?
select gazda_azon, count(*)
from kedvenc
group by gazda_azon
having count(*)>2;

--hozzunk l?tre egy savepointot

savepoint first_sp;

--t?r?lj?k azokat a szem?lyeket a t?bl?b?l akik budapesten sz?lettek
delete from szemely
where SZULETESI_HELY = 'Budapest';

--adjunk a kedvencek t?bl?hoz egy oszlopot sz?n n?ven
alter table kedvenc
add (szin varchar2(20));

--?ll?tsuk be a fekete ?rt?ket a kedvenc t?bla sz?n oszlop?ba ahol nincs megadva a kedvenc kora ?s neve
UPDATE kedvenc
set szin='fekete' where kor is null and nev is null;

rollback first_sp;

--Az 1998 ut?n kiadott konyvek arat csokkentsuk a negyedere
--az oldalszamat emeljuk a dupl?j?ra.
create table konyv
as select * from konyvtar.konyv;

update konyv
set ar=ar/4, oldalszam=oldalszam*2
where to_date('1998', 'yyyy') <= kiadas_datuma;

--t?r?ljuk azokat a konyveket, amelyekhez nincs peldany
delete from konyv
where konyv_azon not in(select konyv_azon 
from KONYVTAR.konyvtari_konyv);

-- vegy?nk fel a konyvszerzp tablaba egy uj sort:
--M?ra Ferenc meg?rta a legdr?g?bb konyvet,
--ami?rt 15000ft honorariumot kapott.
create table konyvszerzo
as select* from KONYVTAR.konyvszerzo;

select szerzo_azon
from konyvtar.szerzo
where vezeteknev='M?ra' and keresztnev='Ferenc';

select konyv_azon, ar
from konyvtar.konyv
where ar in(select max(ar) from konyvtar.konyv);

insert into konyvszerzo(szerzo_azon, konyv_azon, honorarium)
select szerzo_azon, konyv_azon, 15000
from konyvtar.szerzo, konyvtar.konyv
where vezeteknev='Móra' and keresztnev='Ferenc' 
and ar in(select max(ar) from konyvtar.konyv);

--noveljuk meg azon szerzok honorariumat, akik 1930
--elott szulettek, az altaluk ?rt konyv aranak a 10-szeresevel
select szerzo_azon
from konyvtar.szerzo 
where szuletesi_datum<to_date('1930', 'yyyy');

UPDATE konyvszerzo ksz
set honorarium = honorarium +(select ar*10
                                from konyvtar.konyv k
                                where ksz.konyv_azon=k.konyv_azon)
    where ksz.szerzo_azon in(select szerzo_azon
                                from konyvtar.szerzo 
                                where szuletesi_datum<to_date('1930', 'yyyy'));
    
--modosoditsuk a konyszerzo tablat: az 1930 elott szuletett
--szerzok ?s azon konyvek eseten, amelyek ara tobb mint 
--5000 noveljuk meg a honorariumot a konyv aranak 70%-val
UPDATE konyvszerzo ksz
set honorarium = honorarium +(select ar*0.7
                                from konyvtar.konyv k
                                where ksz.konyv_azon=k.konyv_azon)
    where ksz.szerzo_azon in(select szerzo_azon
                                from konyvtar.szerzo 
                                where szuletesi_datum<to_date('1930', 'yyyy'))
    and ksz.konyv_azon in(select konyv_azon
                        from konyvtar.konyv
                        where ar>5000);
                        
-- modos?tsuk azoknak a konyvtari konyveknek az ?rt?k?t, amelyeknek az ?rt?ke nagyobb, mint a
--hozzatartozo konyv aranak 99%-a
--az eredeti erteket csokkenstuk azzal az ertekkel, amelyet ugy szamolunk ki
--hogy a konyv arat elosztjuk a kiadas datuma ota eltelt evek szamaval.
create table konyvtari_konyv as
select * from konyvtar.konyvtari_konyv;

select ar/months_between(sysdate, kiadas_datuma)/12
from konyvtar.konyv;

select ar*0.99
from konyvtar.konyv;

update konyvtari_konyv kk
set ertek = ertek - (select ar/months_between(sysdate, kiadas_datuma)/12
                        from konyvtar.konyv k
                        where k.konyv_azon = kk.konyv_azon)
where ertek > (select ar*0.99
                from konyvtar.konyv kv
                where kv.konyv_azon = kk.konyv_azon);

--modositsjuk azon tagok beiratkozasi datumat, akiknek a beiratkozasi datuma
--kesobbre esik mint a legelso kolcsonzesi datuma
--az uj beiratkozasi datuma legyen a legelso kolcsonzes datuma.
create table tag as
select * from konyvtar.tag;

update tag t
set beiratkozasi_datum = (select min(kolcsonzesi_datum)
                            from KONYVTAR.kolcsonzes kk
                            where kk.tag_azon = t.olvasojegyszam)
where beiratkozasi_datum>(select min(kolcsonzesi_datum)
                            from KONYVTAR.kolcsonzes kk
                            where kk.tag_azon = t.olvasojegyszam);

--kerdezzuk le aszokat a szmelyeket, akiknek nincs kedvence, keszitsunk nezetet
create view nincs_kedvence2 as
select vezeteknev, keresztnev
from kedvenc right outer join szemely
on kedvenc.gazda_azon = szemely.szemely_azon
where kedvenc.kedvenc_azon is null;

--adjunk lekerdezei jogosultsagot az "egyik" nevu felhasznalonak a konyv tablara
grant select on konyv to egyik;

--vegyuk el a jogosultsagot
revoke select on konyv to egyik;

--hozzunk letre nezetet, ami megmutatja, hogy egyes tagok
--mikor kolcsonoztek utoljara
create view utolsokolcsonzes as
select olvasojegyszam, vezeteknev, keresztnev, max(kolcsonzesi_datum) utolsokolcsonzes
from konyvtar.kolcsonzes kcs right outer join konyvtar.tag t
on kcs.tag_azon = t.olvasojegyszam
group by olvasojegyszam, vezeteknev, keresztnev;

--hozzunk letre nezetet, amely kilist?zza, hogy
--temankent melyik a legdragabb konyv
create view  legdargabb as
select konyv_azon, tema, ar, cim
from konyvtar.konyv 
where (tema, ar) in (select tema, max(ar)
                        from konyvtar.konyv 
                        group by tema);

--listazzuk ki a krimi temaju konyvek peldanyainak adatait
select *
from konyvtar.konyvtari_konyv kk
where exists (select *
                from konyvtar.konyv k
                where tema = 'krimi' and kk.konyv_azon = k.konyv_azon);

--listazzuk ki azon konyvek cimet, kiadojat ?s arat, amelyeknek
--egyetlen peldanya sincs a konyvtarban
select cim, kiado, ar
from konyvtar.konyv k
where not exists (select *
                    from KONYVTAR.konyvtari_konyv kk
                    where k.konyv_azon = kk.konyv_azon);

--listazzuk ki azon konyvek cimet, kiadojat es arat, amelyeknek van legalabb egy olyan
--peldanya ami tobbet er a konyv aranal
select cim, kiado, ar
from konyvtar.konyv k
where ar < any( select ertek
                from konyvtar.konyvtari_konyv kk
                where kk.konyv_azon = k.konyv_azon);

--hogy h?vj?k a legid?sebb olvaso(i)nkat?
select vezeteknev, keresztnev
from konyvtar.tag
where szuletesi_datum = (select min(szuletesi_datum)
                            from konyvtar.tag);

--listazzuk egy listaban a szerzok keresztnevet es szuletesi honapjat
--illetve a tagok keresztnevet es szuletesi honapjat, minden nev es honap parok annyiszor
--szerepeljen ahanyszor a tablaban elofordul
select keresztnev, to_char(szuletesi_datum, 'mm')
from konyvtar.szerzo
union all
select keresztnev, to_char(szuletesi_datum, 'mm')
from konyvtar.tag;

--listazzuk egy listaban a szerzok keresztnevet es szuletesi honapjat
--illetve a tagok keresztnevet es szuletesi honapjat, minden nev es honap paros
--csak egyszer szerepeljen
select keresztnev, to_char(szuletesi_datum, 'mm')
from konyvtar.szerzo
union
select keresztnev, to_char(szuletesi_datum, 'mm')
from konyvtar.tag;

--melyek azok a keresztnevek, amelyek szerzo keresztneve is es egyben valamelyik tage is
select sz.keresztnev
from konyvtar.tag t inner join konyvtar.szerzo sz
on t.keresztnev=sz.keresztnev;

select keresztnev
from konyvtar.szerzo
intersect
select keresztnev
from konyvtar.tag;

SELECT keresztnev FROM KONYVTAR.szerzo
WHERE keresztnev IN (SELECT keresztnev FROM KONYVTAR.tag);

--melyek azok a keresztnevek, amelyek valamelyik szerzo keresztneve, de egyetlen tag? sem
select keresztnev
from konyvtar.szerzo
minus
select keresztnev
from konyvtar.tag;

--tegyuk egy listaba a konyvek temait es arait ?s a konyvek kiadoit es arait
select tema, ar
from konyvtar.konyv
union
select kiado, ar
from konyvtar.konyv;

--listazzuk ki az elso 10 legidosebb tag nevet
select b.*, rownum
from(select vezeteknev, keresztnev, to_char(szuletesi_datum, 'yyyy.mm.dd')
        from konyvtar.tag
        order by szuletesi_datum) b
where rownum<11;

--listazzuk ki az elso 10 legdragabb konyvet
select a.*, rownum
from (select *
        from konyvtar.konyv
        order by ar desc nulls last) a
where rownum <11;

----kerdezzuk le azokat a szerzoket, akik benne vannak abban a listaban
--akik a 10 legnagyobb honorariumot kaptak
select  vezeteknev, keresztnev
from konyvtar.szerzo
where szerzo_azon in(select szerzo_azon
                        from (select *
                                from KONYVTAR.konyvszerzo
                                ORDER BY honorarium desc nulls last)
                                where rownum<11);

----hozzunk letre egy nezetet, amely a horror, sci-fi es krimi temaju konyvek cimet
--leltari szamat ?s oldalankenti arat tartalmazza
create view felelmeteskonyv as
select cim, leltari_szam, ar/oldalszam ar_per_oldal
from konyvtar.konyv k inner join konyvtar.konyvtari_konyv kk
on k.konyv_azon = kk.konyv_azon
where tema in('horror', 'sci-fi', 'krimi');

--hozzunk letre egy nezetet legidosebb_szerzo neven, amely a legidosebb
--szerzo nevet es szuletesi datumat tartalmazza
create view legidosebb_szerzo as
select vezeteknev || ' ' || keresztnev nev, to_char(szuletesi_datum, 'yyyy.mm.dd') születési_dátum
from konyvtar.szerzo
where szuletesi_datum=(select min(szuletesi_datum)
                        from konyvtar.szerzo);


--1 Listázzuk ki a versenyzõk nevét, és azt, hogy melyik országból származnak. 
--Listázzuk azokat az országokat is, amelyeknek nincs versenyzõjük.

select v.nev, o.orszag
from olimpia.o_versenyzok v right outer join OLIMPIA.o_orszagok o
on v.orszag_azon = o.azon;

--2 Keressük meg azon az Afrikai országok nevét és lakosságát, amelyeknek minden Európai országok lakosságától több lakosa van. 
--A lista lakosság szerint csökkenõen legyen rendezve.

select orszag, lakossag
from olimpia.o_orszagok
where foldresz = 'Afrika' and lakossag > all (select lakossag
                                            from olimpia.o_orszagok
                                            where foldresz = 'Európa')
order by lakossag desc;

-- 3 Írjunk olyan lekérdezést, amely az éremtáblát a következõ formában listázza. 
--A lista orszag szerint legyen rendezve.

select o.orszag, db, erem
from OLIMPIA.o_orszagok o, (select orszag_azon, arany db, 'arany' erem from OLIMPIA.o_erem_tabla
                                union all 
                                select orszag_azon, ezust db, 'ezust' erem from OLIMPIA.o_erem_tabla
                                union all
                                select orszag_azon, bronz db, 'bronz' erem from OLIMPIA.o_erem_tabla) erem
where o.azon = erem.orszag_azon
order by  o.orszag;

--orszag	        		Db	        Erem
--Afganisztán			0		ezust
--Afganisztán			1		bronz
--Afganisztán			0		arany
--Algéria				1		bronz
--Algéria				1		ezust
--Algéria				0		arany
--Amerikai Egyesült Államok	38		ezust
--Amerikai Egyesült Államok	36		arany
--Amerikai Egyesült Államok	36		bronz
--Argentína			2		arany
--Argentína			0		ezust
--Argentína			4		bronz



-- 4 Listázzuk ki a 3. legtöbb éremmel rendelkezõ(k) nevét/neveit, akik egyéniben indultak.

select v.nev, arany+ezust+bronz erem
from olimpia.o_versenyzok v inner join olimpia.o_orszagok o
on v.orszag_azon = o.azon inner join olimpia.o_erem_tabla e
on o.azon = e.orszag_azon
where egyen_csapat = 'e'
group by nev, arany+ezust+bronz
order by erem desc
offset 2 rows fetch next 1 row with ties;

-- 5 Hozzunk létre egy biztosítás nevü táblát, amely tartalmaz a biztosítás számát (pontosan 8 karakteres sztring, 
--ez az elsõdleges kulcs), a versenyzõ azonosítóját (legfeljebb 5 jegyû egész), az email címét (legfeljebb 40 karakteres sztring), 
--a biztosítást kezdetét és végét (dátumok), valamit a havi összeget (legfeljebb 5 jegyû egyész). 
--A tábla hivatkozzon a o_versenyzok táblára és a havi összeg ne legyen nagyobb 10000-nél, 
--az email cím kötelezõ legyen és nevezze el az elsõdleges kulcs megszorítását.

create table o_versenyzok as
select *
from OLIMPIA.o_versenyzok;

alter table o_versenyzok
add constraint pk_olimpia primary key(azon);

create table biztositas 
(biztositasi_szam char(8) constraint b_pk primary key,
versenyzo_azon number(5) constraint b_ref references o_versenyzok,
emial varchar2(40) constraint b_nn not null,
kezdete date,
vege date,
havi_osszeg number(5) constraint b_ch check (havi_osszeg<10000));

-- 7 Töröljük ki azokat a magyar eredményeket, ahol nincs helyezés vagy a helyezés az 30-diktõl rosszabb.
create table o_eredmenyek as
select *
from olimpia.o_eredmenyek;
delete from o_eredmenyek
where versenyzo_azon in (select azon from olimpia.o_versenyzok
                           where orszag_azon in (select azon from olimpia.o_orszagok
                                                    where orszag = 'Magyarország'))
                            and ((helyezes in null) or (helyezes >30));
                            
drop table o_eredmenyek; 

-- 8 Módosítsuk Michael Phelps 200 m pillangóúszásban elért helyezését 1. helyezésre.

update o_eredmenyek
set helyezes = 1
where versenyzo_azon in (select azon
                            from OLIMPIA.o_versenyzok
                            where olimpia.o_versenyzok.nev = 'Michael Phelps')
and versenyszam_azon in(select azon
                        from OLIMPIA.o_versenyszamok
                        where OLIMPIA.o_versenyszamok.versenyszam = '200 m pillangóúszás' and ferfi_noi ='férfi');

-- 9 Hozzunk létre nézetet legjobb_legrosszabb néven, amely az eredmények táblából versenyszámazonosítónként a legjobb és a legrosszabb helyezést írjuk ki, 
--de csak azokat, ahol a kettõ nem egyezik meg egymással. A lista legyen a legjobb eredmény szerint rendezve. 

create view legjobb_legrosszabb as
select versenyszam_azon, min(helyezes) legjobb, max(helyezes) legrosszabb
from o_eredmenyek
group by versenyszam_azon
having min(helyezes)<>max(helyezes)
order by min(helyezes);

-- 10 Vonjuk vissza a hivatkozási jogosultságot a user nevû felhasználótól az o_versenyzok egyen_csapat ás szul_hely oszlopairól.

revoke references (egyen_csapat, szul_hely)on o_versenyzok from user;

-- 11 Módosítsuk a biztositas tablat, dobjuk ez az email oszlopot.

alter table biztositas
drop column emial;

-- 12 Módosítsuk a biztositas tablat egy egy_havi_jovedelem oszloppal ami legfeljebb 7 jegyu számot tartalmazhat és ellenõrizze,
--hogy a benne szereplõ érték az 100000-nél nagyobb legyen.

alter table biztositas
add (egy_havi_jovedelem number(7)constraint h_ch check(egy_havi_jovedelem>100000))


