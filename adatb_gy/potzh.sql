-- List�zzuk ki a k�nyveket. A lista legyen ar szerint rendezett, 
-- �s a null �rt�kek el�l szerepeljenek.
select *
from konyvtar.konyv
order by ar nulls first;

-- Keress�k azoknak a k�nyveknek a c�m�t �s �r�t, amelyeknek az 
-- �ra 1000 �s 3000 k�z�tt van. A list�t rendezz�k �r, azon bel�l c�m szerint.
select cim, ar
from konyvtar.konyv
where ar between 1000 and 3000
order by ar, cim;

-- Keress�k azokat a k�nyveket, amelyek sci-fi t�m�j�ak 
--vagy olcs�bbak 1000-n�l �s oldalsz�muk t�bb, mint 200 vagy a Gondolat kiad� a kiad�juk.
select *
from konyvtar.konyv
where (tema = 'sci-fi' or ar< 1000) and (oldalszam>200 or kiado = 'Gondolat');

--Keress�k azokat a k�nyveket, amelyeknek a c�me nem a 'Re' sztringgel kezd�dik.
select *
from konyvtar.konyv
where cim not like 'Re%';

-- List�zzuk ki az 1980.03.02 el�tt sz�letett f�rfi tagok nev�t �s sz�let�si d�tum�t.
select vezeteknev, keresztnev, to_char(szuletesi_datum,'yyyy.mm.dd')
from konyvtar.tag
where nem = 'f' and szuletesi_datum< to_date('1980.03.02', 'yyyy.mm.dd');

-- Azokat a tagokat keress�k, akinek a nev�ben legal�bb kett� 'e' bet�
-- szerepel �s igaz r�juk, hogy 40 �vn�l fiatalabbak vagy besorol�suk gyerek.
select *
from konyvtar.tag
where lower(vezeteknev || keresztnev) like '%e%e%' and (months_between (sysdate, szuletesi_datum)/12<40 or besorolas = 'gyerek');
 
--  H�ny k�l�nb�z� t�ma van?
select count(distinct(tema))
from konyvtar.konyv;


-- Melyek azok a t�m�k, amelyekben 3-n�l t�bb olyan k�nyvet 
-- adtak ki, amelyeknek az �ra 1000 �s 3000 k�z�tt van?
select tema
from konyvtar.konyv
where ar BETWEEN 1000 and 3000
group by tema
having count(tema)>3;


-- Mi a 40 �vesn�l fiatalabb olvas�k �ltal kik�lcs�nz�tt k�nyvek lelt�ri sz�ma?
select k.leltari_szam
from konyvtar.tag t inner join konyvtar.kolcsonzes k
on t.olvasojegyszam = k.tag_azon
where months_between(sysdate, t.szuletesi_datum)/12<40;


-- Melyik olvas� fiatalabb Agatha Christie �r�t�l?
select  t.vezeteknev || ' ' || t.keresztnev 
from KONYVTAR.szerzo sz , konyvtar.tag t
where sz.vezeteknev = 'Christie' and sz.keresztnev = 'Agatha' and sz.szuletesi_datum<t.szuletesi_datum;
 
-- Kik azok a tagok , akik egy p�ld�nyt legal�bb k�tszer k�lcs�n�ztek ki?
select t.vezeteknev || ' ' || t.keresztnev 
from konyvtar.tag t inner join konyvtar.kolcsonzes k
on t.olvasojegyszam = k.tag_azon
group by k.tag_azon, k.leltari_szam, t.vezeteknev, t.keresztnev 
having count(k.kolcsonzesi_datum)>1;

-- T�m�nk�nt mi a legdr�g�bb �r� k�nyv c�me?
select cim
from konyvtar.konyv
where (tema, ar) in (select tema, max(ar)
from KONYVTAR.konyv
group by tema);

-- A krimi t�m�j� k�nyvekb�l melyik a legdr�g�bb?
select *
from konyvtar.konyv 
where tema = 'krimi' and ar in (select max(ar)
from konyvtar.konyv
where tema = 'krimi');
 
-- A n�i tagok k�z�tt mi a legfiatalabb tagnak a neve?
select vezeteknev || ' ' || keresztnev 
from konyvtar.tag
where nem = 'n' and szuletesi_datum in (select max(szuletesi_datum)
from konyvtar.tag
where nem = 'n');


-- Melyik az a k�nyv, amely nem sci-fi, krimi �s horror t�m�j�, �s 
--amelyhez t�bb, mint 3 p�ld�ny tartozik?
select cim
from konyvtar.konyv k inner join konyvtar.konyvtari_konyv kk
on k.konyv_azon = kk.konyv_azon
where tema not in ('horror', 'sci-fi', 'krimi')
group by k.cim, k.konyv_azon
having count(kk.leltari_szam)>3;

--1 List�zzuk ki a versenyz�k nev�t, �s azt, hogy melyik orsz�gb�l sz�rmaznak. List�zzuk azokat az orsz�gokat is, amelyeknek nincs versenyz�j�k.
select v.nev, o.orszag
from OLIMPIA.o_versenyzok v right outer join OLIMPIA.o_orszagok o
on v.orszag_azon = o.azon;


--2 Keress�k meg azon az Afrikai orsz�gok nev�t �s lakoss�g�t, amelyeknek minden Eur�pai orsz�gok lakoss�g�t�l t�bb lakosa van. 
--A lista lakoss�g szerint cs�kken�en legyen rendezve.
select orszag, lakossag
from OLIMPIA.o_orszagok
where lakossag > all(select lakossag
from OLIMPIA.o_orszagok
where foldresz = 'Eur�pa')
and foldresz='Afrika'
order by lakossag;

-- 3 �rjunk olyan lek�rdez�st, amely az �remt�bl�t a k�vetkez� form�ban list�zza. A lista orszag szerint legyen rendezve.
select o.orszag, db, erem
from olimpia.o_orszagok o, (select orszag_azon, arany db, 'arany' erem
from OLIMPIA.o_erem_tabla
union all
select orszag_azon, ezust db, 'ez�st' erem
from OLIMPIA.o_erem_tabla
union all
select orszag_azon, bronz db, 'bronz' erem
from OLIMPIA.o_erem_tabla) erem
where o.azon = erem.orszag_azon
order by o.orszag;

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
select v.nev, arany+ezust+bronz
from OLIMPIA.o_versenyzok v inner join olimpia.o_erem_tabla et
on v.orszag_azon = et.orszag_azon
where v.egyen_csapat = 'e'
group by v.nev, arany+ezust+bronz
order by arany+ezust+bronz desc
offset 2 ROWS fetch NEXT 1 row with ties;

-- 5 Hozzunk l�tre egy biztos�t�s nev� t�bl�t, amely tartalmaz a biztos�t�s sz�m�t (pontosan 8 karakteres sztring, ez az els�dleges kulcs), 
--a versenyz� azonos�t�j�t (legfeljebb 5 jegy� eg�sz), az email c�m�t (legfeljebb 40 karakteres sztring), a biztos�t�st kezdet�t �s v�g�t (d�tumok),
--valamit a havi �sszeget (legfeljebb 5 jegy� egy�sz). A t�bla hivatkozzon a o_versenyzok t�bl�ra �s a havi �sszeg ne legyen nagyobb 10000-n�l,
--az email c�m k�telez� legyen �s nevezze el az els�dleges kulcs megszor�t�s�t.
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
�sszeg number(5) constraint biz_ch CHECK(�sszeg<10000));


-- 7 T�r�lj�k ki azokat a magyar eredm�nyeket, ahol nincs helyez�s vagy a helyez�s az 30-dikt�l rosszabb.
create table eredmenyek as
select *
from OLIMPIA.o_eredmenyek;

drop table eredmenyek;

delete from eredmenyek 
where versenyzo_azon in (select azon
                            from olimpia.o_versenyzok
                            where helyezes is null or helyezes>30 and orszag_azon = (select azon
                                                                                    from olimpia.o_orszagok
                                                                                    where orszag='Magyarorsz�g'));

delete from eredmenyek
where versenyzo_azon in (select azon 
                        from olimpia.o_versenyzok 
                        where orszag_azon =(select azon 
                                            from olimpia.o_orszagok 
                                            where orszag= 'Magyarorszag'))
                        and (helyezes is null) or (helyezes>30);

-- 8 M�dos�tsuk Michael Phelps 200 m pillang��sz�sban el�rt helyez�s�t 1. helyez�sre.
update eredmenyek
set helyezes = 1
where versenyzo_azon = (select azon
                        from olimpia.o_versenyzok
                        where nev='Michael Phelps')
and versenyszam_azon = (select azon
                        from OLIMPIA.o_versenyszamok
                        where versenyszam = '200 m pillang��sz�s' and ferfi_noi = 'f�rfi');

-- 9 Hozzunk l�tre n�zetet legjobb_legrosszabb n�ven, amely az eredm�nyek t�bl�b�l versenysz�mazonos�t�nk�nt a legjobb �s a legrosszabb helyez�st �rjuk ki,
--de csak azokat, ahol a kett� nem egyezik meg egym�ssal. A lista legyen a legjobb eredm�ny szerint rendezve. 
create view legjobblegrosszabb as
select versenyzo_azon, min(helyezes) legjobb, max(helyezes) legrosszabb
from OLIMPIA.o_eredmenyek
group by versenyzo_azon
having min(helyezes)<>max(helyezes)
order by min(helyezes);


-- 10 Vonjuk vissza a hivatkoz�si jogosults�got a user nev� felhaszn�l�t�l az o_versenyzok egyen_csapat �s szul_hely oszlopair�l.
revoke REFERENCES(egyen_csapat, szul_hely) on o_versenyzok from user;


-- 11 M�dos�tsuk a biztositas tablat, dobjuk ez az email oszlopot.
alter table biztositas
drop COLUMN email;


-- 12 M�dos�tsuk a biztositas tablat egy egy_havi_jovedelem oszloppal ami legfeljebb 
--7 jegyu sz�mot tartalmazhat �s ellen�rizze, hogy a benne szerepl� �rt�k az 100000-n�l nagyobb legyen.
alter table biztositas
add egy_havi_j�vedelem number(7) constraint biz_ch2 check(egy_havi_j�vedelem>100000); 
