-- 元テーブル作成
pragma foreign_keys = ON;
create table X(
  A text,
  B text,
  C text
);
insert into X values('1','B0','C0');
create table Y(A integer primary key);

-- 変更
pragma foreign_keys = OFF;
begin transaction;

create table new_X(
  A integer primary key,
  C text unique default NULL,
  D text check(0<=D and D<=100),
  E text not null,
  F text default (datetime('now','localtime')),
  G integer references Y(A)
);
insert into new_X(A, C, D, E, G) select cast(A as int), C, 0, 'E', NULL from X;
drop table X;
alter table new_X rename to X;

commit;
pragma foreign_keys = ON;

-- 確認
select sql from sqlite_master;
.headers on
.mode column
select * from X;

