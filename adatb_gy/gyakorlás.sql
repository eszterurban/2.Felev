select *
from konyvtar.tag
where (besorolas != 'diák' or tagdij < 1000) and (keresztnev not like '%a%' or nem = 'f');

select cim
from konyvtar.konyv
where oldalszam > 300;

select kiado
from konyvtar.konyv
where cim like '%és%';

select kesedelmi_dij
from konyvtar.kolcsonzes
where hany_napra > 200;

select *
from konyvtar.konyv
where tema in ('horror', 'krimi', 'thriller') and oldalszam > 500;

select *
from konyvtar.tag
where cim like '_____Gyõr,%' and besorolas = 'nyugdíjas';

select cim
from konyvtar.konyv
where konyv_azon like '%3';

select cim
from konyvtar.konyv
where tema = 'horror' and kiado = 'EURÓPA KÖNYVKIADÓ KFT.';

select vezeteknev || ' ' || keresztnev as név
from konyvtar.tag
where besorolas = 'diák' or besorolas = 'törzstag' and cim like ' %/%';

select cim, ar, oldalszam, ar/oldalszam as arany
from konyvtar.konyv
order by arany desc;

select cim, substr(cim, 3, 10)
from konyvtar.konyv;

select to_char(to_date('1993.10.09', 'yyyy.mm.dd'), 'day')
from dual;

select *
from konyvtar.tag
where besorolas ='törzstag' and lower(keresztnev) like '%a%'
order by vezeteknev desc;

select to_char(kolcsonzesi_datum, 'yyyy.mm.dd')
from konyvtar.kolcsonzes
where sysdate-2*365 > kolcsonzesi_datum;

select vezeteknev || ' ' || keresztnev
from konyvtar.tag
where keresztnev like 'Z%' and vezeteknev like 'P%';

select vezeteknev || ' ' || keresztnev, tagdij, tagdij*0.4, tagdij-tagdij*0.6
from konyvtar.tag
where cim like '_____Budapest,%'and besorolas ='diák';

select replace(cim, 'al', 'el')
from konyvtar.konyv;

select nvl(kiado, 'nincs kiadó megadva')
from konyvtar.konyv;

select cim
from konyvtar.konyv
where isbn like'___0%'
order by cim desc;

select vezeteknev || ' ' || keresztnev, to_char(beiratkozasi_datum, 'yyyy.mm.dd')
from konyvtar.tag
order by tagdij asc;

select cim, kiado, to_char(kiadas_datuma, 'yyyy.mm.dd')
from konyvtar.konyv
where tema in ('horror', 'krimi', 'történelmi') and oldalszam >= 220 
order by kiado;

select vezeteknev || ' ' || keresztnev, round(months_between(sysdate, szuletesi_datum)/12) as kor
from konyvtar.tag;

select vezeteknev || ' ' || keresztnev
from konyvtar.tag
where cim like '%út%' or (lower(concat(vezeteknev, keresztnev)) like '%e%e%') and (lower(concat(vezeteknev, keresztnev)) like '%e%e%e%')
order by concat(vezeteknev, keresztnev);

select vezeteknev || ' ' || keresztnev, round(months_between(beiratkozasi_datum, szuletesi_datum)/12)
from konyvtar.tag;

select vezeteknev || ' ' || keresztnev, floor(months_between(sysdate, szuletesi_datum)/12) as fiatalabb_mint_30
from konyvtar.tag
where floor(months_between(sysdate, szuletesi_datum)/12)<30;

select cim
from konyvtar.konyv
where isbn like '_7%'
order by tema desc;

select nvl(kiado, 'nincs megadva kiadó')
from konyvtar.konyv;

select *
from konyvtar.tag
where lower(vezeteknev||keresztnev) like '%a%a%a%' and  lower(vezeteknev||keresztnev) not like '%a%a%a%a%';

select *
from konyvtar.tag
where lower(vezeteknev) like 'a%' and lower(keresztnev) like '%a';

select extract(month from sysdate)
from dual;

select to_char(szuletesi_datum, 'yyyy.mm.dd'),
to_char(round(szuletesi_datum, 'mm'), 'yyyy.mm.dd'),
to_char(trunc(szuletesi_datum, 'mm'), 'yyyy.mm.dd'),
to_char(round(szuletesi_datum, 'yyyy'), 'yyyy.mm.dd'),
to_char(trunc(szuletesi_datum, 'yyyy'), 'yyyy.mm.dd')
from konyvtar.tag;

select *
from konyvtar.konyv
where (tema = 'horror' or oldalszam < 30) and (kiado is null or cim like'A%');

select vezeteknev || ' ' || keresztnev
from konyvtar.szerzo
where floor(months_between(sysdate, szuletesi_datum)/12) > 100
order by extract(month from szuletesi_datum) desc;

select *
from konyvtar.konyv
where tema in ('természettudományi', 'krimi', 'horror') and oldalszam > 50 and extract(year from kiadas_datuma) between 1970 and 2006;  

select *
from konyvtar.konyv
where tema in ('term?szettudom?ny', 'krimi', 'horror') and oldalszam > 50 and
to_char(kiadas_datuma, 'yyyy') >= 1970 and to_char(kiadas_datuma, 'yyyy') <= 2006;


select vezeteknev || ' ' || keresztnev, months_between(sysdate, szuletesi_datum)/12
from konyvtar.tag
where cim not like '%Debrecen,%' and (months_between(sysdate,szuletesi_datum)/12 < 20 or months_between(sysdate,szuletesi_datum)/12 > 30);

select *
from konyvtar.konyv
where (tema not in ('krimi', 'sci-fi') or kiado in null) and lower(cim) like '%a%a%' and ar between 1500 and 4500;

select vezeteknev || ' ' || keresztnev, months_between(sysdate, beiratkozasi_datum)/12,
extract(year from szuletesi_datum), extract(month from szuletesi_datum)
from konyvtar.tag
where months_between(sysdate, beiratkozasi_datum)/12 > 30
order by extract(year from szuletesi_datum) desc, extract(month from szuletesi_datum) asc;

select kesedelmi_dij
from konyvtar.kolcsonzes
where visszahozasi_datum-kolcsonzesi_datum > 100;

select vezeteknev || ' ' || keresztnev
from konyvtar.tag
where besorolas = 'diák' and months_between(sysdate, szuletesi_datum)/12 > 20;

select vezeteknev || ' ' || keresztnev, to_char(szuletesi_datum, 'yyyy.mm.dd')
from konyvtar.tag
where nem = 'f' and to_date('1980.03.02', 'yyyy.mm.dd') > szuletesi_datum;

select *
from konyvtar.tag
where upper(vezeteknev||keresztnev) like 'E%E%' and (months_between(sysdate, szuletesi_datum)/12 < 40 or besorolas = 'gyerek');

select *
from konyvtar.tag
where besorolas in ('nyugdíjas', 'felnõtt') and to_date('2000.01.01', 'yyyy.mm.dd') > szuletesi_datum;

select kiado, count(konyv_azon)
from konyvtar.konyv
group by kiado
having count(konyv_azon)>3;

select kiado, avg(ar)
from konyvtar.konyv
group by kiado
having kiado in ('Média Kiadó', 'IKAR Kiadó');

select tema, min(ar), max(ar), count(konyv_azon)
from konyvtar.konyv
where kiado like 'EURÓPA KÖNYVKIADÓ KFT.'
group by tema;

select kiado, tema, count(konyv_azon)
from konyvtar.konyv
where ar < 4000
group by kiado, tema;

select kiado, tema
from konyvtar.konyv
group by kiado, tema
having avg(ar) < 2500;

select  extract(year from szuletesi_datum)
from konyvtar.szerzo
group by extract(year from szuletesi_datum)
having count(*)>1;

select count(*)
from konyvtar.konyv
where lower(cim) like '%a%a%' and lower(cim) like '%a%a%a%';

select min(tema), max(tema)
from konyvtar.konyv
order by tema;

select to_char(min(szuletesi_datum), 'yyyy.mm.dd')
from konyvtar.szerzo;

select tema
from konyvtar.konyv
where ar/oldalszam between 10 and 150
group by tema
order by tema;

select count(distinct substr(cim, 6, instr(cim, ',')-6))
from konyvtar.tag;

select substr(cim, 6, instr(cim, ',')-6), count(olvasojegyszam)
from konyvtar.tag
where to_date('1980.03.01', 'yyyy.mm.dd') > szuletesi_datum
group by substr(cim, 6, instr(cim, ',')-6);

select to_char(szuletesi_datum, 'yyyy.mm'), count(*)
from konyvtar.tag
group by to_char(szuletesi_datum, 'yyyy.mm')
having count(*) <10;

select kiado, to_char(max(kiadas_datuma), 'yyyy.mm.dd')
from konyvtar.konyv
group by kiado;

select tema, max(ar)
from konyvtar.konyv
group by tema;

select tema, min(ar)
from konyvtar.konyv
where oldalszam < 400
group by tema;

select kiado, sum(oldalszam)
from konyvtar.konyv
group by kiado
having sum(oldalszam) > 500;

select to_char(szuletesi_datum, 'month'), count(*)
from konyvtar.szerzo
group by to_char(szuletesi_datum, 'month')
having count(*) >1;

select to_char(max(szuletesi_datum), 'yyyy.mm.dd')
from konyvtar.tag
where nem='n' and besorolas='diák';





