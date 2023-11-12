select orszag
from olimpia.o_orszagok
where (foldresz, lakossag) in (select foldresz, max(lakossag)
			from olimpia.o_orszagok
			group by foldresz
			having foldresz in ('Afrika', 'Ázsia'));

select orszag
from olimpia.o_orszagok orsz  left outer join olimpia.o_versenyzok v
on orsz.azon=v.orszag_azon
where v.azon is null;

select orszag
from olimpia.o_orszagok
where azon not in (select orszag_azon
		from olimpia.o_versenyzok);

select orsz.azon
from olimpia.o_orszagok orsz left outer join olimpia.o_erem_tabla erem
on orsz.azon = erem.orszag_azon
where erem.orszag_azon is null;

select azon
from olimpia.o_orszagok
minus
select orszag_azon
from olimpia.o_erem_tabla;

select nev
from olimpia.o_versenyzok v
where egyen_csapat = 'c' and azon in  (select azon
				from olimpia.o_csapattagok c
				where v.azon = c.csapat_azon);

select vezeteknev, keresztnev
from konyvtar.tag
where szuletesi_datum = (select min(szuletesi_datum)
			from konyvtar.tag
			where besorolas = 'diak' );

select keresztnev, to_char(szuletesi_datum, 'month')
from konyvtar.tag
union all
select keresztnev, to_char(szuletesi_datum, 'month')
from konyvtar.szerzo;

select keresztnev, to_char(szuletesi_datum, 'month')
from konyvtar.tag
union
select keresztnev, to_char(szuletesi_datum, 'month')
from konyvtar.szerzo;

select keresztnev
from konyvtar.tag
intersect
select keresztnev
from konyvtar.szerzo;

select vezeteknev, keresztnev
from konyvtar.tag 
where szuletesi_datum = (select min(szuletesi_datum)
			from konyvtar.tag
			where besorolas = 'gyerek');

select vezeteknev, keresztnev
from konyvtar.tag 
where besorolas = 'gyerek'
order by szuletesi_datum desc
fetch first row only;

select sz.vezeteknev, sz.keresztnev, count(konyv_azon)
from konyvtar.szerzo sz left outer join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon
group by sz.szerzo_azon, sz.vezeteknev, sz.keresztnev
having count(konyv_azon)<3;

select sz.vezeteknev, sz.keresztnev
from konyvtar.szerzo sz left outer join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon
group by sz.vezeteknev, sz.keresztnev
having count(konyv_azon) = (select min(count (ksz.konyv_azon))
                            from konyvtar.szerzo sz left outer join konyvtar.konyvszerzo ksz
                            on sz.szerzo_azon = ksz.szerzo_azon
                            group by ksz.szerzo_azon);
                            
select sz.vezeteknev, sz.keresztnev, count(konyv_azon) db
from konyvtar.szerzo sz left outer join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon
group by sz.vezeteknev, sz.keresztnev
order by db
fetch first row with ties;