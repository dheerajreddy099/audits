#user "ywapp" do
#    comment "user for web application "
#    home "/home/ywapp"
#    shell "/bin/bash"
#    supports  :manage_home => true
# password "$1$vkCALzXp$BAdZDSeui13uMKue8bC0d."
#end

#execute " making ywapp  sudoer " do 
#command "usermod -a -G sudo ywapp" 
#end 
TMPS='/dev/shm'
 
execute "Adding mapr GPG key" do
  command "wget -O - http://#{node[:ywApp][:repoip]}/mapr/maprgpg.key | sudo apt-key add -"
end
template "/etc/apt/sources.list.d/mapr.list" do
  source "mapr.list"
  mode 0644
  owner "root"
  group "root"
end
template "/etc/apt/sources.list" do
  source "sources.list"
  mode 0644
  owner "root"
  group "root"
end

execute "apt-get update -y" do
  command "apt-get update -y"
end
template "/etc/hosts" do
  source "hosts"
  mode 0644
  owner "root"
  group "root"
end

execute "Install oracle-java8-jdk_8u45_amd64.deb" do
  command "wget http://#{node[:ywApp][:repoip]}/jdks/oracle-java8-jdk_8u45_amd64.deb && sudo dpkg -i oracle-java8-jdk_8u45_amd64.deb"
not_if { File.exist?("/usr/lib/jvm/jdk-8-oracle-x64/bin/java") }
end

bash " java solution :: JCE unlimited strength jurisdiction policy" do
code <<-EOH
sudo rm /usr/lib/jvm/jdk-8-oracle-x64/jre/lib/security/local_policy.jar
sudo rm /usr/lib/jvm/jdk-8-oracle-x64/jre/lib/security/US_export_policy.jar
sudo wget http://#{node[:ywApp][:repoip]}/jdks/jce_policy-8/US_export_policy.jar  -P /usr/lib/jvm/jdk-8-oracle-x64/jre/lib/security/
sudo wget http://#{node[:ywApp][:repoip]}/jdks/jce_policy-8/local_policy.jar -P /usr/lib/jvm/jdk-8-oracle-x64/jre/lib/security/
sudo chmod 644 /usr/lib/jvm/jdk-8-oracle-x64/jre/lib/security/US_export_policy.jar
sudo chmod 644 /usr/lib/jvm/jdk-8-oracle-x64/jre/lib/security/local_policy.jar && sudo touch /var/javaflag  
EOH
not_if { File.exist?("/var/javaflag") }
end


package "mapr-client" do
  action :install
  options "--force-yes"
end

template "/opt/mapr/conf/env.sh" do
  source "env.sh"
  mode 0755
  owner "root"
  group "root"
end

execute " configure maprdb " do
command "sudo /opt/mapr/server/configure.sh -C #{node["ywApp"]["cldb_list"]} -Z #{node["ywApp"]["zk_list"]} -N #{node["ywApp"]["clustername"]} "
end

package "rabbitmq-server" do
  action :install
end

package "unzip" do 
action :install 
end


execute "server file downloading" do
  command "wget -q http://#{node[:ywApp][:repoip]}/ywapp/server-0.1-SNAPSHOT.zip -O /tmp/server-0.1-SNAPSHOT.zip"
not_if { File.exist?("/home/ywapp/server-0.1-SNAPSHOT") }
end

#user "mapr" do
 #   comment "user for mapr comunication "
   # home "/home/mapr"
   # shell "/bin/bash"
   # supports  :manage_home => true
# password "$1$xxeuzuem$lzK6PG3rzDo8b/gf.AYf11"
#execute " making ywapp  sudoer " do 
#command "usermod -a -G sudo ywapp" 
#end 

bash "code extracting to ywapp " do 
code <<-EOH
unzip /tmp/server-0.1-SNAPSHOT.zip -d /home/ywapp/
chown -R ywapp:ywapp /home/ywapp
cd /home/ywapp/server-0.1-SNAPSHOT/scripts/init/
chmod 777 installAsService.sh
sudo ./installAsService.sh
EOH
not_if { File.exist?("/home/ywapp/server-0.1-SNAPSHOT") }
end 
 
execute " service starting " do 
command " sudo service yw-appserver  start" 
end 
# for testing used to create bulk log 
#cookbook_file "/var/log/a.sh" do
 # source "a.sh"
 # mode 0777
 # owner "root"
 # group "root"
# action :create 
#end

#execute "chmod +x /var/log/a.sh " do 
#command "chmod +x /var/log/a.sh  "
#end 
service "yw-appserver" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

service "rabbitmq-server" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

execute "setting permission on yarn-site.xml" do
command " sudo chmod 644 /opt/mapr/hadoop/hadoop-2.5.1/etc/hadoop/yarn-site.xml"
end
#execute "adding default gatway for webnet" do
# command "sudo route add -net 192.168.102.0 netmask 255.255.255.0 gw 192.168.104.200 && touch /var/webflag"
#not_if { File.exist?("/var/webflag") }
#end

#execute "adding default gatway of cryptonet" do
# command "sudo route add -net 192.168.101.0 netmask 255.255.255.0 gw 192.168.101.200 && touch /var/cryptoflag"
#not_if { File.exist?("/var/cryptoflag") }
#end

#execute "adding default gatway of dbnet" do
# command "sudo route add -net 192.168.100.0 netmask 255.255.255.0 gw 192.168.100.200 && touch /var/dbflag"
#not_if { File.exist?("/var/dbflag") }
#end

