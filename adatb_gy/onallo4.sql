--1 Listázzuk ki a versenyzõk nevét, és azt, hogy melyik országból származnak. 
--Listázzuk azokat az országokat is, amelyeknek nincs versenyzõjük.

select v.nev, o.orszag
from OLIMPIA.o_versenyzok v right outer join OLIMPIA.o_orszagok o
on v.orszag_azon = o.azon;

--2 Keressük meg azon az Afrikai országok nevét és lakosságát, amelyeknek minden Európai országok lakosságától több lakosa van. 
--A lista lakosság szerint csökkenõen legyen rendezve.

select orszag, lakossag
from OLIMPIA.o_orszagok
where foldresz ='Afrika'
and lakossag > all (select lakossag
from OLIMPIA.o_orszagok
where foldresz = 'Európa');

--5
select o.orszag, o.lakossag,  h.helysegnev, NVL(h.helysegnev, 'NEM ISMERJUK')
from hajo.s_orszag o left outer join hajo.s_helyseg h
on o.fovaros = h.helyseg_id
where o.lakossag < (select lakossag
                        from hajo.s_orszag
                        where orszag = 'Magyarország')
order by o.lakossag;

--11
select h.nev hajonev, ht.nev hajotipus, h.max_sulyterheles
from hajo.s_hajo h inner join hajo.s_hajo_tipus ht
on h.hajo_tipus = ht.hajo_tipus_id
where hajo_id not in (select hajo
                        from hajo.s_ut);
                        
--27
select hajo, count(ut_id) db
from hajo.s_ut
group by hajo
order by db
fetch first 3 rows with ties;

--32
create table s_hajo as
select *
from hajo.s_hajo;
create table s_szemelyzet(
szerelo_azon number(5) constraint sz_pk primary key,
veznev VARCHAR2(40) constraint sz_nn1 not null,
kernev VARCHAR2(40) constraint sz_nn2 not null,
szul_datum date,
email_cim VARCHAR2(200),
melyik_hajo VARCHAR2(10) constraint sz_fk references s_hajo constraint sz_nn3 not null)
constraint sz_fk primary key(veznev, kernev, szul_datum));

--50
create table s_ugyfel as
select * 
from hajo.s_ugyfel;

alter table s_ugyfel
modify email varchar2(50)
modify utca_hsz varchar(100);

--57
create table s_kikoto as
select *
from hajo.s_kikoto
where leiras like '%szárazdokk%' and helyseg in(select h.helyseg_id
                                        from s_kikoto k inner join hajo.s_helyseg h
                                        on k.helyseg = h.helyseg_id
                                        where h.orszag in ('Olaszország', 'Líbia'));

select h.helyseg_id
from s_kikoto k inner join hajo.s_helyseg h
on k.helyseg = h.helyseg_id
where h.orszag in ('Olaszország', 'Líbia');

delete from s_kikoto 
where leiras = '%szárazdokk%' and helyseg in(select h.helyseg_id
                                                from s_kikoto k inner join hajo.s_helyseg h
                                                on k.helyseg = h.helyseg_id
                                                where h.orszag in ('Olaszország', 'Líbia'));

--76
create view telszam as
select k.kikoto_id, count(telefon) db, h.orszag, h.helysegnev
from hajo.s_kikoto k left outer join HAJO.s_kikoto_telefon kt
on k.kikoto_id = kt.kikoto_id inner join hajo.s_helyseg h
on k.helyseg = h.helyseg_id
group by k.kikoto_id,h.orszag, h.helysegnev;


--100
revoke add on s_megrendeles from public;

--29
select u.vezeteknev || ' ' || u.keresztnev, count(m.megrendeles_id)
from hajo.s_megrendeles m left outer join hajo.s_ugyfel u
on m.ugyfel = u.ugyfel_id
group by u.vezeteknev || ' ' || u.keresztnev
order by count(m.megrendeles_id) desc
fetch first 3 rows only;

--53
insert into s_ugyfel
values ('Olaszorszag', select u.azon
from hajo.s_ugyfel u left outer join hajo.s_helyseg h
on u.helyseg = h.helyseg_id
where h.orszag = 'Olaszország');

--94
grant update (vezeteknev,keresztnev) on s_ugyfel to panovocs;

--1
select u.ugyfel_id, u.vezeteknev || ' ' || u.keresztnev, m.megrendeles_id
from hajo.s_ugyfel u left outer join hajo.s_megrendeles m
on u.ugyfel_id = m.ugyfel
order by u.vezeteknev, u.keresztnev, m.megrendeles_id

--


