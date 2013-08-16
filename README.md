# Matsue.rb

Matsue.rbのサイトは[nanoc](http://nanoc.ws/)で作られています。

## 簡単な確認

次の操作で、ローカル環境でこのソースコードから生成されるサイトを確認できます。bundler等の必要なgemは適宜インストールしてください。

    cd <目的のディレクトリに移動>
    git clone https://github.com/matsuerb/matsuerb-nanoc.git
    cd matsuerb-nanoc
    bundle install
    bundle exec nanoc co
    bundle exec nanoc view

ブラウザで[http://localhost:3000/](http://localhost:3000/)を開いて確認します。

## 運用・更新手順

Matsue.rbのサイトの運用・更新手順メモです。

簡単な確認では「git clone」しましたが、実際の運用時コードの変更はpull requestを受け取る方法で行います。ですので、各人がforkしてください。

### Tips

    bundle exec guard

先ほどはcoコマンドでコンパイルしていましたが、都度コマンドを打つのは面倒かもしれません。guardを利用するとファイルの更新を検知して自動でコンパイルしてくれます。

### お知らせの追加

* お知らせの追加は「content/news/yyyy/mm/dd/」以下にファイルを作成してください
* 定例会のファイルは、例えば平成25年8月の定例会の場合「matsuerb_h2508.html」としてください
* 作成するファイルのテンプレートは「template」にサンプルを置いていますので参照してください
* あるいは、前回までのファイルをコピーして使ってください

## Matsue.rbのサイト公開について

Matsue.rbのサイトはGitHub Pagesを利用して公開しています。[matsuerb.github.io](https://github.com/matsuerb/matsuerb.github.io)リポジトリのmasterブランチがウェブサイトとして公開されます。

