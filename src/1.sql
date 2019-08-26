-- インデックス、トリガー、ビュー有り版
-- 元テーブル作成
pragma foreign_keys = ON;
create table X(
  A text,
  B text,
  C text
);
insert into X values('1','B0','C0');
create table Y(A integer primary key);
insert into Y values(1);
create table trriger_log(id integer primary key, log text);
create index idx_A on X(A);
create view view_all as select * from X;
create trigger trg_1 insert on X
  begin
    insert into trriger_log(log) values('トリガーで挿入！');
  end;
-- 作成確認
.indices X
.echo on
select * from view_all;
select * from trriger_log;
insert into X values(2, 'B1', 'C1');
select * from trriger_log;
delete from trriger_log;
.echo off

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

drop view view_all;
drop index idx_A;
drop trriger trg_1;
drop table X;
create index idx_A on new_X(A);
create view view_all as select * from new_X;
create trigger trg_1 insert on new_X
  begin
    insert into trriger_log(log) values('トリガーで挿入！');
  end;   

alter table new_X rename to X;

commit;
pragma foreign_keys = ON;

-- 確認
.echo on
.tables
.indices X
insert into X(A, C, D, E, G) values(3, NULL, 0, '', 1);
select * from sqlite_master;
.echo off

