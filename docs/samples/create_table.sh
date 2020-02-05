#! /bin/sh

psql waseda_sample -U waseda_sample -c "create table users ( id serial primary key, name varchar(255), job varchar(255) )";
psql waseda_sample -U waseda_sample -c "insert into users (name, job) values ('赤松 祐希','プログラマ')";
psql waseda_sample -U waseda_sample -c "insert into users (name, job) values ('料理 する太郎','料理家')";
