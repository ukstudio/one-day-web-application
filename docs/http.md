# HTTP

Webアプリケーションはクライアントから入力を受けとり、それに応じて出力を行なうプログラムです。 一般的には入力としてHTTP Requestを受けとり、出力にはHTTP Responseを返します。

WebアプリケーションはHTTP Requestに応じて何らかの処理を行ないます。代表的なものはリレーショナルデータベース(以下 RDB)への書き込みなどがあります。 外部のサービスやプログラムとやりとりを行うケースは他にもありますが、一番シンプルな構成としては以下の様になるでしょう。

![](./images/client-webapp-rdb.png)

Webアプリケーションとの通信に使われるHTTPはプロトコルの一種です。HTTPには様々な要素がありますが、重要かつ基本的な要素は以下の4つです。

- メソッド+パス
- ヘッダー
- ボディ
- ステータスコード

## HTTPリクエスト・レスポンスの中身を知る

WEBrickは簡易的なHTTPサーバーを提供することができるRubyの標準ライブラリです。cURLはさまざまなプロトコルを用いてデータ通信を行なうことができるコマンドラインツールです。

この2つを使って実際のHTTPの中身を覗いてみましょう。

```ruby
# docs/samples/server.rb
require "webrick"

server = WEBrick::HTTPServer.new(Port: 8000, AccessLog: [])
server.mount_proc('/') do |request, response|
  response.status = 200
  response.content_type = "text/html"
  response.body = "<html><body>success</body></html>"
end

Signal.trap('INT') { server.shutdown }
server.start
```

以下が実行例です。

```
$ ruby server.rb
```

別のターミナルからcURLでリクエストを送信します。この時に`-v`オプションを指定してください。

```
$ curl http://localhost:8000/ -v
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8000 (#0)
> GET / HTTP/1.1
> Host: localhost:8000
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: text/html
< Server: WEBrick/1.4.2 (Ruby/2.6.5/2019-10-01)
< Date: Wed, 05 Feb 2020 11:08:37 GMT
< Content-Length: 33
< Connection: Keep-Alive
<
* Connection #0 to host localhost left intact
<html><body>success</body></html>⏎
```

cURLのレスポンスについて見ていきましょう。まずは前半部分です。前半部分がHTTPリクエスト部分を表示しており、Webアプリケーションに送ったリクエストの詳細を確認することができます。

```
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8000 (#0)
> GET / HTTP/1.1
> Host: localhost:8000
> User-Agent: curl/7.54.0
> Accept: */*
```

`GET / HTTP/1.1`のうち`GET`がメソッドを表し、`/`がパスを表しています。Webアプリケーション側ではこのメソッドとパスの組み合わせで処理の内容を決定します。

`Host`、`User-Agent`、`Accept`がリクエストに含まれているヘッダー情報です。ヘッダーは主に付加情報として使われ、例えば`User-Agent`はクライアントの種別を示しています。`Accept`はクライアントが認識可能なMIMEタイプを表わしており、今回はすべてのMIMEタイプを受け入れ可能としています。Webアプリケーションでは`Accept`の内容に応じて返すコンテンツの形式を決定します。

次に後半部分を見てみましょう。こちらはHTTPレスポンス部分を表示しており、Webアプリケーションから返ってきたレスポンスの詳細を確認することができます。

```
< HTTP/1.1 200 OK
< Content-Type: text/html
< Server: WEBrick/1.4.2 (Ruby/2.6.5/2019-10-01)
< Date: Wed, 05 Feb 2020 11:08:37 GMT
< Content-Length: 33
< Connection: Keep-Alive
<
* Connection #0 to host localhost left intact
<html><body>success</body></html>
```

最初の行の`200`の3桁の数字がステータスコードです。Webアプリケーションが正常に処理することができたのか、失敗したのかなどを示します。

その下に続く`Content-Type`から`Connection`までがヘッダー情報です。リクエスト時のヘッダーとレスポンス時のヘッダーを分けて表現するために「リクエストヘッダー」「レスポンスヘッダー」と呼ぶことが多いです。`Content-Type`はレスポンスに含まれているボディのコンテンツ種別を示します。今回の例ではコンテンツがHTML形式であることを示しています。

最後の一行がボディで、Webアプリケーションから返ってきたコンテンツの中身などが格納されています。

## HTTPの各要素について

リクエストとレスポンスの中身を実際に見てみたところで、構成している要素について一度整理してみましょう。

### メソッドとパス

- HTTPメソッド = Webアプリケーションになにをして欲しいのか
- パス = 欲しい情報

以下が主要なHTTPメソッドの一覧です。

| メソッド | 内容 |
| --- | --- |
| GET | 情報の取得 |
| POST | 情報の作成 |
| PUT | 情報の一括更新 |
| PATCH | 情報の部分更新 |
| DELETE | 情報の削除 |

例えば `GET /users`であればユーザー一覧の取得、`DELETE /users/1` であれば ID=1のユーザーの削除 と判断することができます。

[HTTP リクエストメソッド \- HTTP \| MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Methods) なども参考にしてください。

補足:  ブラウザのフォームではGET/POST以外送信できません。Railsではボディにメソッド情報を含めることで解決しています。

### ヘッダー

HTTPリクエスト及びレスポンスの両方にヘッダー情報を含めることができます。付加情報をヘッダー情報に含めることでサーバー・クライアントそれぞれがリクエスト・レスポンスの解釈の手助けができます。

ヘッダーの数はかなり多いため [HTTP ヘッダー \- HTTP \| MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Headers) などを参照してください。

### ボディ

HTTPリクエスト及びレスポンスの両方にボディを含めることができます。リクエストではフォームの送信などを行なった際にフォームの情報がボディに格納されて送信されます。先程の例の用にフォーム以外でもAPI通信でWebアプリケーションに送りたい情報を含める用途に使われます。

レスポンスの場合はWebアプリケーションから返す情報の格納に使われます。一番多く使われているのはやはりHTMLでしょう。API通信でもJSON文字列などがボディに格納されて送られてきます。

### ステータスコード

HTTPリクエストがどの様に処理されたのかを示す3桁の数字がHTTPレスポンスに含まれて返ってきます。数は多いですが、以下の4種類に大別されます。

| ステータスコード | 内容 |
| --- | --- |
| 200系 | 処理の成功 |
| 300系 | 情報の移転の通知(例: リダイレクト) |
| 400系 | クライアント側の不備による失敗 |
| 500系 | Webアプリケーション側の不備による失敗 |

個別に見ていくと数が多いので [HTTP レスポンスステータスコード \- HTTP \| MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Status) などを参照してください。
