--List�zzuk ki azokat az orsz�gokat, ahol a lakoss�g kevesebb, 
--mint 10 milli� f�. 
--A lista lakoss�g szerint n�vekv�en legyen rendezve.
select *
from olimpia.o_orszagok
where lakossag <10000000
order by lakossag asc;

--List�zzuk ki azokat az orsz�gokat, amelyek ter�lete 0.
select *
from olimpia.o_orszagok
where terulet = 0;

--List�zzuk ki azoknak az orsz�goknak a nev�t, a f�v�ros�t, 
--a lakoss�g�t, a ter�let�t �s a n�ps�r�s�g�t, 
--ahol a lakoss�g kevesebb, mint 10 milli�. 
--A lista lakoss�g szerint cs�kken�en legyen rendezve.
select orszag, fovaros, lakossag, terulet, lakossag/terulet as neps�r�seg
from olimpia.o_orszagok
where lakossag <10000000 and terulet <>0
order by lakossag desc;

--List�zzuk ki azoknak az orsz�goknak az adatait,
--ahol nincs megadva mennyi az orsz�g ter�lete.
select *
from olimpia.o_orszagok
where terulet is null;

--List�zzuk ki azoknak az orsz�goknak az adatait, 
--ahol meg van adva mennyi az orsz�g ter�lete.
select *
from olimpia.o_orszagok
where terulet is not null;

--List�zzuk ki Magyarorsz�g, K�na, �s Jap�n adatait.
select *
from olimpia.o_orszagok
where orszag in ('K�na', 'Jap�n', 'Magyarorsz�g');

--List�zzuk ki az �sszes orsz�g adatait, kiv�ve Magyarorsz�got,
--K�n�t, �s Jap�nt.
select *
from olimpia.o_orszagok
where orszag not in ('K�na', 'Jap�n', 'Magyarorsz�g');

--List�zzuk ki azoknak az orsz�goknak a nev�t, 
--a f�v�ros�t �s a ter�let�t, ahol a ter�let 
--100 �s 1000 km2 k�z�tt van. 
--A lista ter�let szerint legyen rendezve.
select orszag, fovaros, terulet
from olimpia.o_orszagok
where terulet between 100 and 1000
order by terulet;

--List�zzuk ki azokat az orsz�gokat, 
--amelyek neve A bet�vel kezd�dik.
select *
from olimpia.o_orszagok
where orszag like 'A%';

--List�zzuk ki azokat az orsz�gokat, 
--amelyek neve A bet�vel kezd�dik, �s a 3. bet�je e bet�.
select *
from olimpia.o_orszagok
where orszag like 'A_e%';

--List�zzuk ki azon egy�ni versenyz�k adatait, 
--akiknek az orsz�gazonos�t�juk 131, �s Debrecenben sz�lettek.
select *
from olimpia.o_versenyzok
where orszag_azon = '131' and szul_hely = 'Debrecen' and egyen_csapat = 'e';

--List�zzuk azon versenyz�k adatait, akik Egerben sz�lettek
--vagy a nev�kben k�t 'e' bet� van (mindegy, hogy nagy vagy kicsi).
select *
from olimpia.o_versenyzok
where (szul_hely = 'Eger') or (lower(nev)like '%e%e%');

--List�zzuk ki azon versenyz�k adatait, 
--akiknek nincs megadva a sz�let�si hely�k, 
--az orsz�gazonos�t�juk 4, 
--�s az egyen_csapat oszlopban nem 'c' bet� szerepel.
select *
from olimpia.o_versenyzok
where szul_hely is null and orszag_azon = '4' and egyen_csapat != 'c';

--List�zzuk ki azon csapatok adatait a versenyz�k t�bl�b�l, akiknek az 
--orsz�gazonos�t�juk 4 vagy 131 vagy 15 vagy 23.
select *
from olimpia.o_versenyzok
where egyen_csapat = 'c' and orszag_azon = 4 or orszag_azon = 131 or orszag_azon = 15 or orszag_azon = 23;

select *
from olimpia.o_versenyzok
where (egyen_csapat='c') and (orszag_azon=4) or (orszag_azon=131)
or (orszag_azon=15) or (orszag_azon=23);

--List�zzuk ki az �remt�bl�b�l azokat az orsz�gazonos�t�kat, 
--ahol 5 �s 10 k�z�tti arany sz�letett. 
--A lista az arany eredm�nyek szerint legyen rendezett.
select orszag_azon
from olimpia.o_erem_tabla
where arany between 5 and 10
order by arany;

--List�zzuk ki az �rem t�bl�b�l azokat az orsz�gazonos�t�kat, 
--ahol vagy 2 ez�st�t vagy 1 bronzot nyertek.
select orszag_azon
from olimpia.o_erem_tabla
where ezust = 2 or bronz = 1;

--List�zzuk ki az �rem t�bl�b�l azokat az orsz�gazonos�t�kat,
--amelyekn�l az �rmek �sszege t�bb, mint 15.
select orszag_azon
from olimpia.o_erem_tabla
where arany+ bronz+ ezust>15;

--A h�t melyik napj�n sz�letett Cseh L�szl�?
select to_char (szul_dat, 'Day')
from olimpia.o_versenyzok
where nev = 'Cseh L�szl�';

--A h�t melyik napj�ra esik esik 2008. szeptember 22?
select to_char(to_date('2008.09.22', 'yyyy.mm.dd'), 'Day')
from dual;

--List�zzuk ki az �rem t�bl�b�l azokat az orsz�gazonos�t�kat,
--amelyekn�l t�bb arany �rem van, mint bronz. 
--A lista az arany�rmek szerint cs�kken�en legyen rendezve.
select orszag_azon
from OLIMPIA.o_erem_tabla
where arany>bronz
order by arany desc;

--K�rdezz�k le az orsz�gok t�bl�b�l Magyarorsz�g adatait.
select *
from olimpia.o_orszagok
where orszag='Magyarorsz�g';

--List�zzuk ki azokat az orsz�gokat, 
--ahol a f�v�ros B bet�vel kezd�dik, �s n�gy bet�b�l �ll.
select *
from olimpia.o_orszagok
where fovaros like 'B___';

--List�zzuk ki azokat a f�rfi versenysz�mokat, 
--amelyekn�l a sport�gazonos�t� 328 �s 
--azokat a n�i versenysz�mokat, ahol a sport�gazonos�t� 314.
select *
from olimpia.o_versenyszamok
where (ferfi_noi = 'f�rfi' and sportag_azon = '328') or (ferfi_noi = 'n�i' and sportag_azon = '314');

--List�zzuk ki azokat a versenyz�ket, 
--akiknek vagy a neve A-val kezd�dik �s 
--van egy 'd' bet� benne, �s az orsz�gazonos�t�juk 131; 
--vagy 20 �vesn�l fiatalabbak.
select *
from olimpia.o_versenyzok
where ((nev like 'A%' or lower(nev) like '%d%') and orszag_azon = '131') or months_between(sysdate, szul_dat)/12 <20;

--A h�t melyik napja lesz 10 nap m�lva?
select to_char(sysdate+10, 'Day')
from dual;

--Aki 1987. febru�r 12-�n sz�letett, az most h�ny napos?
select sysdate - to_date('1987.02.12', 'yyyy.mm.dd')
from dual;

--Aki 1987. febru�r 12-�n sz�letett, az most h�ny �r�s?
select (sysdate - to_date('1987.02.12', 'yyyy.mm.dd'))*24
from dual;

--Aki 1987. febru�r 12-�n sz�letett, az most h�ny h�napos?
select months_between (sysdate, to_date('1987.02.12', 'yyyy.mm.dd'))
from dual;

--List�zzuk ki azokat a versenyz�ket, akiknek a nev�ben 2 'e'
--bet� szerepel vagy 20 �s 21 �v k�z�ttiek.
select *
from olimpia.o_versenyzok
where lower(nev) like '%e%e%' or (months_between(sysdate, szul_dat)/12) between 20 and 21;

--List�zzuk ki az versenyz�k t�bl�b�l azokat a csapatokat, 
--akiknek az orsz�gazonos�t�juk 4 �s azokat az egy�neket,
--akik Debrecenben sz�lettek.
select *
from olimpia.o_versenyzok
where (egyen_csapat = 'c' and orszag_azon = '4') or (egyen_csapat = 'e' and szul_hely = 'Debrecen');

--A 10 milli�n�l nagyobb lakoss�g� orsz�gokat sz�moljuk meg, 
--�rjuk ki a legkisebb �s a legnagyobb ter�letet, 
--adjuk �ssze a lakoss�gok sz�m�t �s 
--�tlagoljuk a lakoss�gok sz�m�t.
select count(*), min(terulet), max(terulet), sum(lakossag), avg(lakossag)
from olimpia.o_orszagok
where lakossag>10000000;

--List�zzuk ki azokat az orsz�gokat, ahol nincs megadva 
--a f�ldr�sz.
select *
from olimpia.o_orszagok
where foldresz is null;

--F�ldr�szenk�nt �rjuk ki az orsz�gok sz�m�t, 
--a legnagyobb �s legkisebb ter�letet, 
--a lakosok �sszeg�t �s �tlag�t.
select count(*), min(terulet), max(terulet), sum(lakossag), avg(lakossag)
from olimpia.o_orszagok
group by foldresz;

--Az eredm�nyek t�bl�b�l versenysz�mazonos�t�nk�nt a legjobb 
--�s a legrosszabb helyez�st �rjuk ki.
select versenyszam_azon, min(helyezes), max(helyezes)
from olimpia.o_eredmenyek
group by versenyszam_azon;

--Az eredm�nyek t�bl�b�l versenysz�mazonos�t�nk�nt a legjobb 
--�s a legrosszabb helyez�st �rjuk ki, de csak azokat,
--ahol a kett� nem egyezik meg egym�ssal.
--A lista legyen a legjobb eredm�ny szerint rendezve.
select versenyszam_azon, min(helyezes), max(helyezes)
from olimpia.o_eredmenyek
group by versenyszam_azon
having min(helyezes) != max(helyezes)
order by min(helyezes);

--Sz�moljuk meg, hogy sport�gazonos�t�nk�nt h�ny versenysz�m van.
select count(*), sportag_azon
from olimpia.o_versenyszamok
group by sportag_azon;

--Sz�moljuk meg, hogy sport�gazonos�t�nk�nt h�ny versenysz�m van.
--K�l�nb�ztess�k meg ezt a f�rfiakn�l �s a n�kn�l.
select ferfi_noi, sportag_azon, count(*)
from olimpia.o_versenyszamok
group by ferfi_noi, sportag_azon;

--Sz�moljuk meg, hogy sport�gazonos�t�nk�nt h�ny versenysz�m van.
--K�l�nb�ztess�k meg ezt a f�rfiakn�l �s a n�kn�l, 
--�s csak a f�rfiakra vonatkoz�t list�zzuk ki.
select sportag_azon, count(*), ferfi_noi
from olimpia.o_versenyszamok
group by ferfi_noi, sportag_azon
having ferfi_noi = 'f�rfi';

--Keress�k meg azokat az orsz�gazonos�t�kat, amelyek a versenyz�k
--t�bl�ban 3-n�l t�bbsz�r szerepelnek. (azon orsz�gazonos�t�k, 
--ahol 3-n�l t�bb versenyz� indult.)
select orszag_azon, count(orszag_azon)
from olimpia.o_versenyzok
group by orszag_azon
having count(orszag_azon)>3;

--Sz�moljuk meg, hogy az egyes sz�let�si helyekr�l 
--h�ny versenyz� indult.
select count(*), szul_hely
from OLIMPIA.o_versenyzok
group by szul_hely;

--Csoportos�tsuk az orsz�gokat kezd�bet� alapj�n, �s 
--sz�moljuk meg, hogy az egyes kezd�bet�kh�z 
--h�ny orsz�g tartozik.
select count(*), substr(orszag, 1,1) betu
from olimpia.o_orszagok
group by substr(orszag, 1,1);

--Csoportos�tsuk az orsz�gokat kezd�bet� alapj�n, �s 
--sz�moljuk meg, hogy az egyes kezd�bet�kh�z h�ny orsz�g tartozik.
--Csak azokat list�zzuk, ahol 10-n�l t�bb orsz�g van.
select count(*), substr(orszag, 1,1) betu
from olimpia.o_orszagok
group by substr(orszag, 1,1)
having count(*)>10;

--Csoportos�tsuk az eur�pai orsz�gokat kezd�bet� alapj�n, 
--�s sz�moljuk meg, hogy az egyes kezd�bet�kh�z h�ny orsz�g tartozik. 
--Csak azokat list�zzuk, ahol 5-n�l t�bb orsz�g van. 
--Az eredm�nyt az orsz�gok sz�ma szerint rendezz�k.
select count(*), substr(orszag, 1,1) betu
from olimpia.o_orszagok
where foldresz = 'Eur�pa'
group by substr(orszag, 1,1)
having count(*)>5
order by count(*);

--List�zzuk ki f�ldr�szenk�nt az orsz�gok ter�let�nek �sszeg�t 
--�s az �tlagos n�ps�r�s�get.
select sum(terulet), foldresz, avg(lakossag/terulet)
from olimpia.o_orszagok
where terulet !=0
group by foldresz;

--Az eredm�nyek t�bl�b�l versenysz�mazonos�t�nk�nt k�rj�k le a 
--legjobb �s a legrosszabb helyez�st, de csak azokat, ahol a 
--legrosszabb helyez�s a 10-t�l kisebb.
select versenyszam_azon, min(helyezes), max(helyezes)
from olimpia.o_eredmenyek
group by versenyszam_azon
having max(helyezes)<10;

--Sz�moljuk meg, orsz�gazonos�t�nk�nt h�ny versenyz� szerepel a 
--versenyz� t�bl�ban, de csak azokat �rjuk ki, 
--ahol 10-n�l t�bb versenyz� van.
select orszag_azon, count(*)
from OLIMPIA.o_versenyzok
group by orszag_azon
having count(*)>10;

--List�zzuk ki azokat a versenyz�ket, akik Debrecenben sz�lettek
--vagy 20 �vesn�l fiatalabbak. 
--A lista a sz�let�si d�tum szerint legyen rendezve.
select *
from olimpia.o_versenyzok
where szul_hely = 'Debrecen' or months_between(sysdate, szul_dat)/12<20
order by szul_dat;

--Sz�moljuk meg, h�ny versenysz�m tartozik a 304, 324, 
--�s a 328-as sport�gakhoz.
select count(*), sportag_azon
from olimpia.o_versenyszamok
where sportag_azon in ('304', '324','328')
group by sportag_azon;

--�tlagosan h�ny f�sek a csapatok?
select avg(count(*))
from olimpia.o_csapattagok
group by csapat_azon;

--K�rdezz�k le az afrikai orsz�gok ter�let�t. 
--Ahol nincs adat, ott 0-�t �rjuk ki.
select orszag, nvl(terulet, 0)
from olimpia.o_orszagok
where foldresz = 'Afrika';

--Magyarorsz�g egy�ni versenyz�inek a nev�t �s sz�let�si d�tum�t
--list�zzuk ki sz�let�si id� szerint cs�kken�en rendezve.
select v.nev, v.szul_dat
from olimpia.o_versenyzok v inner join olimpia.o_orszagok o
on v.orszag_azon = o.azon
where o.orszag = 'Magyarorsz�g' and v.egyen_csapat = 'e'
order by v.szul_dat;

--List�zzuk ki a sport�gakat �s a hozz�juk tartoz� 
--versenysz�mokat sport�gak �s versenysz�mok szerint rendezve.
select *
from OLIMPIA.o_sportagak s inner join OLIMPIA.o_versenyszamok v
on s.azon = v.sportag_azon
order by s.nev, v.versenyszam;

--List�zzuk ki a n�i Kajak-kenu sport�ghoz tartoz� 
--versenysz�mokat.
select *
from olimpia.o_versenyszamok v inner join olimpia.o_sportagak s
on v.sportag_azon = s.azon
where s.nev = 'Kajak-kenu' and v.ferfi_noi='n�i';

--List�zzuk ki az eur�pai orsz�gok �rem eredm�nyeit arany, 
--ez�st �s bronz szerint is cs�kken�en rendezve.
select *
from olimpia.o_orszagok o inner join olimpia.o_erem_tabla e
on o.azon = e.orszag_azon
where o.foldresz = 'Eur�pa'
order by arany desc, ezust desc, bronz desc;

--List�zzuk ki K�na, Jap�n �s Korea egy�ni versenyz�inek a nev�t.
select*
from olimpia.o_versenyzok
where egyen_csapat = 'e' and orszag_azon in (select azon
                        from olimpia.o_orszagok
                        where orszag in ('K�na', 'Jap�n', 'Korea'));






