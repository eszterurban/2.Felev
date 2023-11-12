--1 List�zzuk ki a versenyz�k nev�t, �s azt, hogy melyik orsz�gb�l sz�rmaznak. List�zzuk azokat az orsz�gokat is, amelyeknek nincs versenyz�j�k.

select  v.nev, o.orszag
from olimpia.o_versenyzok v right outer join olimpia.o_orszagok o
on v.orszag_azon = o.azon;

--2 Keress�k meg azon az Afrikai orsz�gok nev�t �s lakoss�g�t, amelyeknek minden Eur�pai orsz�gok lakoss�g�t�l t�bb lakosa van. 
--A lista lakoss�g szerint cs�kken�en legyen rendezve.

select orszag, lakossag
from olimpia.o_orszagok
where foldresz = 'Afrika' and lakossag > --all
                                            (select max(lakossag)
                                            from olimpia.o_orszagok
                                            where foldresz = 'Eur�pa');

-- 3 �rjunk olyan lek�rdez�st, amely az �remt�bl�t a k�vetkez� form�ban list�zza. A lista orszag szerint legyen rendezve.

select orszag, db, erem
from olimpia.o_orszagok o,(select orszag_azon, arany db, 'arany' erem from olimpia.o_erem_tabla
union all
select orszag_azon, ezust db, 'ezust' erem from olimpia.o_erem_tabla
union all
select orszag_azon, bronz db, 'bronz' erem from olimpia.o_erem_tabla) erem
where o.azon=erem.orszag_azon
order by orszag;

--Orszag	        		Db	        Erem
--Afganiszt�n			0		ezust
--Afganiszt�n			1		bronz
--Afganiszt�n			0		arany
--Alg�ria				1		bronz
--Alg�ria				1		ezust
--Alg�ria				0		arany
--Amerikai Egyes�lt �llamok	38		ezust
--Amerikai Egyes�lt �llamok	36		arany
--Amerikai Egyes�lt �llamok	36		bronz
--Argent�na			2		arany
--Argent�na			0		ezust
--Argent�na			4		bronz



-- 4 List�zzuk ki a 3. legt�bb �remmel rendelkez�(k) nev�t/neveit, akik egy�niben indultak.

select ver.azon, ver.nev, ezust+arany+bronz
from olimpia.o_versenyzok ver inner join OLIMPIA.o_orszagok orsz
on ver.orszag_azon = orsz.azon inner join OLIMPIA.o_erem_tabla erem
on orsz.azon = erem.orszag_azon
where ver.egyen_csapat='e'
group by ver.azon, ver.nev, ezust+arany+bronz
order by ezust+arany+bronz desc
offset 2 rows fetch next 1 row with ties;

-- 5 Hozzunk l�tre egy biztos�t�s nev� t�bl�t, amely tartalmaz a biztos�t�s sz�m�t (pontosan 8 karakteres sztring, ez az els�dleges kulcs), 
--a versenyz� azonos�t�j�t (legfeljebb 5 jegy� eg�sz), az email c�m�t (legfeljebb 40 karakteres sztring), a biztos�t�st kezdet�t �s v�g�t (d�tumok),
--valamit a havi �sszeget (legfeljebb 5 jegy� egy�sz). A t�bla hivatkozzon a o_versenyzok t�bl�ra �s a havi �sszeg ne legyen nagyobb 10000-n�l,
--az email c�m k�telez� legyen �s nevezze el az els�dleges kulcs megszor�t�s�t.

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

-- 7 T�r�lj�k ki azokat a magyar eredm�nyeket, ahol nincs helyez�s vagy a helyez�s az 30-dikt�l rosszabb.

create table o_eredmenyek as
select *
from olimpia.o_eredmenyek;

delete from o_eredmenyek
where versenyo_azon in (select azon from olimpia.o_versenyzok where orszag_azon =
                                        (select azon from olimpia.o_orszagok where orszag= 'Magyarorszag'))
and (helyezes is null) or (helyezes>30);

drop table o_eredmenyek;

-- 8 M�dos�tsuk Michael Phelps 200 m pillang��sz�sban el�rt helyez�s�t 1. helyez�sre.

update o_eredmenyek
set helyezes = 1 
where versenyszam_azon = (select azon from olimpia.o_versenyszamok where versenyszam = '200 m pillang��sz�s' and ferfi_noi = 'f�rfi')
and versenyzo_azon = (select azon from olimpia.o_versenyzok where nev = 'Michael Phelps');

-- 9 Hozzunk l�tre n�zetet legjobb_legrosszabb n�ven, amely az eredm�nyek t�bl�b�l versenysz�mazonos�t�nk�nt a legjobb �s a legrosszabb helyez�st �rjuk ki,
--de csak azokat, ahol a kett� nem egyezik meg egym�ssal. A lista legyen a legjobb eredm�ny szerint rendezve. 

create view legj_legr as
select versenyszam_azon, min(helyezes), max(helyezes)
from olimpia.o_eredmenyek
group by versenyszam_azon
having min(helyezes)<>max(helyezes)
order by min(helyezes) desc;

-- 10 Vonjuk vissza a hivatkoz�si jogosults�got a user nev� felhaszn�l�t�l az o_versenyzok egyen_csapat �s szul_hely oszlopair�l.

revoke references(egyen_csapat, szul_hely) on o_versenyzok from user;

-- 11 M�dos�tsuk a biztositas tablat, dobjuk ez az email oszlopot.

alter tabel biztositas
drop column email;

-- 12 M�dos�tsuk a biztositas tablat egy egy_havi_jovedelem oszloppal ami legfeljebb 
--7 jegyu sz�mot tartalmazhat �s ellen�rizze, hogy a benne szerepl� �rt�k az 100000-n�l nagyobb legyen.

alter table biztositas
add egy_havi_jov number(7) constraint biz_ch_2 check(egy_havi_jov>100000);


