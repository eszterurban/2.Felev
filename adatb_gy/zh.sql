--1.
select megrendeles, kontener, round(rakomanysuly, 2)
from hajo.s_hozzarendel
where rakomanysuly>'15,000'
order by rakomanysuly;

--2.
select *
from hajo.s_kikoto
where leiras like '%kikötõméret: kicsi%' and leiras like '%mobil daruk%';

--3
select ut_id, to_char(indulasi_ido, 'yyyy.mm.dd hh:mi'),
to_char(erkezesi_ido, 'yyyy.mm.dd hh:mi'), indulasi_kikoto, erkezesi_kikoto, hajo 
from hajo.s_ut
where to_char(indulasi_ido, 'yyyy.mm.dd hh:mi') not like '____.__.__ __:00'
order by indulasi_ido;

--4
select hajo_tipus, count(*)
from hajo.s_hajo
where max_sulyterheles>500
group by hajo_tipus;

--5
select to_char(megrendeles_datuma, 'yyyy.mm')
from hajo.s_megrendeles
where to_char(megrendeles_datuma, 'mm')>=6
group by to_char(megrendeles_datuma, 'yyyy.mm')
order by to_char(megrendeles_datuma, 'yyyy.mm');

--6
select u.vezeteknev || ' ' || u.keresztnev, u.telefon
from hajo.s_ugyfel u inner join hajo.s_helyseg s
on s.helyseg_id = u.helyseg
where s.orszag = 'Szíria';

--7
select ht.nev, min(h.netto_suly)
from hajo.s_hajo h inner join hajo.s_hajo_tipus ht
on h.hajo_tipus = ht.hajo_tipus_id
group by ht.nev;

--8
select h.orszag, h.helysegnev
from hajo.s_kikoto k inner join hajo.s_helyseg h
on k.helyseg = h.helyseg_id inner join hajo.s_orszag o
on h.orszag=o.orszag
where o.foldresz= 'Ázsia'
order by h.orszag, h.helysegnev;

--9
select to_char(max(u.indulasi_ido), 'yyyy.mm.dd hh:mi'), h.nev, h.hajo_id, u.erkezesi_kikoto, u.indulasi_kikoto
from hajo.s_hajo h inner join hajo.s_ut u
on h.hajo_id = u.hajo 
group by h.nev, h.hajo_id, u.erkezesi_kikoto, u.indulasi_kikoto;

--10
select erkezesi_kikoto, h.orszag, h.helysegnev
from hajo.s_ut u inner join hajo.s_kikoto k
on u.erkezesi_kikoto = k.kikoto_id inner join hajo.s_helyseg h
on k.helyseg = h.helyseg_id
where to_char(indulasi_ido, 'yyyy.mm.dd hh:mi') = (select to_char(min(indulasi_ido), 'yyyy.mm.dd hh:mi')
                                                   from hajo.s_ut
                                                   where indulasi_kikoto like 'It_Cat')