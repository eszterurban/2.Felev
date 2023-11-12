-- List�zzuk ki a k�nyveket. A lista legyen ar szerint rendezett, 
-- �s a null �rt�kek el�l szerepeljenek.
select *
from konyvtar.konyv 
order by ar nulls first;

-- Keress�k azoknak a k�nyveknek a c�m�t �s �r�t, amelyeknek az 
-- �ra 1000 �s 3000 k�z�tt van. A list�t rendezz�k �r, azon bel�l c�m szerint.
select cim, ar
from konyvtar.konyv
where ar  BETWEEN 1000 and 3000
order by ar, cim;

-- Keress�k azokat a k�nyveket, amelyek sci-fi t�m�j�ak 
--vagy olcs�bbak 1000-n�l �s oldalsz�muk t�bb, mint 200 vagy a Gondolat kiad� a kiad�juk.
select *
from konyvtar.konyv
where (tema = 'sci-fi' or ar<1000) and (oldalszam>200 or kiado = 'Gondolat');


--Keress�k azokat a k�nyveket, amelyeknek a c�me nem a 'Re' sztringgel kezd�dik.
select *
from konyvtar.konyv
where cim not like 'Re%';


-- List�zzuk ki az 1980.03.02 el�tt sz�letett f�rfi tagok nev�t �s sz�let�si d�tum�t.
select vezeteknev, keresztnev, to_char(szuletesi_datum, 'yyyy.mm.dd')
from konyvtar.tag 
where nem = 'f' and szuletesi_datum < to_date('1980.03.02', 'yyyy.mm.dd');


-- Azokat a tagokat keress�k, akinek a nev�ben legal�bb kett� 'e' bet�
-- szerepel �s igaz r�juk, hogy 40 �vn�l fiatalabbak vagy besorol�suk gyerek.
select *
from konyvtar.tag 
where lower(vezeteknev || keresztnev) like '%e%e%' and (besorolas = 'gyerek' or months_between(sysdate, szuletesi_datum)/12 <40);
 
--  H�ny k�l�nb�z� t�ma van?
select count(distinct(tema)) as hany_tema
from konyvtar.konyv;


-- Melyek azok a t�m�k, amelyekben 3-n�l t�bb olyan k�nyvet 
-- adtak ki, amelyeknek az �ra 1000 �s 3000 k�z�tt van?
select tema
from konyvtar.konyv
where ar between 1000 and 3000
group by tema
having count(konyv_azon)>3;


-- Mi a 40 �vesn�l fiatalabb olvas�k �ltal kik�lcs�nz�tt k�nyvek lelt�ri sz�ma?
select k.leltari_szam
from konyvtar.tag t inner join konyvtar.kolcsonzes k
on t.olvasojegyszam = k.tag_azon
where months_between(sysdate, t.szuletesi_datum)/12 <40;


-- Melyik olvas� fiatalabb Agatha Christie �r�t�l?
select t.vezeteknev || ' ' || t.keresztnev 
from konyvtar.tag t, konyvtar.szerzo sz
where sz.vezeteknev = 'Christie' and sz.keresztnev = 'Agatha' and sz.szuletesi_datum<t.szuletesi_datum;

 
-- Kik azok a tagok , akik egy p�ld�nyt legal�bb k�tszer k�lcs�n�ztek ki?
select t.vezeteknev || ' ' || t.keresztnev
from konyvtar.kolcsonzes k inner join konyvtar.tag t
on t.olvasojegyszam = k.tag_azon
group by tag_azon, leltari_szam, vezeteknev, keresztnev 
having count(kolcsonzesi_datum)>1;

-- T�m�nk�nt mi a legdr�g�bb �r� k�nyv c�me?
select tema, cim
from konyvtar.konyv
where (tema, ar)in (select tema, max(ar)
            from konyvtar.konyv
            group by tema);

-- A krimi t�m�j� k�nyvekb�l melyik a legdr�g�bb?
select *
from konyvtar.konyv
where tema = 'krimi' and ar = (select max(ar)
                                from konyvtar.konyv
                                where  tema = 'krimi');
 
-- A n�i tagok k�z�tt mi a legfiatalabb tagnak a neve?
select vezeteknev, keresztnev
from konyvtar.tag
where nem = 'n' and szuletesi_datum = (select max(szuletesi_datum)
                            from konyvtar.tag 
                            where nem = 'n');

-- Melyik az a k�nyv, amely nem sci-fi, krimi �s horror t�m�j�, �s 
--amelyhez t�bb, mint 3 p�ld�ny tartozik?
select cim
from konyvtar.konyv k inner join konyvtar.konyvtari_konyv kk
on k.konyv_azon = kk.konyv_azon
where tema not in ('horror', 'sci-fi', 'krimi')
group by k.cim, k.konyv_azon
having count(kk.leltari_szam)>3;


