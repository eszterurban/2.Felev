-- Listázzuk ki a könyveket. A lista legyen ar szerint rendezett, 
-- és a null értékek elöl szerepeljenek.
select *
from konyvtar.konyv
order by ar nulls first;

-- Keressük azoknak a könyveknek a címét és árát, amelyeknek az 
-- ára 1000 és 3000 között van. A listát rendezzük ár, azon belül cím szerint.
select cim, ar
from konyvtar.konyv
where ar between 1000 and 3000
order by ar, cim;

-- Keressük azokat a könyveket, amelyek sci-fi témájúak 
--vagy olcsóbbak 1000-nél és oldalszámuk több, mint 200 vagy a Gondolat kiadó a kiadójuk.
select *
from konyvtar.konyv
where (tema = 'sci-fi' or ar< 1000) and (oldalszam>200 or kiado = 'Gondolat');

--Keressük azokat a könyveket, amelyeknek a címe nem a 'Re' sztringgel kezdõdik.
select *
from konyvtar.konyv
where cim not like 'Re%';

-- Listázzuk ki az 1980.03.02 elõtt született férfi tagok nevét és születési dátumát.
select vezeteknev, keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd')
from konyvtar.tag
where nem = 'f' and szuletesi_datum< to_date('1980.03.02', 'yyyy.mm.dd');

-- Azokat a tagokat keressük, akinek a nevében legalább kettõ 'e' betû
-- szerepel és igaz rájuk, hogy 40 évnél fiatalabbak vagy besorolásuk gyerek.
select *
from konyvtar.tag
where lower(vezeteknev || keresztnev) like '%e%e%' and (months_between (sysdate, szuletesi_datum)/12<40 or besorolas = 'gyerek');
 
--  Hány különbözõ téma van?
select count(distinct(tema))
from konyvtar.konyv;


-- Melyek azok a témák, amelyekben 3-nál több olyan könyvet 
-- adtak ki, amelyeknek az ára 1000 és 3000 között van?
select tema
from konyvtar.konyv
where ar BETWEEN 1000 and 3000
group by tema
having count(tema)>3;


-- Mi a 40 évesnél fiatalabb olvasók által kikölcsönzött könyvek leltári száma?
select k.leltari_szam
from konyvtar.tag t inner join konyvtar.kolcsonzes k
on t.olvasojegyszam = k.tag_azon
where months_between(sysdate, t.szuletesi_datum)/12<40;


-- Melyik olvasó fiatalabb Agatha Christie írótól?
select  t.vezeteknev || ' ' || t.keresztnev 
from KONYVTAR.szerzo sz , konyvtar.tag t
where sz.vezeteknev = 'Christie' and sz.keresztnev = 'Agatha' and sz.szuletesi_datum<t.szuletesi_datum;
 
-- Kik azok a tagok , akik egy példányt legalább kétszer kölcsönöztek ki?
select t.vezeteknev || ' ' || t.keresztnev 
from konyvtar.tag t inner join konyvtar.kolcsonzes k
on t.olvasojegyszam = k.tag_azon
group by k.tag_azon, k.leltari_szam, t.vezeteknev, t.keresztnev 
having count(k.kolcsonzesi_datum)>1;

-- Témánként mi a legdrágább árú könyv címe?
select cim
from konyvtar.konyv
where (tema, ar) in (select tema, max(ar)
from KONYVTAR.konyv
group by tema);

-- A krimi témájú könyvekbõl melyik a legdrágább?
select *
from konyvtar.konyv 
where tema = 'krimi' and ar in (select max(ar)
from konyvtar.konyv
where tema = 'krimi');
 
-- A nõi tagok között mi a legfiatalabb tagnak a neve?
select vezeteknev || ' ' || keresztnev 
from konyvtar.tag
where nem = 'n' and szuletesi_datum in (select max(szuletesi_datum)
from konyvtar.tag
where nem = 'n');


-- Melyik az a könyv, amely nem sci-fi, krimi és horror témájú, és 
--amelyhez több, mint 3 példány tartozik?
select cim
from konyvtar.konyv k inner join konyvtar.konyvtari_konyv kk
on k.konyv_azon = kk.konyv_azon
where tema not in ('horror', 'sci-fi', 'krimi')
group by k.cim, k.konyv_azon
having count(kk.leltari_szam)>3;

--1 Listázzuk ki a versenyzõk nevét, és azt, hogy melyik országból származnak. Listázzuk azokat az országokat is, amelyeknek nincs versenyzõjük.
select v.nev, o.orszag
from OLIMPIA.o_versenyzok v right outer join OLIMPIA.o_orszagok o
on v.orszag_azon = o.azon;


--2 Keressük meg azon az Afrikai országok nevét és lakosságát, amelyeknek minden Európai országok lakosságától több lakosa van. 
--A lista lakosság szerint csökkenõen legyen rendezve.
select orszag, lakossag
from OLIMPIA.o_orszagok
where lakossag > all(select lakossag
from OLIMPIA.o_orszagok
where foldresz = 'Európa')
and foldresz='Afrika'
order by lakossag;

-- 3 Írjunk olyan lekérdezést, amely az éremtáblát a következõ formában listázza. A lista orszag szerint legyen rendezve.
select o.orszag, db, erem
from olimpia.o_orszagok o, (select orszag_azon, arany db, 'arany' erem
from OLIMPIA.o_erem_tabla
union all
select orszag_azon, ezust db, 'ezüst' erem
from OLIMPIA.o_erem_tabla
union all
select orszag_azon, bronz db, 'bronz' erem
from OLIMPIA.o_erem_tabla) erem
where o.azon = erem.orszag_azon
order by o.orszag;

--Orszag	        		Db	        Erem
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
select v.nev, arany+ezust+bronz
from OLIMPIA.o_versenyzok v inner join olimpia.o_erem_tabla et
on v.orszag_azon = et.orszag_azon
where v.egyen_csapat = 'e'
group by v.nev, arany+ezust+bronz
order by arany+ezust+bronz desc
offset 2 ROWS fetch NEXT 1 row with ties;

-- 5 Hozzunk létre egy biztosítás nevü táblát, amely tartalmaz a biztosítás számát (pontosan 8 karakteres sztring, ez az elsõdleges kulcs), 
--a versenyzõ azonosítóját (legfeljebb 5 jegyû egész), az email címét (legfeljebb 40 karakteres sztring), a biztosítást kezdetét és végét (dátumok),
--valamit a havi összeget (legfeljebb 5 jegyû egyész). A tábla hivatkozzon a o_versenyzok táblára és a havi összeg ne legyen nagyobb 10000-nél,
--az email cím kötelezõ legyen és nevezze el az elsõdleges kulcs megszorítását.
create table o_versenyzo as
select *
from olimpia.o_versenyzok;

alter table o_versenyzo 
add constraint pk_versenyzok primary key(azon);

create table biztositas
(biztositasi_szam char(8) constraint biz_pk primary key,
versenyzo_azon number(5) constraint biz_fk references o_versenyzo,
email varchar2(40) constraint biz_nn not null, 
kezd date,
vege date,
összeg number(5) constraint biz_ch CHECK(összeg<10000));


-- 7 Töröljük ki azokat a magyar eredményeket, ahol nincs helyezés vagy a helyezés az 30-diktõl rosszabb.
create table eredmenyek as
select *
from OLIMPIA.o_eredmenyek;

drop table eredmenyek;

delete from eredmenyek 
where versenyzo_azon in (select azon
                            from olimpia.o_versenyzok
                            where helyezes is null or helyezes>30 and orszag_azon = (select azon
                                                                                    from olimpia.o_orszagok
                                                                                    where orszag='Magyarország'));

delete from eredmenyek
where versenyzo_azon in (select azon 
                        from olimpia.o_versenyzok 
                        where orszag_azon =(select azon 
                                            from olimpia.o_orszagok 
                                            where orszag= 'Magyarorszag'))
                        and (helyezes is null) or (helyezes>30);

-- 8 Módosítsuk Michael Phelps 200 m pillangóúszásban elért helyezését 1. helyezésre.
update eredmenyek
set helyezes = 1
where versenyzo_azon = (select azon
                        from olimpia.o_versenyzok
                        where nev='Michael Phelps')
and versenyszam_azon = (select azon
                        from OLIMPIA.o_versenyszamok
                        where versenyszam = '200 m pillangóúszás' and ferfi_noi = 'férfi');

-- 9 Hozzunk létre nézetet legjobb_legrosszabb néven, amely az eredmények táblából versenyszámazonosítónként a legjobb és a legrosszabb helyezést írjuk ki,
--de csak azokat, ahol a kettõ nem egyezik meg egymással. A lista legyen a legjobb eredmény szerint rendezve. 
create view legjobblegrosszabb as
select versenyzo_azon, min(helyezes) legjobb, max(helyezes) legrosszabb
from OLIMPIA.o_eredmenyek
group by versenyzo_azon
having min(helyezes)<>max(helyezes)
order by min(helyezes);


-- 10 Vonjuk vissza a hivatkozási jogosultságot a user nevû felhasználótól az o_versenyzok egyen_csapat ás szul_hely oszlopairól.
revoke REFERENCES(egyen_csapat, szul_hely) on o_versenyzok from user;


-- 11 Módosítsuk a biztositas tablat, dobjuk ez az email oszlopot.
alter table biztositas
drop COLUMN email;


-- 12 Módosítsuk a biztositas tablat egy egy_havi_jovedelem oszloppal ami legfeljebb 
--7 jegyu számot tartalmazhat és ellenõrizze, hogy a benne szereplõ érték az 100000-nél nagyobb legyen.
alter table biztositas
add egy_havi_jövedelem number(7) constraint biz_ch2 check(egy_havi_jövedelem>100000); 
