# Matsue.rb公式Webサイトのソースコード

## はじめに

これは、[Matsue.rb公式Webサイト](http://matsue.rubyist.net/)のソースコードです。

[Matsue.rb公式Webサイト](http://matsue.rubyist.net/)は[nanoc](http://nanoc.ws/)を利用して構築しています。

また、[GitHub Pages](http://pages.github.com/)を利用して公開しています。rubyist.netのサブドメインとして、[matsue.rubyist.net](http://matsue.rubyist.net/)をいただいています。

本文書では、Matsue.rb公式Webサイトをメンテナンスするための情報や、コンテンツの制作に貢献するための情報を提供します。

## Matsue.rb公式Webサイトの生成

### 必要なソフトウェア

事前に以下のソフトウェアをインストールしてください。

* Ruby 1.9.3以降
  * ソースコードからインストール、RVM、rbenvなど、方法はなんでもいいです。
* bundle
  * gem install bundler
* Git

### 手順

次の操作で、ローカル環境でこのソースコードから生成されるサイトを確認できます。

    cd <作業ディレクトリに移動>
    git clone https://github.com/matsuerb/matsuerb-nanoc.git
    cd matsuerb-nanoc
    bundle install
    bundle exec nanoc compile
    bundle exec nanoc view

しばらくすると、output以下にコンテンツが生成されます。

ブラウザで[http://localhost:3000/](http://localhost:3000/)を開いて確認します。

## コンテンツ制作への貢献

[Matsue.rb公式Webサイト](http://matsue.rubyist.net/)のコンテンツの制作を手伝っていただける方へ、そのやり方を説明します。少し長いですが、GitHubを利用したプロジェクトへの貢献手順の一般的な方法ですので、覚えて損はありません！！

1. GitHubのアカウントを取得します。
2. このレポジトリを[Fork](fork)します。
3. forkしたレポジトリをcloneします。

   例: takaokoujiアカウントでforkした場合

   git clone https://github.com/takaokouji/matsuerb-nanoc

4. やりたいことを短いアルファベットで表現したブランチを作成します。

   例: トップページのリンクを修正したい場合 fix_link_in_top

   git checkout -b fix_link_in_top master

5. 適宜コンテンツを修正して、ローカルレポジトリにコミットします。
6. 修正内容をGitHubにアップロード(push)します。

   git push origin fix_link_in_top master

7. ブラウザでGitHubにアクセスして、fork後のmatsuerb-nanocレポジトリ(この例では https://github.com/takaokouji/matsuerb-nanoc )を表示します。
8. 画面を操作して、先ほどアップロードしたブランチに切り替えます。そして、Pull Requestリンクをクリックします。「Pull Request」というのは修正をMatsue.rb公式Webサイトのレポジトリに取り込んでほしいと依頼する作業のことです。GitHubを使えば、修正内容をアップロードしたあと、ここで説明した画面操作だけで、修正の取り込み依頼ができるということです。
9. あとは、画面に説明に従って操作して、Pull Requestを完了させます。

しばらくすると、Matsue.rb公式Webサイトの管理者から連絡があり、修正が取り込まれたり、取り込むために作業を依頼されたりするでしょう。

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

