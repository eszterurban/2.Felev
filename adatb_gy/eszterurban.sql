select kolcsonzesi_datum as mikor_vitte_el, visszahozasi_datum as mikor_vitte_el
from KONYVTAR.kolcsonzes;

select 1, keresztnev
from konyvtar.tag;

select tagdij, tagdij*1.50
from konyvtar.tag;

select *
from dual;

select 5*6
from dual;

select *
from konyvtar.tag
where besorolas='diák'
order by nem, vezeteknev;

select *
from konyvtar.tag
where besorolas='diák'
order by nem desc, vezeteknev asc;

select cim, ar, oldalszam, ar/oldalszam as arany
from konyvtar.konyv
order by arany desc;

select abs(-5), sin(3.14), mod(13,5), power(2, 8), sqrt(36), floor(4.5478), round(5.7482, 2)
from dual;

select chr(66), chr(35)
from dual;

select concat('piros', 'virag'), 'piros' || 'virag'
from dual;

select vezeteknev, keresztnev, vezeteknev || ' ' || keresztnev as teljes_nev
from konyvtar.tag;

select cim, initcap(cim), upper(cim), lower(cim)
from KONYVTAR.konyv;

select cim, replace(cim, 'halál', 'cica')
from konyvtar.konyv;

select cim, replace(cim, 'néger', 'nword')
from konyvtar.konyv;

select cim, substr(cim, 3, 10)
from konyvtar.konyv;

select cim, length(cim)
from konyvtar.konyv;

--nvl(exp1, exp2)

select tema, nvl(tema, 'nincs megadva a téma')
from konyvtar.konyv;

select sysdate
from dual;

select sysdate
from dual;

select to_char(sysdate, 'yyyy.mm.dd hh:mi:ss')
from dual;

select to_char(sysdate, 'yyyymmdd hhmiss')
from dual;

select to_date('2003. 05. 20 07:52:20', 'yyyy.mm.dd hh24:mi:ss')
from dual;

select *
from konyvtar.tag 
where szuletesi_datum < to_date('1993.10.09', 'yyyy.mm.dd');

select sysdate+50
from dual;

select to_char(sysdate+50, 'mm month Month MONTH mon')
from dual;

select to_char(sysdate-200, 'yyyy.mm.dd')
from dual;

select to_char(add_months(sysdate, 5), 'yyyy.mm.dd')
from dual;

select to_char(add_months(sysdate, 5), 'year.month.day')
from dual;

select months_between(sysdate, to_date('2000.01.03', 'yyyy.mm.dd'))/12
from dual;

select months_between(to_date('2022.02.16', 'yyyy.mm.dd'), szuletesi_datum)/12
from konyvtar.tag;

select to_char(to_date('2003.05.20', 'yyyy.mm.dd'), 'Day')
from dual;

select *
from konyvtar.tag
where besorolas = 'törzstag' and keresztnev like '%a%'
ORDER BY vezeteknev desc;

select to_char(kolcsonzesi_datum, 'yyyy.mm.dd')
from konyvtar.kolcsonzes
where to_date('2020.02.16', 'yyyy.mm.dd') > kolcsonzesi_datum;

select to_char(kolcsonzesi_datum, 'yyyy.mm.dd')
from konyvtar.kolcsonzes
where sysdate-2*365 > kolcsonzesi_datum;

select vezeteknev || ' ' || keresztnev as Név
from KONYVTAR.tag
where keresztnev like 'Z%' and vezeteknev like 'P%';

select vezeteknev || ' ' || keresztnev as Név, tagdij*0.4
from konyvtar.tag
where cim like '_____Budapest%' and besorolas='diák';

select replace(cim, 'al', 'el') 
from konyvtar.konyv;

select nvl(kiado, 'nincs kiadó megadva')
from konyvtar.konyv;

select cim
from konyvtar.konyv
where isbn like '___0%'
order by cim desc;

select  vezeteknev || ' ' || keresztnev as Név, to_char(beiratkozasi_datum, 'yyyy.mm.dd')
from konyvtar.tag
order by tagdij;

select cim, to_char(kiadas_datuma, 'yyyy.mm.dd')
from konyvtar.konyv
where tema in('krimi', 'horror', 'történelem') and oldalszam >= 220
order by kiado;