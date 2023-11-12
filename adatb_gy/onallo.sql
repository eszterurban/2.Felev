-- Listázzuk ki a könyveket. A lista legyen ar szerint rendezett, 
-- és a null értékek elöl szerepeljenek.
select *
from konyvtar.konyv 
order by ar nulls first;

-- Keressük azoknak a könyveknek a címét és árát, amelyeknek az 
-- ára 1000 és 3000 között van. A listát rendezzük ár, azon belül cím szerint.
select cim, ar
from konyvtar.konyv
where ar  BETWEEN 1000 and 3000
order by ar, cim;

-- Keressük azokat a könyveket, amelyek sci-fi témájúak 
--vagy olcsóbbak 1000-nél és oldalszámuk több, mint 200 vagy a Gondolat kiadó a kiadójuk.
select *
from konyvtar.konyv
where (tema = 'sci-fi' or ar<1000) and (oldalszam>200 or kiado = 'Gondolat');


--Keressük azokat a könyveket, amelyeknek a címe nem a 'Re' sztringgel kezdõdik.
select *
from konyvtar.konyv
where cim not like 'Re%';


-- Listázzuk ki az 1980.03.02 elõtt született férfi tagok nevét és születési dátumát.
select vezeteknev, keresztnev, to_char(szuletesi_datum, 'yyyy.mm.dd')
from konyvtar.tag 
where nem = 'f' and szuletesi_datum < to_date('1980.03.02', 'yyyy.mm.dd');


-- Azokat a tagokat keressük, akinek a nevében legalább kettõ 'e' betû
-- szerepel és igaz rájuk, hogy 40 évnél fiatalabbak vagy besorolásuk gyerek.
select *
from konyvtar.tag 
where lower(vezeteknev || keresztnev) like '%e%e%' and (besorolas = 'gyerek' or months_between(sysdate, szuletesi_datum)/12 <40);
 
--  Hány különbözõ téma van?
select count(distinct(tema)) as hany_tema
from konyvtar.konyv;


-- Melyek azok a témák, amelyekben 3-nál több olyan könyvet 
-- adtak ki, amelyeknek az ára 1000 és 3000 között van?
select tema
from konyvtar.konyv
where ar between 1000 and 3000
group by tema
having count(konyv_azon)>3;


-- Mi a 40 évesnél fiatalabb olvasók által kikölcsönzött könyvek leltári száma?
select k.leltari_szam
from konyvtar.tag t inner join konyvtar.kolcsonzes k
on t.olvasojegyszam = k.tag_azon
where months_between(sysdate, t.szuletesi_datum)/12 <40;


-- Melyik olvasó fiatalabb Agatha Christie írótól?
select t.vezeteknev || ' ' || t.keresztnev 
from konyvtar.tag t, konyvtar.szerzo sz
where sz.vezeteknev = 'Christie' and sz.keresztnev = 'Agatha' and sz.szuletesi_datum<t.szuletesi_datum;

 
-- Kik azok a tagok , akik egy példányt legalább kétszer kölcsönöztek ki?
select t.vezeteknev || ' ' || t.keresztnev
from konyvtar.kolcsonzes k inner join konyvtar.tag t
on t.olvasojegyszam = k.tag_azon
group by tag_azon, leltari_szam, vezeteknev, keresztnev 
having count(kolcsonzesi_datum)>1;

-- Témánként mi a legdrágább árú könyv címe?
select tema, cim
from konyvtar.konyv
where (tema, ar)in (select tema, max(ar)
            from konyvtar.konyv
            group by tema);

-- A krimi témájú könyvekbõl melyik a legdrágább?
select *
from konyvtar.konyv
where tema = 'krimi' and ar = (select max(ar)
                                from konyvtar.konyv
                                where  tema = 'krimi');
 
-- A nõi tagok között mi a legfiatalabb tagnak a neve?
select vezeteknev, keresztnev
from konyvtar.tag
where nem = 'n' and szuletesi_datum = (select max(szuletesi_datum)
                            from konyvtar.tag 
                            where nem = 'n');

-- Melyik az a könyv, amely nem sci-fi, krimi és horror témájú, és 
--amelyhez több, mint 3 példány tartozik?
select cim
from konyvtar.konyv k inner join konyvtar.konyvtari_konyv kk
on k.konyv_azon = kk.konyv_azon
where tema not in ('horror', 'sci-fi', 'krimi')
group by k.cim, k.konyv_azon
having count(kk.leltari_szam)>3;


