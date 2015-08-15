#encoding:utf-8

lines = File.open("/Users/Admin/Documents/workspace/测试项目/asdfasdf.txt").readlines()
lines = lines.map{|line| line.strip}
puts lines.join(",")


begin
  1/0;
rescue =>e
  puts e.backtrace.inspect
  puts
end



