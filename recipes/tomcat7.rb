#
# Cookbook Name:: infoscoop
# Recipe:: tomcat7
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# リポジトリ(JPackage)の追加
package "yum-plugin-priorities" do
    action :install
end
remote_file "/tmp/jpackage-release-6-3.jpp6.noarch.rpm" do
    source "http://mirrors.dotsrc.org/jpackage/6.0/generic/free/RPMS/jpackage-release-6-3.jpp6.noarch.rpm"
    mode 00644
end
rpm_package "jpackage-release-6-3" do
    source "/tmp/jpackage-release-6-3.jpp6.noarch.rpm"
    options "-Uvh"
    action :install
end

# Tomcatインストール
package "tomcat7" do
    options "--nogpgcheck"
    action :install
end

# templateによるinfoscoop.xml置き換え
template "/usr/share/tomcat7/conf/Catalina/localhost/infoscoop.xml" do
    source "infoscoop.xml.erb"
    owner "tomcat"
    group "tomcat"
    mode "0644"
end

# mysql-connectorインストール
package "mysql-connector-java" do
    action :install
end

# mysql-connectorのシンボリックリンク作成
link "/usr/share/tomcat7/lib/mysql-connector-java.jar" do
    action :delete
end
execute "mysql-connector-symboliclink" do
    command "ln -s /usr/share/java/mysql-connector-java-*.jar /usr/share/tomcat7/lib/mysql-connector-java.jar"
    creates "/usr/share/tomcat7/lib/mysql-connector-java.jar"
end
