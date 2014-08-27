Description
===========

infoScoopの稼働環境のセットアップを行う。


Requirements
============

Platform: 

* CentOS 6.5

Attributes
==========

* version - インストール対象infoScoopのバージョン。
* module_path - /files/default 以下のinfoScoopモジュールのパスを指定。

Recipes
=======

* default.rb - インストールモジュールのコピーと展開、インポートツールの実行、データベース作成、WARの作成とTomcatへの配備を行います。
* tomcat7.rb - Tomcat7セットアップ用のレシピ。Tomcat7インストール用リポジトリ（JPackage）の追加とインストール、コンテキストファイル（infoscoop.xml）の配置を行っています。 MySQL用JDBCドライバのインストールと $TOMCAT_HOME/lib へのシンボリックリンク設定もついでに行っています。
* mysql.rb - MySQLセットアップ用のレシピ。

