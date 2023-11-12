--Listázzuk ki azokat az országokat, ahol a lakosság kevesebb, 
--mint 10 millió fõ. 
--A lista lakosság szerint növekvõen legyen rendezve.
select *
from olimpia.o_orszagok
where lakossag <10000000
order by lakossag asc;

--Listázzuk ki azokat az országokat, amelyek területe 0.
select *
from olimpia.o_orszagok
where terulet = 0;

--Listázzuk ki azoknak az országoknak a nevét, a fõvárosát, 
--a lakosságát, a területét és a népsûrûségét, 
--ahol a lakosság kevesebb, mint 10 millió. 
--A lista lakosság szerint csökkenõen legyen rendezve.
select orszag, fovaros, lakossag, terulet, lakossag/terulet as nepsürüseg
from olimpia.o_orszagok
where lakossag <10000000 and terulet <>0
order by lakossag desc;

--Listázzuk ki azoknak az országoknak az adatait,
--ahol nincs megadva mennyi az ország területe.
select *
from olimpia.o_orszagok
where terulet is null;

--Listázzuk ki azoknak az országoknak az adatait, 
--ahol meg van adva mennyi az ország területe.
select *
from olimpia.o_orszagok
where terulet is not null;

--Listázzuk ki Magyarország, Kína, és Japán adatait.
select *
from olimpia.o_orszagok
where orszag in ('Kína', 'Japán', 'Magyarország');

--Listázzuk ki az összes ország adatait, kivéve Magyarországot,
--Kínát, és Japánt.
select *
from olimpia.o_orszagok
where orszag not in ('Kína', 'Japán', 'Magyarország');

--Listázzuk ki azoknak az országoknak a nevét, 
--a fõvárosát és a területét, ahol a terület 
--100 és 1000 km2 között van. 
--A lista terület szerint legyen rendezve.
select orszag, fovaros, terulet
from olimpia.o_orszagok
where terulet between 100 and 1000
order by terulet;

--Listázzuk ki azokat az országokat, 
--amelyek neve A betûvel kezdõdik.
select *
from olimpia.o_orszagok
where orszag like 'A%';

--Listázzuk ki azokat az országokat, 
--amelyek neve A betûvel kezdõdik, és a 3. betûje e betû.
select *
from olimpia.o_orszagok
where orszag like 'A_e%';

--Listázzuk ki azon egyéni versenyzõk adatait, 
--akiknek az országazonosítójuk 131, és Debrecenben születtek.
select *
from olimpia.o_versenyzok
where orszag_azon = '131' and szul_hely = 'Debrecen' and egyen_csapat = 'e';

--Listázzuk azon versenyzõk adatait, akik Egerben születtek
--vagy a nevükben két 'e' betû van (mindegy, hogy nagy vagy kicsi).
select *
from olimpia.o_versenyzok
where (szul_hely = 'Eger') or (lower(nev)like '%e%e%');

--Listázzuk ki azon versenyzõk adatait, 
--akiknek nincs megadva a születési helyük, 
--az országazonosítójuk 4, 
--és az egyen_csapat oszlopban nem 'c' betû szerepel.
select *
from olimpia.o_versenyzok
where szul_hely is null and orszag_azon = '4' and egyen_csapat != 'c';

--Listázzuk ki azon csapatok adatait a versenyzõk táblából, akiknek az 
--országazonosítójuk 4 vagy 131 vagy 15 vagy 23.
select *
from olimpia.o_versenyzok
where egyen_csapat = 'c' and orszag_azon = 4 or orszag_azon = 131 or orszag_azon = 15 or orszag_azon = 23;

select *
from olimpia.o_versenyzok
where (egyen_csapat='c') and (orszag_azon=4) or (orszag_azon=131)
or (orszag_azon=15) or (orszag_azon=23);

--Listázzuk ki az éremtáblából azokat az országazonosítókat, 
--ahol 5 és 10 közötti arany született. 
--A lista az arany eredmények szerint legyen rendezett.
select orszag_azon
from olimpia.o_erem_tabla
where arany between 5 and 10
order by arany;

--Listázzuk ki az érem táblából azokat az országazonosítókat, 
--ahol vagy 2 ezüstöt vagy 1 bronzot nyertek.
select orszag_azon
from olimpia.o_erem_tabla
where ezust = 2 or bronz = 1;

--Listázzuk ki az érem táblából azokat az országazonosítókat,
--amelyeknél az érmek összege több, mint 15.
select orszag_azon
from olimpia.o_erem_tabla
where arany+ bronz+ ezust>15;

--A hét melyik napján született Cseh László?
select to_char (szul_dat, 'Day')
from olimpia.o_versenyzok
where nev = 'Cseh László';

--A hét melyik napjára esik esik 2008. szeptember 22?
select to_char(to_date('2008.09.22', 'yyyy.mm.dd'), 'Day')
from dual;

--Listázzuk ki az érem táblából azokat az országazonosítókat,
--amelyeknél több arany érem van, mint bronz. 
--A lista az aranyérmek szerint csökkenõen legyen rendezve.
select orszag_azon
from OLIMPIA.o_erem_tabla
where arany>bronz
order by arany desc;

--Kérdezzük le az országok táblából Magyarország adatait.
select *
from olimpia.o_orszagok
where orszag='Magyarország';

--Listázzuk ki azokat az országokat, 
--ahol a fõváros B betûvel kezdõdik, és négy betûbõl áll.
select *
from olimpia.o_orszagok
where fovaros like 'B___';

--Listázzuk ki azokat a férfi versenyszámokat, 
--amelyeknél a sportágazonosító 328 és 
--azokat a nõi versenyszámokat, ahol a sportágazonosító 314.
select *
from olimpia.o_versenyszamok
where (ferfi_noi = 'férfi' and sportag_azon = '328') or (ferfi_noi = 'nõi' and sportag_azon = '314');

--Listázzuk ki azokat a versenyzõket, 
--akiknek vagy a neve A-val kezdõdik és 
--van egy 'd' betû benne, és az országazonosítójuk 131; 
--vagy 20 évesnél fiatalabbak.
select *
from olimpia.o_versenyzok
where ((nev like 'A%' or lower(nev) like '%d%') and orszag_azon = '131') or months_between(sysdate, szul_dat)/12 <20;

--A hét melyik napja lesz 10 nap múlva?
select to_char(sysdate+10, 'Day')
from dual;

--Aki 1987. február 12-én született, az most hány napos?
select sysdate - to_date('1987.02.12', 'yyyy.mm.dd')
from dual;

--Aki 1987. február 12-én született, az most hány órás?
select (sysdate - to_date('1987.02.12', 'yyyy.mm.dd'))*24
from dual;

--Aki 1987. február 12-én született, az most hány hónapos?
select months_between (sysdate, to_date('1987.02.12', 'yyyy.mm.dd'))
from dual;

--Listázzuk ki azokat a versenyzõket, akiknek a nevében 2 'e'
--betû szerepel vagy 20 és 21 év közöttiek.
select *
from olimpia.o_versenyzok
where lower(nev) like '%e%e%' or (months_between(sysdate, szul_dat)/12) between 20 and 21;

--Listázzuk ki az versenyzõk táblából azokat a csapatokat, 
--akiknek az országazonosítójuk 4 és azokat az egyéneket,
--akik Debrecenben születtek.
select *
from olimpia.o_versenyzok
where (egyen_csapat = 'c' and orszag_azon = '4') or (egyen_csapat = 'e' and szul_hely = 'Debrecen');

--A 10 milliónál nagyobb lakosságú országokat számoljuk meg, 
--írjuk ki a legkisebb és a legnagyobb területet, 
--adjuk össze a lakosságok számát és 
--átlagoljuk a lakosságok számát.
select count(*), min(terulet), max(terulet), sum(lakossag), avg(lakossag)
from olimpia.o_orszagok
where lakossag>10000000;

--Listázzuk ki azokat az országokat, ahol nincs megadva 
--a földrész.
select *
from olimpia.o_orszagok
where foldresz is null;

--Földrészenként írjuk ki az országok számát, 
--a legnagyobb és legkisebb területet, 
--a lakosok összegét és átlagát.
select count(*), min(terulet), max(terulet), sum(lakossag), avg(lakossag)
from olimpia.o_orszagok
group by foldresz;

--Az eredmények táblából versenyszámazonosítónként a legjobb 
--és a legrosszabb helyezést írjuk ki.
select versenyszam_azon, min(helyezes), max(helyezes)
from olimpia.o_eredmenyek
group by versenyszam_azon;

--Az eredmények táblából versenyszámazonosítónként a legjobb 
--és a legrosszabb helyezést írjuk ki, de csak azokat,
--ahol a kettõ nem egyezik meg egymással.
--A lista legyen a legjobb eredmény szerint rendezve.
select versenyszam_azon, min(helyezes), max(helyezes)
from olimpia.o_eredmenyek
group by versenyszam_azon
having min(helyezes) != max(helyezes)
order by min(helyezes);

--Számoljuk meg, hogy sportágazonosítónként hány versenyszám van.
select count(*), sportag_azon
from olimpia.o_versenyszamok
group by sportag_azon;

--Számoljuk meg, hogy sportágazonosítónként hány versenyszám van.
--Különböztessük meg ezt a férfiaknál és a nõknél.
select ferfi_noi, sportag_azon, count(*)
from olimpia.o_versenyszamok
group by ferfi_noi, sportag_azon;

--Számoljuk meg, hogy sportágazonosítónként hány versenyszám van.
--Különböztessük meg ezt a férfiaknál és a nõknél, 
--és csak a férfiakra vonatkozót listázzuk ki.
select sportag_azon, count(*), ferfi_noi
from olimpia.o_versenyszamok
group by ferfi_noi, sportag_azon
having ferfi_noi = 'férfi';

--Keressük meg azokat az országazonosítókat, amelyek a versenyzõk
--táblában 3-nál többször szerepelnek. (azon országazonosítók, 
--ahol 3-nál több versenyzõ indult.)
select orszag_azon, count(orszag_azon)
from olimpia.o_versenyzok
group by orszag_azon
having count(orszag_azon)>3;

--Számoljuk meg, hogy az egyes születési helyekrõl 
--hány versenyzõ indult.
select count(*), szul_hely
from OLIMPIA.o_versenyzok
group by szul_hely;

--Csoportosítsuk az országokat kezdõbetû alapján, és 
--számoljuk meg, hogy az egyes kezdõbetûkhöz 
--hány ország tartozik.
select count(*), substr(orszag, 1,1) betu
from olimpia.o_orszagok
group by substr(orszag, 1,1);

--Csoportosítsuk az országokat kezdõbetû alapján, és 
--számoljuk meg, hogy az egyes kezdõbetûkhöz hány ország tartozik.
--Csak azokat listázzuk, ahol 10-nél több ország van.
select count(*), substr(orszag, 1,1) betu
from olimpia.o_orszagok
group by substr(orszag, 1,1)
having count(*)>10;

--Csoportosítsuk az európai országokat kezdõbetû alapján, 
--és számoljuk meg, hogy az egyes kezdõbetûkhöz hány ország tartozik. 
--Csak azokat listázzuk, ahol 5-nél több ország van. 
--Az eredményt az országok száma szerint rendezzük.
select count(*), substr(orszag, 1,1) betu
from olimpia.o_orszagok
where foldresz = 'Európa'
group by substr(orszag, 1,1)
having count(*)>5
order by count(*);

--Listázzuk ki földrészenként az országok területének összegét 
--és az átlagos népsûrûséget.
select sum(terulet), foldresz, avg(lakossag/terulet)
from olimpia.o_orszagok
where terulet !=0
group by foldresz;

--Az eredmények táblából versenyszámazonosítónként kérjük le a 
--legjobb és a legrosszabb helyezést, de csak azokat, ahol a 
--legrosszabb helyezés a 10-tõl kisebb.
select versenyszam_azon, min(helyezes), max(helyezes)
from olimpia.o_eredmenyek
group by versenyszam_azon
having max(helyezes)<10;

--Számoljuk meg, országazonosítónként hány versenyzõ szerepel a 
--versenyzõ táblában, de csak azokat írjuk ki, 
--ahol 10-nél több versenyzõ van.
select orszag_azon, count(*)
from OLIMPIA.o_versenyzok
group by orszag_azon
having count(*)>10;

--Listázzuk ki azokat a versenyzõket, akik Debrecenben születtek
--vagy 20 évesnél fiatalabbak. 
--A lista a születési dátum szerint legyen rendezve.
select *
from olimpia.o_versenyzok
where szul_hely = 'Debrecen' or months_between(sysdate, szul_dat)/12<20
order by szul_dat;

--Számoljuk meg, hány versenyszám tartozik a 304, 324, 
--és a 328-as sportágakhoz.
select count(*), sportag_azon
from olimpia.o_versenyszamok
where sportag_azon in ('304', '324','328')
group by sportag_azon;

--Átlagosan hány fõsek a csapatok?
select avg(count(*))
from olimpia.o_csapattagok
group by csapat_azon;

--Kérdezzük le az afrikai országok területét. 
--Ahol nincs adat, ott 0-át írjuk ki.
select orszag, nvl(terulet, 0)
from olimpia.o_orszagok
where foldresz = 'Afrika';

--Magyarország egyéni versenyzõinek a nevét és születési dátumát
--listázzuk ki születési idõ szerint csökkenõen rendezve.
select v.nev, v.szul_dat
from olimpia.o_versenyzok v inner join olimpia.o_orszagok o
on v.orszag_azon = o.azon
where o.orszag = 'Magyarország' and v.egyen_csapat = 'e'
order by v.szul_dat;

--Listázzuk ki a sportágakat és a hozzájuk tartozó 
--versenyszámokat sportágak és versenyszámok szerint rendezve.
select *
from OLIMPIA.o_sportagak s inner join OLIMPIA.o_versenyszamok v
on s.azon = v.sportag_azon
order by s.nev, v.versenyszam;

--Listázzuk ki a nõi Kajak-kenu sportághoz tartozó 
--versenyszámokat.
select *
from olimpia.o_versenyszamok v inner join olimpia.o_sportagak s
on v.sportag_azon = s.azon
where s.nev = 'Kajak-kenu' and v.ferfi_noi='nõi';

--Listázzuk ki az európai országok érem eredményeit arany, 
--ezüst és bronz szerint is csökkenõen rendezve.
select *
from olimpia.o_orszagok o inner join olimpia.o_erem_tabla e
on o.azon = e.orszag_azon
where o.foldresz = 'Európa'
order by arany desc, ezust desc, bronz desc;

--Listázzuk ki Kína, Japán és Korea egyéni versenyzõinek a nevét.
select*
from olimpia.o_versenyzok
where egyen_csapat = 'e' and orszag_azon in (select azon
                        from olimpia.o_orszagok
                        where orszag in ('Kína', 'Japán', 'Korea'));






