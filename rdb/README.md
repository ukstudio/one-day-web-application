# リレーショナルデータベース(RDB)

## 初歩的なSQL

実際にSQLを書いて実行してみましょう。まずはデータベースを作成します。

```sh
$ createdb demo_20200309
```

次に`psql`コマンドでデータベースに接続してみましょう。対話型コンソール上ではSQLを入力することができるので、`create table`構文で実際にテーブルを作成します。

```sh
demo_20200309# create table users (
  id serial primary key,
  name varchar(255),
  email varchar(255)
);
```

テーブルが作成できたかどうかは`\d`と入力すると確認することができます。

```
demo_20200309=# \d
                List of relations
 Schema |     Name     |   Type   |     Owner
--------+--------------+----------+---------------
 public | users        | table    | yuki-akamatsu
 public | users_id_seq | sequence | yuki-akamatsu
(2 rows)
```

次に作成したテーブルに実際にデータを入れてみましょう。データを入れるには`insert`文を使用します。

```
demo_20200309# insert into users (name, email) values ('赤松 祐希', 'yuki-akamatsu@cookpad.com');
INSERT 0 1
```

`insert`文で挿入したレコードは`select`文で取得することができます。以下のクエリは`users`テーブルからすべてのレコードを取得します。

```
demo_20200309# select * from users;
 id |   name    |           email
----+-----------+---------------------------
  1 | 赤松 祐希 | yuki-akamatsu@cookpad.com
(1 row)
```

`select`文には様々なオプションがあり、オプションに応じて取得するレコードを変えることができたり、合計値を計算するなど集計を行なうことができます。おそらく最もよく使われるのが`where`でしょう。

```
demo_20200309# insert into users (name, email) values ('taro', 'taro@example.com');
demo_20200309# insert into users (name, email) values ('hanako', 'hanako@example.com');
demo_20200309# select * from users where name = 'hanako';
 id |  name  |       email
----+--------+--------------------
  3 | hanako | hanako@example.com
(1 row)
```

## テーブルの結合

RDBでは複数のテーブルを使ってさまざまなデータを保存します。そのためあるデータを抽出したい時にひとつのテーブルだけで完結しないことが多々あります。テーブルごとにSQLを発行して結果を合わせるということも可能ですが、大抵の場合パフォーマンスに問題がでます。RDBでは`join`を使用することで複数のテーブルを1つのテーブルのように扱うことが可能です。

まずは結合するためのテーブルを用意します。今回はユーザーが持つTodoを保存できる`todos`テーブルを用意します。 `todos`テーブルにあるレコードがどのユーザーのものかは`user_id`カラムで判別します。`users`テーブルの`id`カラムと`user_id`が一致しているようであれば、そのユーザーのTodoと判断することができます。

```
demo_20200309# create table todos (
  id sequence primary key,
  user_id bigint,
  name varchar(255)
);
```

次にレコードを挿入しましょう。今回はid=1のユーザに2件、id=2のユーザに1件のTodoを登録します。

```
demo_20200309# insert into todos (user_id, name) values (1, 'コードレビュー');
demo_20200309# insert into todos (user_id, name) values (1, '講義');

demo_20200309# insert into todos (user_id, name) values (2, '買物');
```

Todoだけを取得するのであれば`select * from todos;`だけで十分ですが、一緒にそのTodoを持つユーザーの名前を表示したい場合は`join`を使う必要があります。

```
demo_20200309# select * from todos join users on users.id = todos.user_id;
 id | user_id |      name      | id |   name    |           email
----+---------+----------------+----+-----------+---------------------------
  1 |       1 | コードレビュー |  1 | 赤松 祐希 | yuki-akamatsu@cookpad.com
  2 |       1 | 講義           |  1 | 赤松 祐希 | yuki-akamatsu@cookpad.com
  3 |       2 | 買物           |  2 | taro      | taro@example.com
(3 rows)
```
