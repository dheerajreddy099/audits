##################################################### Not implemented ##########################################################
#3.3 Set Boot Loader Password (Scored)
#4.5 Activate AppArmor (one part is not implemented : Remove apparmor=0 from all kernels in /boot/grub/menu.lst ) 
#5.1.2 Ensure rsh server is not enabled (package is uninstalled but need to recheck )
#6.7 Ensure NFS and RPC are not enabled (need to create template )
#6.15 Configure Mail Transfer Agent for Local-Only Mode
#8.1.12 Collect Use of Privileged Command
#8.2.4 Create and Set Permissions on rsyslog Log Files (need to configure Manually )
#8.2.5 Configure rsyslog to Send Logs to a Remote Log Host (need to configure manually )
#8.3.2 Implement Periodic Execution of File Integrity
#9.4 Restrict root Login to System Console(need mannual config)

#####################################################Above stuff is not implemented ###########################################

#### Extra security #####
# remove user games , news , irc etc. 
%w{games news irc }.each do |username|
  user username do
  action :remove
  end
end
### remove group 
%w{staff audio  video fax floppy cdrom sambashare users voice}.each do |grp|
  group grp do
  action :remove
  end
end

#entropy configuration
package "haveged" do 
action :install
end

package "rng-tools" do 
action :install
end

template "/etc/init/rng-tools-entropy.conf" do
 source 'rng-tools-entropy.conf'
 mode 0644
 owner "root"
 group "root"
end

#Chapter 1
#1.1 Install Updates, Patches and Additional Security Software
execute "apt-get update;apt-get --just-print upgrade" do 
action :run 
end 
#Chapter 2
#2.17 Set Sticky Bit on All World-Writable Directories
execute "df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t " do 
action :run 
end 



#Chapter 3:3 Secure Boot Setting
#3.1 Set User/Group Owner on bootloader config
execute "chown root:root /boot/grub/grub.cfg " do 
action :run 
end 

#3.2 Set Permissions on bootloader config 
execute "chmod og-rwx /boot/grub/grub.cfg" do 
action :run 
end 

#3.4 Require Authentication for Single-User Mode
#puts "enter password for root user ? : that required for  Single-User Mode"
#execute "passwd root"  do 
#action :run 
#end 


#Chapter 4: Additional Process Hardening
#4.1 Restrict Core Dumps
execute "/sbin/sysctl -w fs.suid_dumpable=0 " do 
action :run
end 
template "/etc/security/limits.conf" do 
source "limits.conf"
owner "root"
group "root"
mode  0644
end 
#4.2 Enable XD/NX Support on 32-bit x86 Systems (Not Required we using 64 bit system )
#4.3 Enable Randomized Virtual Memory Region Placement 
execute "/sbin/sysctl -w kernel.randomize_va_space=2" do
action :run
end
# 4.4 Disable Prelink (mentioned in Package list : already implemented )
#4.5 Activate AppArmor (Package is installed with all package list: on thing is not implemented ) 

#execute "aa-enforce /etc/apparmor.d/*" do
#action :run
#end

#Chapter 5
#5.1.2 #5.1.4 #5.1.6 #5.1.7 #5.1.8 #5.2 #5.3 #5.4 #5.5.6 #6.2 #6.2 #6.3 #6.4 #6.6 #6.7 #6.9 #6.11 #6.12 #6.13
%w{rsh rlogin rcp talk ntalk telnet tftp xinetd chargen daytime echo discard time avahi-daemon cups isc-dhcp-server isc-dhcp-server6 slapd rpcbind-boot vsftpd dovecot smbd squid3 snmpd rsyncd }.each do |s| 
service s do
action :stop
end
end

#Chapter 6 
#6.5 Configure Network Time Protocol (NTP)
template "/etc/ntp.conf" do 
source "ntp.conf" 
owner "root" 
group "root"
mode 0644
end 
#6.8 Ensure DNS Server is not enabled
#execute "rm /etc/rc*.d/S*bind9" do 
#action :run 
#end
#6.14 Ensure SNMP Server is not enabled
#execute "rm /etc/rc*.d/S*snmpd" do 
#action :run
#end 



#12.1 Verify Permissions on /etc/passwd #12.4
file "/etc/passwd" do 
owner "root"
group "root"
mode 0644 
end
#12.3 Verify Permissions on /etc/group #12.6
file "/etc/group" do 
owner "root"
group "root"
mode 0644 
end
#12.2 Verify Permissions on /etc/shadow #12.5
file "/etc/shadow" do 
owner "root"
group "shadow"
mode 0640
end
#3.1 Set User/Group Owner on bootloader config (Scored)
file "/boot/grub/grub.cfg" do 
owner "root"
group "root"
end
#############################################Package Management ###################################################################
# these package should be installed
puts "Package checking process is started !!!"

%w{ apparmor  apparmor-utils ntp tcpd auditd aide  rsyslog openssh-server }.each do |pkg|
  package pkg do 
  action :install
  end
end
# these package should not be install
%w{ nis rsh-client rsh-reload-client talk xserver-xorg-core apache2 biosdevname prelink apport whoopsie }.each do |pkg1|
 package pkg1 do
 action :remove
 end
end
#6.10 Ensure HTTP Server is not enabled
#execute "rm /etc/rc*.d/S*apache2" do 
#action :run 
#end


########################################### Template Management ###################################################################

#7.5 #2.18 #2.19 #2.20 #2.21 #2.22 #2.23 #7.5.1 #7.5.2 # 7.5.3 # 7.5.4 #7.5.5 
template "/etc/modprobe.d/CIS.conf" do 
source "CIS.conf"
action :create 
owner "root"
group "root"
mode 0644
end

# 9.2.1 Set Password Creation Requirement  #9.2.3 Limit Password Reuse
template "/etc/pam.d/common-password" do
source "common-password"
owner "root"
group "root"
mode 0644 
end
 
# 9.2.2 Set Lockout for Failed Password Attempts
template "/etc/pam.d/login" do 
source "login"
owner "root"
group "root"
mode 0644
end

#9.3.1 SSH Setting #9.3.2  #9.3.3 #9.3.4 #9.3.5 #9.3.6 #9.3.7 #9.3.8 #9.3.9 #9.3.10 #9.3.11 #9.3.12
template "/etc/ssh/sshd_config" do 
source "sshd_config"
owner "root"
group "root"
mode 0600
end
# Not Implemented =  #9.3.14 #9.3.13  #9.4 

#9.5 Restrict Access to the su Command
template "/etc/pam.d/su" do
source "su"
owner "root"
group "root"
mode 0644
end
#10.1.1 Set Password Expiration #10.1.2 #10.1.3
template "/etc/login.defs" do
source "login.defs"
owner "root"
group "root"
mode 0644
end

#8.1 configure auditd #8.1.1.1 #8.1.1.2 #8.1.1.3 
template "/etc/audit/auditd.conf" do
source "auditd.conf"
owner "root"
group "root"
mode 0640
end
# 8.1.3 Enable Auditing for Processes That Start Prior to auditd 
template "/etc/default/grub" do
source "grub"
owner "root"
group "root"
mode 0644
end
execute 'update-grub' do
action :run  
end
#8.1.4 Record Events That Modify Date and Time#8.1.5 #8.1.6 #8.1.7 #8.1.8 #8.1.9 #8.1.10  #8.1.11 #8.1.13#8.1.14 #8.1.15#8.1.16#8.1.17#8.1.18  
#8.1.12 Collect Use of Privileged Commands - not implemented 
template "/etc/audit/audit.rules" do
source "audit.rules"
owner "root"
group "root"
mode 0640
end

#Not implemented - #8.2.1 #8.2.2 #8.2.3 #8.2.4 #8.2.5 #8.3 #8.4 
#8.2.6 Accept Remote rsyslog Messages Only on Designated Log Hosts
template "/etc/rsyslog.conf" do
source "rsyslog.conf"
owner "root"
group "root"
mode 0644
end
execute 'pkill -HUP rsyslogd' do
action :run
end

#8.3.1 configure AIDE
#execute "aideinit;cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db ; /usr/sbin/prelink -ua" do 
#action :run
#end

##################################################################################################################################

#9 System Access, Authentication and Authorization #9.1.1 #9.1.2 #9.1.3 #9.1.4 #9.1.5 #9.1.6 #9.1.7 #9.1.8 
execute '/bin/rm /etc/cron.deny;/bin/rm /etc/at.deny;touch /etc/cron.allow;touch /etc/at.allow' do
action :run
end

%w{ /etc/cron.hourly /etc/crontab /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d /etc/at.allow /etc/cron.allow}.each do |files|
  execute "chown root:root #{files}" do
action :run
  end
end

%w{ /etc/cron.hourly /etc/crontab /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d /etc/at.allow /etc/cron.allow}.each do |files1|
execute "chmod og-rwx #{files1}" do 
action :run
    end
end

#7.1.1 Disable IP Forwarding
execute "/sbin/sysctl -w net.ipv4.ip_forward=0 ;/sbin/sysctl -w net.ipv4.route.flush=1" do 
action :run
end 
#7.1.2 Disable Send Packet Redirects 
execute "/sbin/sysctl -w net.ipv4.conf.all.send_redirects=0;/sbin/sysctl -w net.ipv4.conf.default.send_redirects=0;/sbin/sysctl -w net.ipv4.route.flush=1" do
action :run
end 
#7.2 Modify Network Parameters
#7.2.1 Disable Source Routed Packet Acceptance
execute "/sbin/sysctl -w net.ipv4.conf.all.accept_source_route=0;/sbin/sysctl -w net.ipv4.conf.default.accept_source_route=0;/sbin/sysctl -w net.ipv4.route.flush=1" do 
action :run
end

#7.2.2 Disable ICMP Redirect Acceptance
execute "/sbin/sysctl -w net.ipv4.conf.all.accept_redirects=0;/sbin/sysctl -w net.ipv4.conf.default.accept_redirects=0;/sbin/sysctl -w net.ipv4.route.flush=1" do 
action :run
end
#7.2.3 Disable Secure ICMP Redirect Acceptance
execute "/sbin/sysctl -w net.ipv4.conf.all.secure_redirects=0;/sbin/sysctl -w net.ipv4.conf.default.secure_redirects=0;/sbin/sysctl -w net.ipv4.route.flush=1" do 
action :run
end
#7.2.4 Log Suspicious Packets
execute " /sbin/sysctl -w net.ipv4.conf.all.log_martians=1;/sbin/sysctl -w net.ipv4.conf.default.log_martians=1;/sbin/sysctl -w net.ipv4.route.flush=1" do 
action :run
end
#7.2.5 Enable Ignore Broadcast Requests
execute "/sbin/sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1;/sbin/sysctl -w net.ipv4.route.flush=1" do 
action :run
end
#7.2.6 Enable Bad Error Message Protection
execute "/sbin/sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1;/sbin/sysctl -w net.ipv4.route.flush=1" do 
action :run
end
#7.2.7 Enable RFC-recommended Source Route Validation
execute "sbin/sysctl -w net.ipv4.conf.all.rp_filter=1;/sbin/sysctl -w net.ipv4.conf.default.rp_filter=1;/sbin/sysctl -w net.ipv4.route.flush=1" do 
action :run
end
#7.2.8 Enable TCP SYN Cookies
execute "/sbin/sysctl -w net.ipv4.tcp_syncookies=1;/sbin/sysctl -w net.ipv4.route.flush=1" do 
action :run
end

#7.3 Configure IPv6
#7.3.1 Disable IPv6 Router Advertisements
execute "/sbin/sysctl -w net.ipv6.conf.all.accept_ra=0;/sbin/sysctl -w net.ipv6.conf.default.accept_ra=0;/sbin/sysctl -w net.ipv6.route.flush=1" do
action :run
end
#7.3.2 Disable IPv6 Redirect Acceptance
execute "/sbin/sysctl -w net.ipv6.conf.all.accept_redirects=0;/sbin/sysctl -w net.ipv6.conf.default.accept_redirects=0;/sbin/sysctl -w net.ipv6.route.flush=1" do 
action :run
end
#7.3.3 Disable IPv6
execute "/sbin/sysctl -w net.ipv6.conf.all.disable_ipv6=1; /sbin/sysctl -w net.ipv6.conf.default.disable_ipv6=1;/sbin/sysctl -w net.ipv6.conf.lo.disable_ipv6=1" do 
action :run
end
execute "sysctl -p" do 
action :run
end 

#7.4.2 Create /etc/hosts.allow
#7.4.3 Verify Permissions on /etc/hosts.allow
file "/etc/hosts.allow" do 
owner "root"
group "root"
mode 0644
end
#7.4.4 Create /etc/hosts.deny
#7.4.5 Verify Permissions on /etc/hosts.deny
file "/etc/hosts.deny" do 
owner "root"
group "root"
mode 0644 
end
# 7.5 Not implemented - will update soon 

#7.6 Deactivate Wireless Interfaces ("for this network-manager should be install " that is not mentioned in document )
#execute "nmcli nm wifi off " do 
#action :run 
#end 

#7.7 Ensure Firewall is active  #  add rule for ssh allow 
execute "ufw enable;ufw allow  ssh " do 
action :run 
end 

#10.2 Disable System Accounts
bash 'inactive_user_checking' do
code <<-EOH
#!/bin/bash
for user in `awk -F: '($3 < 500) {print $1 }' /etc/passwd`; do
if [ $user != "root" ]
then
/usr/sbin/usermod -L $user
if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]
then
/usr/sbin/usermod -s /usr/sbin/nologin $user
fi
fi
done
EOH
end

#10.3 Set Default Group for root Account
execute "usermod -g 0 root" do 
action :run 
end 
#10.4 Set Default umask for Users ( implemented in template /etc/login.defs )
#10.5 Lock Inactive User Accounts(automatically lock after 35 days ) 
execute "useradd -D -f 35" do 
action :run 
end 

#Chapter 11 Warning Banners
#11.1 Set Warning Banner for Standard Login Services
#11.2 Remove OS Information from Login Warning Banners
template "/etc/motd" do 
source "motd" 
owner "root"
group "root"
mode 0644
end 
template "/etc/issue" do 
source "issue" 
owner "root"
group "root"
mode 0644
end 
template "/etc/issue.net" do 
source "issue.net" 
owner "root"
group "root"
mode 0644
end 

cookbook_file "/tmp/chapter13.sh" do
  source "chapter13.sh"
  mode 0755
end

execute "executing chapter 13 :: for more info type :cat /tmp/output" do
  command "sh /tmp/chapter13.sh"
end 


