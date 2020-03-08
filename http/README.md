# HTTP 演習

## HTTPリクエスト・レスポンスの中身を知る

実際に送受信されているHTTPリクエスト・レスポンスの内容を見てみましょう。

### サーバの起動

まずはリクエストを送るためのサーバを起動しましょう。サーバ用のプログラムは`./http/examples/01`にあります。

```
$ cd ./http/examples/01
$ bundle install
$ bundle exec rackup config.up
[2020-03-08 19:48:41] INFO  WEBrick 1.4.2
[2020-03-08 19:48:41] INFO  ruby 2.6.5 (2019-10-01) [x86_64-darwin18]
[2020-03-08 19:48:41] INFO  WEBrick::HTTPServer#start: pid=42864 port=9292
```

### GET リクエストの送信

次に`curl`コマンドを使ってリクエストを送ってみましょう。この時に`-v`オプションを使用するとリクエストとレスポンスの詳細を確認することができます。

```
$ curl -v http://localhost:9292
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 9292 (#0)
> GET / HTTP/1.1
> Host: localhost:9292
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: text/plain
< Content-Length: 13
< Server: WEBrick/1.4.2 (Ruby/2.6.5/2019-10-01)
< Date: Sun, 08 Mar 2020 10:58:55 GMT
< Connection: Keep-Alive
<
Hello, World
* Connection #0 to host localhost left intact
* Closing connection 0
```

cURLのレスポンスについて見ていきましょう。まずは前半部分です。前半部分がHTTPリクエスト部分を表示しており、Webアプリケーションに送ったリクエストの詳細を確認することができます。

```
> GET / HTTP/1.1
> Host: localhost:8000
> User-Agent: curl/7.64.1
> Accept: */*
```

`GET / HTTP/1.1`のうち`GET`がメソッドを表し、`/`がパスを表しています。Webアプリケーション側ではこのメソッドとパスの組み合わせで処理の内容を決定します。`Host`、`User-Agent`、`Accept`がリクエストに含まれているヘッダ情報です。

次に後半部分を見てみましょう。こちらはHTTPレスポンス部分を表示しており、Webアプリケーションから返ってきたレスポンスの詳細を確認することができます。

```
< HTTP/1.1 200 OK
< Content-Type: text/plain
< Content-Length: 13
< Server: WEBrick/1.4.2 (Ruby/2.6.5/2019-10-01)
< Date: Sun, 08 Mar 2020 10:58:55 GMT
< Connection: Keep-Alive
<
Hello, World
```

最初の行の`200`の3桁の数字がステータスコードです。Webアプリケーションが正常に処理することができたのか、失敗したのかなどを示します。

その下に続く`Content-Type`から`Connection`までがヘッダ情報です。リクエスト時のヘッダとレスポンス時のヘッダを分けて表現するために「リクエストヘッダ」「レスポンスヘッダ」と呼ぶことが多いです。`Content-Type`はレスポンスに含まれているボディのコンテンツ種別を示します。今回の例ではコンテンツがHTML形式であることを示しています。

最後の一行がボディで、Webアプリケーションから返ってきたコンテンツの中身などが格納されています。

### GETリクエストの送信(404)

サーバには`/`以外のパスにリクエストがあった場合、404が返るように実装されています。404はリクエストしたリソースが存在しないことを示すステータスコードです。試しに`/hello`にGETリクエストを送ってみましょう。

```
$ curl -v http://localhost:9292/hello
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 9292 (#0)
> GET /hello HTTP/1.1
> Host: localhost:9292
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 404 Not Found
< Content-Type: text/plain
< Content-Length: 25
< Server: WEBrick/1.4.2 (Ruby/2.6.5/2019-10-01)
< Date: Sun, 08 Mar 2020 12:49:01 GMT
< Connection: Keep-Alive
<
This page does not exist
* Connection #0 to host localhost left intact
* Closing connection 0
```

## POSTメソッドに対応する

POSTメソッドは主にリソースの作成に使われるHTTPメソッドです。ブラウザのフォームも通常POSTメソッドでリクエストを送っています。

今のサーバの実装はGETのみにしか対応していないので、POSTメソッドでリクエストがあった時に「Resource was successfully created.」と応答するようにしましょう(実際になにかリソースを作成する必要はありません)。またステータスコードはリソースが作成されたことを示す201にします。

修正するファイルは`./http/examples/01/app.rb` です。修正後はすでに起動済みのサーバプロセスを一度終了し、再起動する必要があります。またリクエストで指定されたHTTPメソッドは`request.request_method`で取得可能です。

`curl`では以下の様にPOSTリクエストを送ることができます。`-d`オプションはPOSTかつ、`x-www-form-urlencoded`形式でボディを送信するオプションです。

```
$ curl -v -d foo=bar http://localhost:9292
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 9292 (#0)
> POST / HTTP/1.1 # <-- POST形式になっている
> Host: localhost:9292
> User-Agent: curl/7.64.1
> Accept: */*
> Content-Length: 7
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 7 out of 7 bytes
< HTTP/1.1 201 Created # <-- ステータスコードが201になっている
< Content-Type: text/plain
< Content-Length: 35
< Server: WEBrick/1.4.2 (Ruby/2.6.5/2019-10-01)
< Date: Sun, 08 Mar 2020 13:23:17 GMT
< Connection: Keep-Alive
<
Resource was successfully created. # <-- ボディが変わっている
* Connection #0 to host localhost left intact
* Closing connection 0
```

実装例は`./http/examples/02` にあります。


## Acceptヘッダに対応する。

Acceptヘッダはクライアントが理解できるコンテンツ形式を指定するためのヘッダです。サーバでは送られてきたAcceptヘッダを解釈し、レスポンスに含めるコンテンツの形式を決定します(= コンテンツネゴシエーション)。

今のサーバの実装ではAcceptヘッダの内容に関係なく`text/plain`形式でコンテンツが返ってくるようになっているので、`text/html`形式に対応しましょう。本来のAcceptヘッダは複数の形式を指定できますが、ここでは単純に1つのみ指定することとします。 またリクエストで指定されたAcceptヘッダは`request.get_header("HTTP_ACCEPT")`で取得可能です。

`curl`ではヘッダを指定するのに`-H`オプションを使用することができます。

```
$ curl -v -H "Accept: text/html" http://localhost:9292
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 9292 (#0)
> GET / HTTP/1.1
> Host: localhost:9292
> User-Agent: curl/7.64.1
> Accept: text/html # <-- 送信されてるAcceptヘッダが変わっている
>
< HTTP/1.1 200 OK
< Content-Type: text/html # <-- レスポンスのContent-Typeヘッダが変わっている
< Content-Length: 39
< Server: WEBrick/1.4.2 (Ruby/2.6.5/2019-10-01)
< Date: Sun, 08 Mar 2020 14:12:33 GMT
< Connection: Keep-Alive
<
<html><body>Hello, World</body></html> # <-- HTMLが返ってきている
* Connection #0 to host localhost left intact
* Closing connection 0
```
