select *
from olimpia.o_versenyzok ver right outer join olimpia.o_orszagok ors
on ors.azon = ver.orszag_azon;

select* 
from olimpia.o_versenyszamok ver inner join olimpia.o_sportagak sport
on ver.sportag_azon = sport.azon
where ver.ferfi_noi = 'nõi' and sport.nev='Kajak-kenu';

select orszag, arany, ezust, bronz
from olimpia.o_orszagok ors inner join olimpia.o_erem_tabla erem
on ors.azon = erem.orszag_azon
where ors.foldresz = 'Európa'
order by erem.arany desc, erem.ezust desc, erem.bronz desc;

select k.konyv_azon, k.cim, max(honorarium)
from konyvtar.konyv k left outer join konyvtar.konyvszerzo ksz
on k.konyv_azon = ksz.konyv_azon
group by k.konyv_azon, k.cim;

select sz.vezeteknev, sz.keresztnev, count(konyv_azon)
from konyvtar.szerzo sz left outer join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon
group by sz.szerzo_azon, sz.vezeteknev, sz.keresztnev;

select vezeteknev, keresztnev, szuletesi_datum
from konyvtar.tag
where szuletesi_datum =(select min(szuletesi_datum)
                        from konyvtar.tag);
           
select *
from konyvtar.konyv
where ar = (select max(ar)
            from konyvtar.konyv
            where tema = 'krimi');

select vezeteknev, keresztnev
from konyvtar.tag
where tagdij < (select avg(tagdij)
                from konyvtar.tag 
                where besorolas in('diák','nyugdíjas'))
order by vezeteknev, keresztnev;

select cim, ar, rownum
from konyvtar.konyv
order by ar desc;

select vezeteknev, keresztnev
from (select *
        from konyvtar.tag
        order by szuletesi_datum desc)
where rownum < 11;

select cim, kiado
from konyvtar.konyv
order by cim
fetch first 10 rows only;

select cim, kiado
from konyvtar.konyv
order by cim
offset 10 rows fetch next 10 rows only;

select cim, kiado
from konyvtar.konyv
order by cim
offset 1 row fetch next 1 row only;

select cim, kiado
from konyvtar.konyv
order by cim
fetch first 10 percent rows only;

select vezeteknev, keresztnev
from konyvtar.tag
where szuletesi_datum = (select min(szuletesi_datum)
                            from konyvtar.tag);
                            
select *
from konyvtar.konyvtari_konyv
where konyv_azon in (select konyv_azon
                    from konyvtar.konyv 
                    where tema = 'krimi');
                    
select cim, kiado, ar
from konyvtar.konyv k
where not exists (select*
                    from konyvtar.konyvtari_konyv kk
                    where k.konyv_azon=konyv_azon);
                    
select ar, kiado, cim
from konyvtar.konyv k
where ar < any (select max(ertek)
            from konyvtar.konyvtari_konyv
            where konyv_azon = k.konyv_azon);
                    
select sz.vezeteknev, sz.keresztnev, ksz.honorarium
from konyvtar.szerzo sz inner join konyvtar.konyvszerzo ksz
on sz.szerzo_azon = ksz.szerzo_azon
where ksz.honorarium < (select max(ar)*500
                        from konyvtar.konyv 
                        where tema = 'horror')
order by sz.vezeteknev, sz.keresztnev;

select vezeteknev, keresztnev
from konyvtar.tag
where olvasojegyszam not in (select tag_azon
                                from konyvtar.kolcsonzes);

select vezeteknev, keresztnev
from konyvtar.tag t left outer join konyvtar.kolcsonzes k
on t.olvasojegyszam = k.tag_azon
where k.leltari_szam is null;
