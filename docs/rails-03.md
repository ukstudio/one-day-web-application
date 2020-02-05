# Rails入門 03

ここからは実際に自分でアプリケーションコードを書いてみましょう。いくつかお題を出すので下記のサイトを参考にしつつ自分で実装してみましょう。講義参加者は調べるより聞く方がはやいと思うので直接講師に質問してかまいません。

- [Ruby on Rails ガイド：体系的に Rails を学ぼう](https://railsguides.jp/)
- [Ruby on Rails チュートリアル：実例を使って Rails を学ぼう](https://railstutorial.jp/)

## Issueの登録画面を作ろう

- イメージ的にはGitHubにあるようなIssue管理システムを想像してください
- Issueにはタイトル、本文、担当者を持たせてください
- Scaffoldの使用は禁止
  - むずかしい場合、使ってかまいません
  - [Rails入門 01](./rails-01.md)で生成されたコードは参考にしてかまいません

### ヒント

- [Active Record の関連付け \- Railsガイド](https://railsguides.jp/association_basics.html)
- [Action View の概要 \- Railsガイド](https://railsguides.jp/action_view_overview.html)

## Issueの一覧ページを作ろう

- 登録されているすべてのIssueを表示するページを実装してください
- 一覧にはIssueのタイトルと担当者の名前を表示してください
- N+1問題が発生しないように注意してください

### ヒント

- [Active Record クエリインターフェイス \- Railsガイド](https://railsguides.jp/active_record_querying.html)

## Issueに状態を持たせよう

- Issueにopenとpending、closeの3種類の状態を持たせてください
- 登録フォームで設定できるようにしてください
- 編集フォームを作成し、状態を変更できるようにしてください
  - 状態以外の項目も変更できるようにしてください

### ヒント

- [Active Record クエリインターフェイス \- Railsガイド](https://railsguides.jp/active_record_querying.html#enums)

## 一覧で状態ごとにフィルターできるようにしよう

- Issueの一覧ページでopenのIssueのみ、pendingのIssueのみ、closeのIssueのみで表示できるようにしてください

