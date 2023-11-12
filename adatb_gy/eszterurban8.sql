drop table konyv;

create table konyv as
select *
from konyvtar.konyv;

select *
from konyv;

update konyv
set ar = ar/4, oldalszam = oldalszam*2
where kiadas_datuma > to_date('1998', 'yyyy');
commit;

drop table konyv;

create table konyv as
select *
from konyvtar.konyv;

delete from konyv
where konyv_azon not in (select konyv_azon from KONYVTAR.konyvtari_konyv);

drop table konyv;

drop table konyvszerzo;

create table konyvszerzo as
select *
from KONYVTAR.konyvszerzo;

select szerzo_azon
from KONYVTAR.szerzo
where vezeteknev = 'Móra' and keresztnev = 'Ferenc';

select konyv_azon
from konyvtar.konyv
where ar=(select max(ar) from konyvtar.konyv);

insert into konyvszerzo(szerzo_azon, konyv_azon, honorarium)
select szerzo_azon, konyv_azon, 15000
from konyvtar.konyv, konyvtar.szerzo
where vezeteknev = 'Móra' and keresztnev = 'Ferenc' and ar=(select max(ar) from konyvtar.konyv);

select *
from konyvszerzo;

drop table konyvszerzo;

create table konyvszerzo as
select *
from KONYVTAR.konyvszerzo;

update konyvszerzo ksz
set honorarium =(select ar *10 from konyvtar.konyv k
                    where k.konyv_azon = ksz.konyv_azon)
where szerzo_azon in (select szerzo_azon from konyvtar.szerzo
                        where szuletesi_datum < to_date('1930','yyyy'));
                        
drop table konyvszerzo;

create table konyvszerzo as
select *
from KONYVTAR.konyvszerzo;

update konyvszerzo ksz
set honorarium = (select ar*0.7 from konyvtar.konyv k
                    where k.konyv_azon = ksz.konyv_azon)
where szerzo_azon in (select szerzo_azon from konyvtar.szerzo 
                        where szuletesi_datum < to_date('1930','yyyy')) 
and konyv_azon in (select konyv_azon from konyvtar.konyv
                    where ar >5000);
                    
drop table konyvszerzo;

create table konyvtari_konyv as
select *
from KONYVTAR.konyvtari_konyv;

update konyvtari_konyv kk
set ertek = ertek - (select ar / months_between(sysdate , kiadas_datuma)/12
                    from konyvtari_konyv k
                    where kk.konyv_azon = k.konyv_azon)
where ertek > (select ar*099
                from konyvtari_konyv k
                where kk.konyv_azon =k.konyv_azon);

drop table tag;

create table tag as
select *
from KONYVTAR.tag;

update tag t
set t.beiratkozasi_datum = (select min(kolcsonzesi_datum) from konyvtar.kolcsonzes ko
                            where t.olvasojegyszam = ko.tag_azon)
where t.beiratkozasi_datum > (select min(kolcsonzesi_datum) from konyvtar.kolcsonzes ko
                            where t.olvasojegyszam = ko.tag_azon);

select vezeteknev, keresztknev
from szemely sz left outer join kedvenc k
on sz.szemely_azon = k.gazd_azon
where k.kedvenc_azon is null;

create view nincs_kedvence as
select vezeteknev, keresztknev
from szemely sz left outer join kedvenc k
on sz.szemely_azon = k.gazd_azon
where k.kedvenc_azon is null;

--grant  --revoke
--- on (relacio mas objektum)
--- to ------ from

grant select on konyv to egyik;

grant all on konyv to public;

grant update (ar, oldalszam ) on konyv to egyik;

revoke select on konyv from egyik;

revoke all on konyv from public;

revoke update (ar, oldalszam ) on konyv from egyik;

create view legdragabb as
select cim, tema, ar
from konyvtar.konyv
where (tema,ar)in(select tema, max(ar)
                    from konyvtar.konyv
                    group by tema);

--fetch, outer join, exist all any, halmaz, creat alter drop table, insert delete update, jogosultsag nezet keszites

create view legidosebb as
select vezeteknev, keresztnev 
from konyvtar.tag
where szuletesi_datum = (select min(szuletesi_datum)from konyvtar.tag);
        
select vezeteknev, keresztnev 
from konyvtar.tag
where szuletesi_datum <=ALL (select min(szuletesi_datum)from konyvtar.tag);

create view konyvek as
select leltari_szam, cim, ar/oldalszam ar_per_oldal
from konyvtar.konyv k inner join KONYVTAR.konyvtari_konyv kk
on k.konyv_azon = kk.konyv_azon
where tema in('horror', 'sci_fi', 'krimi')








