drop table color;
drop table color_count;
drop table red_count;
drop table green_count;
drop table blue_count;

create table color (
red int,
green int,
blue int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH '${hiveconf:P}' INTO TABLE color;
create table red_count(type int,red int,countr int);
create table green_count(type int,green int,countg int);
create table blue_count(type int,blue int,countb int);
insert overwrite table red_count select 1,color.red,count(color.red) from color group by color.red;
insert overwrite table green_count select 2,color.green,count(color.green) from color group by color.green; 
insert overwrite table blue_count select 3,color.blue,count(color.blue) from color group by color.blue; 
create table color_count(type int,color int,count int);
insert overwrite table color_count
SELECT type, red,countr FROM red_count
UNION ALL
SELECT type, green,countg FROM green_count
UNION ALL
SELECT type, blue,countb FROM blue_count;
select *from color_count order by type,color ASC;