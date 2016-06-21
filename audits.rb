`sudo rm /var/audit.log`
f = File.new("/var/audit.log", "a+")
for i in 0..30 do  f.print "====" end

f.print "\n2.1 Create Separate Partition for /tmp (Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = ` grep "[[:space:]]/tmp[[:space:]]" /etc/fstab`
opt = ''
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND :grep \"[[:space:]]/tmp[[:space:]]\" /etc/fstab"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts "Comment : /tmp should be separate partition "
for i in 0..10 do  f.print "====" end

f.print "\n2.2 Set nodev option for /tmp Partition(Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = ` grep /tmp /etc/fstab | grep nodev`
cmd2 = `mount | grep /tmp | grep nodev`
opt = ''    
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'') or cmd2.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND :grep /tmp /etc/fstab | grep nodev;mount | grep /tmp | grep nodev"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts " #{cmd2} "
f.puts "Comment : there should be nodev option in output "
for i in 0..10 do  f.print "====" end

f.print "\n2.3 Set nosuid option for /tmp Partition (Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = ` grep /tmp /etc/fstab | grep nosuid`
cmd2 = `mount | grep /tmp | grep nosuid`
opt = ''
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'') or cmd2.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND :grep /tmp /etc/fstab | grep nosuid;mount | grep /tmp | grep nosuid"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts " #{cmd2} "
f.puts "Comment : there should be nosuid option in output "
for i in 0..10 do  f.print "====" end

f.print "\n2.4 Set noexec option for /tmp Partition (Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = `grep /tmp /etc/fstab | grep noexec`
cmd2 = `mount | grep /tmp | grep noexec`
opt = ''
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'') or cmd2.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND :grep /tmp /etc/fstab | grep noexec ;mount | grep /tmp | grep noexec"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts " #{cmd2} "
f.puts "Comment : there should be noexec option in output "
for i in 0..10 do  f.print "====" end

f.print "\n2.5 Create Separate Partition for /var (Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = `grep "[[:space:]]/var[[:space:]]" /etc/fstab`
opt = ''
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND : grep \"[[:space:]]/var[[:space:]]\" /etc/fstab"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts "Comment : /var should be separate partition "
for i in 0..10 do  f.print "====" end

f.print "\n2.6 Bind Mount the /var/tmp directory to /tmp (Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = `grep -e "^/tmp" /etc/fstab | grep /var/tmp`
cmd2 = `mount | grep -e "^/tmp" | grep /var/tmp`
opt = ''
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'') or cmd2.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND :grep -e \"^/tmp\" /etc/fstab | grep /var/tmp ;mount | grep -e \"^/tmp\" | grep /var/tmp"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts " #{cmd2} "
f.puts "Comment : none"
for i in 0..10 do  f.print "====" end

f.print "\n2.7 Create Separate Partition for /var/log (Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = `grep "[[:space:]]/var/log[[:space:]]" /etc/fstab`
opt = ''
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND : grep \"[[:space:]]/var/log[[:space:]]\" /etc/fstab"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts "Comment : /var/log should be separate partition "
for i in 0..10 do  f.print "====" end

f.print "\n2.8 Create Separate Partition for /var/log/audit (Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = `grep "[[:space:]]/var/log/audit[[:space:]]" /etc/fstab`
opt = ''
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND : grep \"[[:space:]]/var/log/audit[[:space:]]\" /etc/fstab"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts "Comment : /var/log/audit should be separate partition "
for i in 0..10 do  f.print "====" end

f.print "\n2.9 Create Separate Partition for /home (Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = `grep "[[:space:]]/home[[:space:]]" /etc/fstab`
opt = ''
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND : grep \"[[:space:]]/home[[:space:]]\" /etc/fstab"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts "Comment : /home should be separate partition "
for i in 0..10 do  f.print "====" end

f.print "\n2.10 Add nodev Option to /home (Scored)"
for i in 0..10 do  f.print "---" end
f.print "STATUS : "
cmd = `grep /home /etc/fstab | grep nodev`
cmd2 = `mount | grep /home | grep nodev`
opt = ''
status = if cmd.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'') or cmd2.gsub(/\s+/,'') ==  opt.gsub(/\s+/,'')  then "NOT OK" else " OK " end
f.puts " #{status} "
f.puts "COMMAND :mount | grep /home | grep nodev ;mount | grep /home | grep nodev"
f.puts "OUTPUT  :"
f.puts " #{cmd} "
f.puts " #{cmd2} "
f.puts "Comment : output should contain nodev option "
for i in 0..10 do  f.print "====" end

