# Rails入門 02

## db:create, db:migrate

[Rails入門 01](./rails-01.md) ではScaffold機能を使用し、ユーザーのCRUD機能を作成しました。まずは実行したコマンドを順に見ていきましょう。

```sh
$ bin/rails g scaffold user name:string email:string
```

上記のコマンドではnameとemailを持つUserのCRUDに必要なファイル郡を生成せよと指示しています。

```
$ bin/rails db:create
```

Scaffoldは雛形などを生成しますが、データベースへの変更は行なってくれません。上記のコマンドは名前の通りデータベースの作成を行ないます。作成されるデータベースは `config/database.yml` の定義に従います。今回はデフォルトのままですが、実際には環境に応じて変更する必要があります。

```
$ bin/rails db:migrate
```

`db:create` ではデータベースを作成しますがテーブルを作成してくれるわけではありません。`db:migrate`は`db/migrate`以下にあるファイルをファイル名に含まれるタイムスタンプの順に実行し、テーブルの作成や変更などを行ないます。

Scaffoldを実行した際にuesrsテーブルを作成するためのスクリプトが生成されているので確認してみましょう。

```ruby
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
```

```sh
$ bin/rails s
```

最後はサーバープロセスの起動です。このコマンドを実行するとサーバープロセスが立ち上がりデフォルトでは3000番ポートを使用するようになっています。

## ルーティング

実際にRailsアプリケーションがHTTPリクエストを受け取りレスポンスを返す処理を追ってみましょう。RailsアプリケーションではHTTPリクエストの内容に応じて処理を行なうコントローラーを決定しています。その仕組みをルーティングと呼びます。

ルーティングの定義は `config/routes.rb` に書きます。Scaffoldの実行時に変更が加えられているので確認してみましょう。

```ruby
Rails.application.routes.draw do
  resources :users
end
```

これだけだと何のことかわからないと思うので、もう少し詳しく見ていきましょう。まずは以下のコマンドを実行してみてください。もしくは [http://localhost:3000/rails/info/routes](http://localhost:3000/rails/info/routes) にアクセスしてみましょう。

```sh
$ bin/rails routes
```

| Prefix | Verb | URI Pattern | Controller#Action |
| --- | --- | --- | --- | --- | --- |
| users | GET | /users | users#index |
| | POST | /users | users#create |
| new_user | GET | /users/new | users#new |
| edit_user | GET | /users/:id/edit | users#edit |
| user | GET | /users/:id | users#show |
| | PATCH | /users/:id | users#update |
| | PUT | /users/:id | users#update |
| | DELETE | /users/:id | users#destroy |

この表はHTTPリクエストに応じてどの様に処理するのかのルールを表わしています。例えば一番上の行はHTTPのメソッドがGETでパスが`/users`の場合、`users#index`で処理を行なうという意味です。`users#index`は`UsersController`の`index`メソッドを表わしています。

## コントローラーとモデルの呼び出し

では`UsersController`がどこに定義されているかというと`app/controllers/users_controller.rb`にあります。

```ruby
class UsersController < ApplicationController
  # 省略
  def index
    @users = User.all
  end
  # 省略
end
```

`UsersController`の`index`メソッドを見てみるとインスタンス変数に値を格納しているのがわかります。このコードでなぜ一覧ページが表示することができるのか順にみていきましょう。

まずは`User.all`ですが、`User`モデルの`all`メソッドを呼び出しています。`User`モデルは`app/models/user.rb`に定義されているのでそちらも見てみましょう。

```ruby
class User < ApplicationRecord
end
```

モデルにはなにも定義されていません。`User`モデルは`ApplicationRecord`を継承していますが、こちらも同様に`app/models/application_record.rb`に定義されています。ただこちらもほとんどなにも記述されていません。`ApplicationRecord`は`ActiveRecord::Base`を継承していますが、`ActiveRecord::Base`がモデルとして必要な機能のほとんどを提供しています。

`all`メソッドも同様に`ActiveRecord::Base`が提供していますが、このメソッドは「モデルクラスが示すテーブルからレコードを全件取得」します。このメソッドを実行すると以下のSQLが実行されています。

```sql
SELECT "users".* FROM "users"
```

このことは実はアプリケーションのログで確認することが可能です。一度[http://localhost:3000/users](http://localhost:3000/users)にアクセスし、サーバープロセスを起動しているターミナルを確認してみましょう。

Railsは「規約」によりアプリケーションのコードの記述量が少なくて済むフレームワークです。「Userモデル」が「usersテーブル」とセットになるというのも暗黙的に決まっています。よってわざわざそれを示すコードを書く必要がありません。

## ビューのレンダリング

以上のことから`@users`には`users`テーブルのレコード全件が格納されていることがわかりました。では実際に表示されているHTMLはどこで決まっているのでしょうか。

ここでも規約によってレンダリングするテンプレートファイルが決まっています。`UsersController`の`index`メソッドのレンダリングに使用されるテンプレートは`app/views/users/index.html.erb` にあります。

```html
<p id="notice"><%= notice %></p>

<h1>Users</h1>

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Email</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @users.each do |user| %>
      <tr>
        <td><%= user.name %></td>
        <td><%= user.email %></td>
        <td><%= link_to 'Show', user %></td>
        <td><%= link_to 'Edit', edit_user_path(user) %></td>
        <td><%= link_to 'Destroy', user, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New User', new_user_path %>
```

RailsのデフォルトのテンプレートではERBが使用されています。ERBはRubyのライブラリの1つで任意のテキストファイルにRubyスクリプトを埋め込むことができます。

`UsersController`の`index`メソッドで定義された`@users`はこのテンプレートファイルのレンダリングに使用されています。このテンプレートファイルを使用してレンダリングされたHTMLが`index`メソッドが返すことによってHTTPレスポンスのボディに格納されてブラウザが受信することができています。
