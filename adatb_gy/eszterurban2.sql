select to_char(sysdate, 'yyyy.mm.dd hh:mi:ss')
from dual;

select to_char(to_date ('1994.05.20 16:30:12', 'yyyy.mm.dd hh24:mi:ss'), 'yyyy.mm.dd hh24:mi:ss')
from dual;

--konyvtar sema konyv relacioja
select cim
from konyvtar.konyv
where isbn like '_7%'
order by tema desc;

select nvl(kiado, 'nincs kiado megadva')
from konyvtar.konyv;

--fontos
select vezeteknev ||' ' || keresztnev
from konyvtar.tag
where lower (vezeteknev || keresztnev) like '%a%a%a' and lower (vezeteknev || keresztnev) not like '%a%a%a%a';

select vezeteknev ||' ' || keresztnev
from konyvtar.tag
where vezeteknev like 'A%' and keresztnev like '%a';

select to_char(szuletesi_datum, 'yyyy.mm.dd'),
to_char(szuletesi_datum+1, 'yyyy.mm.dd') as plusz_egy_nap, 
to_char(szuletesi_datum-10, 'yyyy.mm.dd') as minusz_tiz_nap,
to_char(add_months(szuletesi_datum,1), 'yyyy.mm.dd') as plusz_egy_honap, 
to_char(add_months(szuletesi_datum,12), 'yyyy.mm.dd') as plusz_egy_ev
from konyvtar.tag;

select to_char(szuletesi_datum, 'yyyy.mm.dd hh24:mi:ss'),
to_char(szuletesi_datum+1/24, 'yyyy.mm.dd hh24:mi:ss'),
to_char(szuletesi_datum+1/24/60, 'yyyy.mm.dd hh24:mi:ss'),
to_char(szuletesi_datum+5/24/60, 'yyyy.mm.dd hh24:mi:ss')
from konyvtar.tag;

select to_char(last_day(sysdate), 'yyyy.mm.dd')
from dual;

--fontos
select extract(months from sysdate)
from dual;

select extract(year from sysdate)
from dual;

select to_char(szuletesi_datum, 'yyyy.mm.dd hh24:mi:ss'),
floor(sysdate-szuletesi_datum) as hany_napos,
floor(sysdate-szuletesi_datum)*24 as hany_oras,
floor((sysdate-szuletesi_datum)/7) as hany_hetes
from konyvtar.tag;

select to_char(szuletesi_datum, 'yyyy.mm.dd'),
floor(months_between(sysdate, szuletesi_datum)) as hany_honapos,
floor(months_between(sysdate, szuletesi_datum)/12) as hany_eves
from konyvtar.tag;

select to_char(szuletesi_datum, 'yyyy.mm.dd'),
to_char(round(szuletesi_datum, 'mm'), 'yyyy.mm.dd'),
to_char(trunc(szuletesi_datum, 'mm'), 'yyyy.mm.dd'),
to_char(round(szuletesi_datum, 'yyyy'), 'yyyy.mm.dd'),
to_char(trunc(szuletesi_datum, 'yyyy'), 'yyyy.mm.dd')
from konyvtar.tag;

select *
from konyvtar.konyv
where (tema = 'horror' or oldalszam < 30 ) and (kiado is null or cim like 'A%');

select vezeteknev || ' ' || keresztnev
from KONYVTAR.szerzo
where months_between(sysdate, szuletesi_datum)/12 > 100
order by extract(month from szuletesi_datum) desc;

select *
from konyvtar.konyv
where tema in ('természettudomány', 'krimi', 'horror') and oldalszam > 50 and to_char(kiadas_datuma, 'yyyy') > 1970 and to_char(kiadas_datuma, 'yyyy') < 2006;

select *
from konyvtar.konyv
where (extract (year from kiadas_datuma) between 1940 and 2006) and tema in ('természettudomány', 'krimi', 'horror') and oldalszam > 50;

select *
from konyvtar.konyv
where tema in ('természettudomány', 'krimi', 'horror') and oldalszam > 50 and to_char(kiadas_datuma, 'yyyy') between 1970 and 2006;

select vezeteknev, keresztnev, floor(months_between(sysdate, szuletesi_datum)/12)
from konyvtar.tag
where cim not like '_____Debrecen%' and not extract (year from sysdate) - extract(year from szuletesi_datum) between 20 and 30
order by extract(year from szuletesi_datum) desc, vezeteknev desc;

select vezeteknev, keresztnev, floor(months_between(sysdate, szuletesi_datum)/12)
from konyvtar.tag
where cim not like '_____Debrecen%' and months_between(sysdate, szuletesi_datum)/12 not between 20 and 30
order by extract(year from szuletesi_datum) desc, vezeteknev desc;

select*
from konyvtar.konyv
where tema not in ('krimi', 'sci-fi') or kiado is null and cim like '%a%a%' and ar between 1500 and 4500;

select vezeteknev || ' ' || keresztnev, extract ( year from sysdate ) - extract(year from beiratkozasi_datum)
from konyvtar.tag
where (extract ( year from sysdate ) - extract(year from beiratkozasi_datum)) > 30 
order by extract(year from szuletesi_datum) desc, extract(month from szuletesi_datum);

select vezeteknev || ' ' || keresztnev, extract ( year from sysdate ) - extract(year from beiratkozasi_datum)
from konyvtar.tag
where months_between(sysdate, beiratkozasi_datum)/12 > 30 
order by to_char(szuletesi_datum, 'yyyy') desc, to_char(szuletesi_datum, 'mm') asc;