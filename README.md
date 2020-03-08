# 1 Day Webアプリケーション

## セットアップ

当日までに以下のライブラリやツールをインストールしておいてください。

### Ruby

事前に2.6系のRubyをインストールして下さい。rbenvの使用をおすすめします。

- [rbenv/rbenv: Groom your app’s Ruby environment](https://github.com/rbenv/rbenv)

```sh
$ ruby -v
ruby 2.6.5p114
```

### Ruby on Rails

事前にRailsの6系をインストールしてください。Rubyのインストールが済んでいる場合は`gem`コマンドでインストール可能です。

```sh
$ gem install rails
$ rails --version
Rails 6.0.2.1
```

### PostgreSQL

事前にPostgreSQLの12系をインストールしてください。インストール後、`psql`コマンドでコンソールにログインできるところまで確認をしておいてください。

以下はMacでの例です。適宜使用している環境に合わせて読みかえてください。

```sh
$ brew install postgresql
$ brew services start postgresql
$ psql --version
psql (PostgreSQL) 12.2
$ psql -U <user-name> -d postgres
```

### pg gem

RubyからPostgreSQLに接続するためのライブラリです。`gem`コマンドからインストールしておいてください。

```sh
$ gem install pg
```

### cURL

データ通信を行なうためのコマンドラインツールです。演習で使用するのでインスールしておいてください。

以下はMacでの例です。

```sh
$ brew install curl
$ curl example.com
(HTML文字列が流れてくる)
```


## 目次

- [HTTP](./http/README.md)
- [RDB](./rdb/README.md)
- [Rails](./rails/README.md)
