--1 Listázzuk ki a versenyzõk nevét, és azt, hogy melyik országból származnak. Listázzuk azokat az országokat is, amelyeknek nincs versenyzõjük.

select  v.nev, o.orszag
from olimpia.o_versenyzok v right outer join olimpia.o_orszagok o
on v.orszag_azon = o.azon;

--2 Keressük meg azon az Afrikai országok nevét és lakosságát, amelyeknek minden Európai országok lakosságától több lakosa van. 
--A lista lakosság szerint csökkenõen legyen rendezve.

select orszag, lakossag
from olimpia.o_orszagok
where foldresz = 'Afrika' and lakossag > --all
                                            (select max(lakossag)
                                            from olimpia.o_orszagok
                                            where foldresz = 'Európa');

-- 3 Írjunk olyan lekérdezést, amely az éremtáblát a következõ formában listázza. A lista orszag szerint legyen rendezve.

select orszag, db, erem
from olimpia.o_orszagok o,(select orszag_azon, arany db, 'arany' erem from olimpia.o_erem_tabla
union all
select orszag_azon, ezust db, 'ezust' erem from olimpia.o_erem_tabla
union all
select orszag_azon, bronz db, 'bronz' erem from olimpia.o_erem_tabla) erem
where o.azon=erem.orszag_azon
order by orszag;

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

select ver.azon, ver.nev, ezust+arany+bronz
from olimpia.o_versenyzok ver inner join OLIMPIA.o_orszagok orsz
on ver.orszag_azon = orsz.azon inner join OLIMPIA.o_erem_tabla erem
on orsz.azon = erem.orszag_azon
where ver.egyen_csapat='e'
group by ver.azon, ver.nev, ezust+arany+bronz
order by ezust+arany+bronz desc
offset 2 rows fetch next 1 row with ties;

-- 5 Hozzunk létre egy biztosítás nevü táblát, amely tartalmaz a biztosítás számát (pontosan 8 karakteres sztring, ez az elsõdleges kulcs), 
--a versenyzõ azonosítóját (legfeljebb 5 jegyû egész), az email címét (legfeljebb 40 karakteres sztring), a biztosítást kezdetét és végét (dátumok),
--valamit a havi összeget (legfeljebb 5 jegyû egyész). A tábla hivatkozzon a o_versenyzok táblára és a havi összeg ne legyen nagyobb 10000-nél,
--az email cím kötelezõ legyen és nevezze el az elsõdleges kulcs megszorítását.

create table o_versenyzo as
select *
from olimpia.o_versenyzok;

alter table o_versenyzo 
add constraint pk_versenyzok primary key(azon);

create table biztositas(
biztositasi_szam char(8) constraint biz_pk primary key,
versenyzo_azon number(5) constraint biz_fk references o_versenyzo,
email varchar2(40) constraint biz_nn not null,
kezdete date,
vege date,
havi_osszeg number(5) constraint biz_ck check(havi_osszeg<10000));

drop table biztositas;
drop table o_versenyzo;

-- 7 Töröljük ki azokat a magyar eredményeket, ahol nincs helyezés vagy a helyezés az 30-diktõl rosszabb.

create table o_eredmenyek as
select *
from olimpia.o_eredmenyek;

delete from o_eredmenyek
where versenyo_azon in (select azon from olimpia.o_versenyzok where orszag_azon =
                                        (select azon from olimpia.o_orszagok where orszag= 'Magyarorszag'))
and (helyezes is null) or (helyezes>30);

drop table o_eredmenyek;

-- 8 Módosítsuk Michael Phelps 200 m pillangóúszásban elért helyezését 1. helyezésre.

update o_eredmenyek
set helyezes = 1 
where versenyszam_azon = (select azon from olimpia.o_versenyszamok where versenyszam = '200 m pillangóúszás' and ferfi_noi = 'férfi')
and versenyzo_azon = (select azon from olimpia.o_versenyzok where nev = 'Michael Phelps');

-- 9 Hozzunk létre nézetet legjobb_legrosszabb néven, amely az eredmények táblából versenyszámazonosítónként a legjobb és a legrosszabb helyezést írjuk ki,
--de csak azokat, ahol a kettõ nem egyezik meg egymással. A lista legyen a legjobb eredmény szerint rendezve. 

create view legj_legr as
select versenyszam_azon, min(helyezes), max(helyezes)
from olimpia.o_eredmenyek
group by versenyszam_azon
having min(helyezes)<>max(helyezes)
order by min(helyezes) desc;

-- 10 Vonjuk vissza a hivatkozási jogosultságot a user nevû felhasználótól az o_versenyzok egyen_csapat ás szul_hely oszlopairól.

revoke references(egyen_csapat, szul_hely) on o_versenyzok from user;

-- 11 Módosítsuk a biztositas tablat, dobjuk ez az email oszlopot.

alter tabel biztositas
drop column email;

-- 12 Módosítsuk a biztositas tablat egy egy_havi_jovedelem oszloppal ami legfeljebb 
--7 jegyu számot tartalmazhat és ellenõrizze, hogy a benne szereplõ érték az 100000-nél nagyobb legyen.

alter table biztositas
add egy_havi_jov number(7) constraint biz_ch_2 check(egy_havi_jov>100000);


