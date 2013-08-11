Matsue.rb
=========

Matsue.rbのサイトは[nanoc](http://nanoc.ws/)で作られています。

次の操作で、ローカル環境でこのソースコードから生成されるサイトを確認できます。bundler等の必要なgemは適宜インストールしてください。

    cd <目的のディレクトリに移動>
    git clone https://github.com/matsuerb/matsuerb-nanoc.git
    cd matsuerb-nanoc
    bundle install
    bundle exec nanoc co
    bundle exec nanoc view

ブラウザで[http://localhost:3000/](http://localhost:3000/)を開いて確認します。
