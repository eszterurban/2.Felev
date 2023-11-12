alter table z_dolgozo
drop constraint z_fk_dolg_osz;
alter table z_dolgozo 
drop constraint z_fk_dolg_fonok;
insert into z_dolgozo values (
'Kovács', 'László', '16501090812',null ,'4033 Debrecen','F', 390000,'25512082219', 5);
insert into z_dolgozo values (
'Szabó','Mária', '25512082219', null, '1097 Budapest', 'N',520000, '13711104519', 5);
insert into z_dolgozo values (
'Kiss','István', '16801196749', null, '1172 Budapest', 'F',325000, '14106204902', 4);
insert into z_dolgozo values (
'Takács','József', '14106204902', null, '4027 Debrecen', 'F',559000, '13711104519', 4);
insert into z_dolgozo values (
'Horváth','Erzsébet','26209153134', null, '1092 Budapest', 'N',494000, '25512082219', 5);
insert into z_dolgozo values (
'Tóth','János', '17207312985', null, '6726 Szeged','F',325000, '25512082219', 5);
insert into z_dolgozo values (
'Fazekas','Ilona', '26903291099', null, '3535 Miskolc', 'N',325000, '14106204902', 4);
insert into z_dolgozo values (
'Nagy','Zoltán', '13711104519', null, '1061 Budapest', 'F',715000, null, 1);
commit;

alter table z_dolgozo
add constraint z_fk_dolg_fonok foreign key (fonok_szsz) references z_dolgozo (szsz);

insert into z_osztaly values (
'Kutatás', 5, '25512082219', to_date('1988.05.22','yyyy.mm.dd'));
insert into z_osztaly values (
'Humán eroforrás', 4, '26903291099', to_date('1995.01.01','yyyy.mm.dd'));
insert into z_osztaly values (
'Központ', 1, '13711104519', to_date('1981.06.19','yyyy.mm.dd'));
commit;

alter table z_dolgozo
add constraint z_fk_dolg_osz foreign key (osz) references z_osztaly (oszam);

insert into z_oszt_helyszinek  values (4, 'Budapest');
insert into z_oszt_helyszinek  values (1, 'Kecskemét');
insert into z_oszt_helyszinek  values (5, 'Vác');
insert into z_oszt_helyszinek  values (4, 'Tiszafüred');
insert into z_oszt_helyszinek  values (1, 'Budapest');
commit;

insert into z_projekt values ('X termék',1, 'Vác', 5);
insert into z_projekt values ('Y termék',2, 'Tiszafüred', 5);
insert into z_projekt values ('Z termék',3, 'Budapest', 5);
insert into z_projekt values ('Komputerizáció',10, 'Kecskemét', 4);
insert into z_projekt values ('Reorganizáció',20, 'Budapest', 1);
insert into z_projekt values ('Új fejlesztések',30, 'Kecskemét',4);
commit;

insert into z_dolgozik_rajta values ('16501090812',1,30.5);
insert into z_dolgozik_rajta values ('16501090812',2,7.5);
insert into z_dolgozik_rajta values ('26209153134',3,40);
insert into z_dolgozik_rajta values ('17207312985',1,20);
insert into z_dolgozik_rajta values ('17207312985',2,20);
insert into z_dolgozik_rajta values ('25512082219',2,10);
insert into z_dolgozik_rajta values ('25512082219',3,10);
insert into z_dolgozik_rajta values ('25512082219',10,10);
insert into z_dolgozik_rajta values ('25512082219',20,10);
insert into z_dolgozik_rajta values ('16801196749',30,30);
insert into z_dolgozik_rajta values ('16801196749',10,10);
insert into z_dolgozik_rajta values ('26903291099',10,35);
insert into z_dolgozik_rajta values ('26903291099',30,5);
insert into z_dolgozik_rajta values ('14106204902',30,20);
insert into z_dolgozik_rajta values ('14106204902',20,15);
insert into z_dolgozik_rajta values ('13711104519',20,NULL);

commit;

insert into z_hozzatartozo values ('25512082219','Anna','N', to_date('1986.04.05','yyyy.mm.dd'), 'lánya');
insert into z_hozzatartozo values ('25512082219','Bence','F', to_date('1983.10.25','yyyy.mm.dd'),'fia');
insert into z_hozzatartozo values ('25512082219','Máté','F', to_date('1958.05.03','yyyy.mm.dd'),'házastársa');
insert into z_hozzatartozo values ('14106204902','Viktória','N', to_date('1942.02.28','yyyy.mm.dd'),'házastársa');
insert into z_hozzatartozo values ('16501090812','Balázs','F', to_date('1988.01.04','yyyy.mm.dd'),'fia');
insert into z_hozzatartozo values ('16501090812','Anna','N', to_date('1988.12.30','yyyy.mm.dd'),'lánya');
insert into z_hozzatartozo values ('16501090812','Réka','N', to_date('1967.05.05','yyyy.mm.dd'),'házastársa');
commit;
update z_dolgozo mo
set szdatum = (select to_date(19||substr(szsz, 2,6),'yyyymmdd')
from z_dolgozo al
where al.szsz= mo.szsz);
commit;