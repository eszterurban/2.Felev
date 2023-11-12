select tema, count(*)
from konyvtar.konyv
group by tema
having count(*)<3;

select kiado
from konyvtar.konyv
where oldalszam >200
group by kiado
having count(konyv_azon)>=3;

select sz.vezeteknev, sz.keresztnev
from konyvtar.szerzo sz inner join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon inner join konyvtar.konyv k
on ksz.konyv_azon = k.konyv_azon
where extract(month from sz.szuletesi_datum)=5 and (lower(k.cim) like '%a%a%' and lower(k.cim) not like '%a%a%a%') and ksz.honorarium>100;

select k.leltari_szam
from konyvtar.tag t inner join konyvtar.kolcsonzes k
on t.olvasojegyszam = k.tag_azon
where t.vezeteknev = 'Ácsi' and t.keresztnev = 'Milán';

select *
from HR.employees;

select *
from HR.departments;

select d.department_name
from HR.employees e inner join HR.departments d
on e.department_id = d.department_id
where e.first_name = 'Steven' and e.last_name = 'King';

select k.cim
from konyvtar.konyv k inner join konyvtar.konyvszerzo ksz
on k.konyv_azon = ksz.konyv_azon inner join konyvtar.szerzo sz
on ksz.szerzo_azon = sz.szerzo_azon
where sz.vezeteknev = 'Jókai' and sz.keresztnev = 'Mór';

select count(distinct k.kiado), sz.vezeteknev, sz.keresztnev
from konyvtar.konyv k inner join konyvtar.konyvszerzo ksz
on k.konyv_azon = ksz.konyv_azon inner join konyvtar.szerzo sz
on ksz.szerzo_azon = sz.szerzo_azon
group by sz.vezeteknev, sz.keresztnev;

select k.cim, sz.vezeteknev, sz.keresztnev
from konyvtar.konyv k inner join konyvtar.konyvszerzo ksz
on k.konyv_azon = ksz.konyv_azon inner join konyvtar.szerzo sz
on ksz.szerzo_azon = sz.szerzo_azon
where k.tema in ('horror', 'krimi');

select k.leltari_szam
from konyvtar.tag t inner join konyvtar.kolcsonzes k
on t.olvasojegyszam = k.tag_azon
where months_between(sysdate, t.szuletesi_datum)/12>40;

select t.vezeteknev, t.keresztnev
from konyvtar.tag t inner join konyvtar.szerzo sz
on sz.szuletesi_datum < t.szuletesi_datum
where sz.vezeteknev = 'Christie' and sz.keresztnev = 'Agatha';

select t.vezeteknev, t.keresztnev
from konyvtar.szerzo sz, konyvtar.tag t
where sz.vezeteknev = 'Christie' and sz.keresztnev = 'Agatha';

select kiado
from konyvtar.szerzo sz inner join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon inner join konyvtar.konyv k
on ksz.konyv_azon = k.konyv_azon
where sz.szuletesi_datum < to_date('1950', 'yyyy')
group by kiado
having sum(nvl(ksz.honorarium,0))<1000000
order by kiado;

select sz.vezeteknev, sz.keresztnev, count(*)
from konyvtar.szerzo sz inner join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon inner join konyvtar.konyv k
on ksz.konyv_azon = k.konyv_azon
group by sz.szerzo_azon, sz.vezeteknev, sz.keresztnev;

select sz.vezeteknev, sz.keresztnev
from konyvtar.szerzo sz inner join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon inner join konyvtar.konyv k
on ksz.konyv_azon = k.konyv_azon
where k.cim ='Napóleon';

select sz.vezeteknev, sz.keresztnev, count(ksz.konyv_azon)
from konyvtar.szerzo sz left outer join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon
group by sz.vezeteknev, sz.keresztnev
having count(ksz.konyv_azon)<3;

select p.pnev
from vallalat.z_dolgozo d inner join VALLALAT.z_dolgozik_rajta dr
on d.szsz = dr.dszsz inner join vallalat.z_projekt p
on dr.psz = p.pszam
where d.vnev='Kovács' and d.knev='László';

select k.cim, count(*)
from konyvtar.konyv k inner join konyvtar.konyvszerzo ksz
on k.konyv_azon = ksz.konyv_azon inner join konyvtar.szerzo sz
on ksz.szerzo_azon = sz.szerzo_azon
group by k.konyv_azon, k.cim, k.kiado, k.tema;