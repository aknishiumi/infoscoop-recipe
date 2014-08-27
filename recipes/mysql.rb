#
# Cookbook Name:: infoscoop
# Recipe:: mysql
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# MySQLインストール
%w{mysql mysql-devel mysql-server}.each do |package_name|
    package package_name do
      action :install
    end
end

# templateによるmy.cnf置き換え
template "/etc/my.cnf" do
    source "my.cnf.erb"
    owner "mysql"
    group "mysql"
    mode "0644"
end

# MySQLスタート
service "mysqld" do
    supports status: true, restart: true, reload: true
    action   [ :enable, :start ]
end