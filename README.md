# Matsue.rb公式Webサイトのソースコード

## はじめに

これは、[Matsue.rb公式Webサイト](https://matsue.rubyist.net/)のソースコードです。

[Matsue.rb公式Webサイト](https://matsue.rubyist.net/)は[nanoc](http://nanoc.ws/)を利用して構築しています。

また、[GitHub Pages](http://pages.github.com/)を利用して公開しています。rubyist.netのサブドメインとして、[matsue.rubyist.net](https://matsue.rubyist.net/)をいただいています。

本文書では、Matsue.rb公式Webサイトをメンテナンスするための情報や、コンテンツの制作に貢献するための情報を提供します。

## Matsue.rb公式Webサイトの生成

### 必要なソフトウェア

事前に以下のソフトウェアをインストールしてください。

* Ruby 2.3.0以降
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

[Matsue.rb公式Webサイト](https://matsue.rubyist.net/)のコンテンツの制作を手伝っていただける方へ、そのやり方を説明します。少し長いですが、GitHubを利用したプロジェクトへの貢献手順の一般的な方法ですので、覚えて損はありません！！

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

なお、Matsue.rbのサイトはGitHub Pagesを利用して公開しています。[matsuerb.github.io](https://github.com/matsuerb/matsuerb.github.io)リポジトリのmasterブランチがウェブサイトとして公開されます。

## Tips

### グループのメンバー 一覧の更新

Matsue.rbのメンバーの一覧を https://matsue.rubyist.net/members/ で公開しています。
メンバーの情報は、 [/resources/members.yml](https://github.com/matsuerb/matsuerb-nanoc/blob/master/resources/members.yml) で管理していますので、上記の「コンテンツ制作への貢献」を参考にして、このファイルを修正してpull requestを送ってください。

### お知らせの追加

* お知らせの追加は「content/news/yyyy/mm/dd/」以下にファイルを作成してください
* お知らせのテンプレートを「template」に置いていますので参照してください
* ただし、定例会のお知らせは、専用のサブコマンド(create-matsuerb)を用意しているのでそちらを使ってください。(詳細は後述)

#### 定例会のお知らせの追加

    (2013-10-19に開催する場合)
    bundle exec nanoc create-matsuerb 2013-10-19

### guardの利用

手元での確認のため、都度コマンドを打つのは面倒かもしれません。以下のようにして、guardを利用するとファイルの更新を検知して自動でコンパイルしてくれます。

    bundle exec guard

### 公式サイトへの反映

公式サイトの公開用のレポジトリは別のレポジトリになっています。

* https://github.com/matsuerb/matsuerb.github.io

上述の手順でコンパイルすると HTML などのファイルが public 以下に生成されます。これらを上記のレポジトリに push するとすぐに公式サイトに反映されます。

    例:
    bundle exec nanoc compile
    cp -r public/* /path/to/matsuerb.github.io/
    cd /path/to/matsuerb.github.io/
    git add .
    git commit -m "XXX 時点のファイルを生成。"
    git push origin master

履歴の管理などは matsuerb-nanoc 上でしているため、Pull Request は作成せず、直接 push して問題ありません。
