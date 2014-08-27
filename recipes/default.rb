#
# Cookbook Name:: infoscoop
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
version = node["infoscoop"]["version"]
module_path = node["infoscoop"]["module_path"]
infoscoop_dir = "/tmp/infoscoop-opensource-#{version}"

# 1. MySQLセットアップ
include_recipe "infoscoop::mysql"

# 2. Tomcat7セットアップ
include_recipe "infoscoop::tomcat7"

# 3. モジュールのコピー
cookbook_file "/tmp/infoscoop.tar.gz" do
  source "#{module_path}"
  mode 0644
end

# 4. モジュールの展開
execute "untar-infoscoop" do
    command "tar -zxf /tmp/infoscoop.tar.gz -C /tmp"
end

# 5. データベース作成
execute "mysql-create-database" do
    command  <<-EOH
        mysql -u root -e "create database iscoop  character set utf8;"
        mysql -u root iscoop < #{infoscoop_dir}/tools/initdb/schema/mysql/mysqlinit.sql
    EOH
    # 存在チェック
    not_if { File.exists?("/var/lib/mysql/iscoop") }
end

# 6. Antインストール
package "ant" do
    action :install
end

# 7. インポートツールの実行
execute "init-infoscoop" do
    cwd "#{infoscoop_dir}/tools/initdb"
    environment "JAVA_HOME" => "/usr/lib/jvm/jre"
    command "./import.sh"
    creates "#{infoscoop_dir}/tools/initdb/infoscoop.log"
end

# 8. WARの作成
execute "remakewar-infoscoop" do
    cwd "#{infoscoop_dir}/infoscoop"
    environment ({"JAVA_HOME" => "/usr/lib/jvm/jre", "ANT_HOME" => "/usr/share/ant"})
    command "./remakewar.sh"
end

# 9. WARの配備
execute "deploy-infoscoop" do
    command "mv #{infoscoop_dir}/infoscoop/dist/infoscoop.war /usr/share/tomcat7/webapps"
    creates "/usr/share/tomcat7/webapps/infoscoop.war"
end

# 10. Tomcatリスタート
service "tomcat7" do
    supports status: true, restart: true, reload: true
    action   [ :enable, :restart ]
end
