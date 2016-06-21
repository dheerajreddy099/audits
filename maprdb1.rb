
execute "Install oracle-java8-jdk_8u45_amd64.deb" do
  command "wget http://#{node[:ywApp][:repoip]}/jdks/oracle-java8-jdk_8u45_amd64.deb && sudo dpkg -i oracle-java8-jdk_8u45_amd64.deb"
not_if { File.exist?("/usr/lib/jvm/jdk-8-oracle-x64/bin/java") }
end

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

template "/etc/hosts" do
  source "maprhosts"
  mode 0644
  owner "root"
  group "root"
end


execute "apt-get update -y" do
  command "apt-get update -y"
end


#package "ntp" do
#action :install
#end

#service "ntp" do
#supports :status => true, :restart => true, :reload => true
#action [:enable,:start]
#end

%w{nfs-common iputils-arping libsysfs2 dnsutils syslinux netcat sdparm sysstat python-pycurl openssl sshpass }.each do |pkg|
  package pkg do
    action :install
  end
end

%w{adduser gawk bash coreutils dmidecode dpkg-repack grep hdparm iputils-arping irqbalance libc6 libgcc1 libstdc++6 lsb-base nfs-common perl procps sdparm sed syslinux sysvinit-utils unzip zip netcat dpkg-dev apache2}.each do |pkg|
  package pkg do
    action :install
  end
end
%w{mapr-cldb mapr-zookeeper mapr-nfs mapr-webserver mapr-metrics mapr-jobtracker mapr-tasktracker}.each do |pkg|
  package pkg do
    action :install
   options "--force-yes"
  end
end
template "/opt/mapr/conf/env.sh" do 
  source "env.sh"
  mode 0755
  owner "root"
  group "root"
end

execute " configure maprdb " do 
command " sudo /opt/mapr/server/configure.sh -C #{node["ywApp"]["cldb_list"]}  -Z #{node["ywApp"]["zk_list"]} -N #{node["ywApp"]["clustername"]} " 

end 
 
template "/opt/disk.txt" do
source "disk.txt"
mode 0644
owner "ywapp"
group "ywapp"
end

execute "disk setting " do  
command "sudo /opt/mapr/server/disksetup -F /opt/disk.txt" 
end
cookbook_file "/opt/vol" do 
source "vol" 
mode 0777
owner "ywapp"
group "ywapp"
action :create 
end
service "mapr-zookeeper" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

service "mapr-warden" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

service "mapr-cldb" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

execute "making owner ywapp to /opt/mapr" do 
command "sudo chmod 644 /opt/mapr/hadoop/hadoop-2.5.1/etc/hadoop/yarn-site.xml" 
end

#execute "adding default gatway of webnet" do
# command "sudo route add -net 192.168.102.0 netmask 255.255.255.0 gw 192.168.102.1 && touch /var/webflag"
#not_if { File.exist?("/var/webflag") }
#end

#execute "adding default gatway of dbnet" do
# command "sudo route add -net 192.168.100.0 netmask 255.255.255.0 gw 192.168.100.1 && touch /var/dbflag"
#not_if { File.exist?("/var/dbflag") }
#end

#execute "volume creation " do
#command " sh /opt/vol"
#end

#bash "volume creating and  giving permission to user" do 
#user "root"
#group "root"
#code <<-EOH
#sudo maprcli acl edit -type cluster -user root:login,fc,a
#EOH
#end

#bash "permission to user ywapp" do 
#user "root"
#group "root"
#code <<-EOH
#sudo maprcli acl edit -type cluster -user ywapp:login,fc,a
#EOH
#end

#bash "volume1 creating " do
#user "ywapp"
#group "ywapp"
#code <<-EOH
#maprcli volume create -name volume1  -path /volume1  -type rw -ae ywapp -aetype 0 -user ywapp:fc root:fc
#EOH
#end

#bash "volume2 creatin  " do 
#user "ywapp"
#group "ywapp"
#code <<-EOH
#maprcli volume create -name volume2  -path /volume2  -type rw -ae ywapp -aetype 0 -user ywapp:fc root:fc
#EOH
#end
