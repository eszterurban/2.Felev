select *
from konyvtar.konyv
order by  cim;

select count(*)
from konyvtar.konyv;

select count(isbn)
from konyvtar.konyv;

select count(kiado)
from konyvtar.konyv;

select min(oldalszam)
from konyvtar.konyv;

select max(oldalszam)
from konyvtar.konyv;

select oldalszam
from konyvtar.konyv
order by oldalszam;

select sum(ar), avg(ar), count(ar)
from konyvtar.konyv;

select DISTINCT(kiado)
from konyvtar.konyv;

select count(DISTINCT(kiado))
from konyvtar.konyv;

select kiado, count(*)
from konyvtar.konyv
group by kiado;

select kiado, count(konyv_azon)
from konyvtar.konyv
group by kiado
having count(konyv_azon) > 3;

select kiado, avg(ar)
from konyvtar.konyv
group by kiado 
having kiado in ('IKAR Kiadó', 'Média Kiadó'); 

select tema, avg(ar)
from konyvtar.konyv
group by tema 
having avg(ar) < 3000;

select tema, count(konyv_azon), min(ar), max(ar)
from konyvtar.konyv
where kiado = 'EURÓPA KÖNYVKIADÓ KFT.'
group by tema;

select count(konyv_azon), kiado, tema
from konyvtar.konyv
where ar < 4000
group by kiado, tema;

select count(konyv_azon), kiado, tema
from konyvtar.konyv
group by kiado, tema
having avg(ar) < 2500;

select extract(year from szuletesi_datum), count(*)
from konyvtar.szerzo
where szuletesi_datum is not null
group by extract(year from szuletesi_datum)
having count(*)>1;

select count(*)
from konyvtar.konyv
where lower(cim) like '%a%a%' and lower(cim) not like '%a%a%a%';

select min(tema), max(tema)
from konyvtar.konyv;

select max(to_char(szuletesi_datum, 'yyyy.mm.dd'))
from konyvtar.szerzo;

select distinct(tema)
from konyvtar.konyv
where ar/oldalszam between 10 and 150
order by tema;

select tema
from konyvtar.konyv
where ar/oldalszam between 10 and 150
group by tema
order by tema;

select count(*)
from konyvtar.tag
where nem = 'n' and besorolas = 'diák';

select count(distinct(substr(cim, 6, instr(cim, ',')-6)))
from konyvtar.tag;

select substr(cim, 6, instr(cim, ',')-6), count(*)
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

select tema, sum(ar)
from konyvtar.konyv
group by tema
having sum(ar) < 10000;

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
having sum(oldalszam)>500;

select extract(month from szuletesi_datum), count(*)
from konyvtar.szerzo
where szuletesi_datum is not null
group by extract(month from szuletesi_datum)
having count(*) > 1;

select to_char(szuletesi_datum, 'mm'), count(*)
from konyvtar.szerzo
where szuletesi_datum is not null
group by to_char(szuletesi_datum, 'mm')
having count(*) > 1;

select szerzo_azon
from konyvtar.konyvszerzo
group by szerzo_azon
having sum(honorarium) > 2000000;

select ksz.szerzo_azon, sz.vezeteknev, sz.keresztnev
from konyvtar.konyvszerzo ksz inner join konyvtar.szerzo sz
on ksz.szerzo_azon = sz.szerzo_azon
group by ksz.szerzo_azon, sz.vezeteknev, sz.keresztnev
having sum(honorarium) > 2000000;

select to_char(min(szuletesi_datum), 'yyyy.mm.dd')
from konyvtar.tag
where nem = 'n' and besorolas = 'diák'
