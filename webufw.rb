

execute "ufw enable" do
 command "ufw --force enable"
end

execute "allow ssh for temporary use " do 
command "ufw allow 22" 
end 
# allow haproxy  
execute "allow from haproxy only " do
 command "ufw allow in from #{node[:ywApp][:haproxy]} to #{node[:ywApp][:webnet]}  port 8192  proto tcp"
end
#allow local repo 
#execute "allow httptorepo" do
 # command "sudo ufw allow in from #{node[:ywApp][:repoip]}  to #{node[:ywApp][:webnet]} port #{node[:ywApp][:repoport]} proto tcp"
#end

# allow maprdb network 
execute "Allow any incoming from maprdb  n/w only" do
  command "ufw allow in from #{node[:ywApp][:dbnet]} proto tcp to #{node[:ywApp][:dbnet]}"
end
#execute "Allow any outgoing from maprdb n/w only" do
#  command "ufw allow out from #{node[:ywApp][:dbnet]} proto tcp to #{node[:ywApp][:dbnet]}"
#end
#allow crypto network rule 
execute "Allow any incoming from cryptonet  n/w only" do
  command "ufw allow in from #{node[:ywApp][:cryptonet]} proto tcp to #{node[:ywApp][:cryptonet]} port 9443"
end

#allow webnet network rule 
execute "Allow any incoming from webnet  n/w only" do
  command "ufw allow in from #{node[:ywApp][:webnet]} proto tcp to #{node[:ywApp][:webnet]} port 8192,5672,4369"
end

# deny outgoing and incoming 
execute "ufw deny incoming" do
  command "sudo ufw default deny incoming"
end
#execute "ufw deny outgoing" do
#  command "sudo ufw default deny outgoing"
#end
