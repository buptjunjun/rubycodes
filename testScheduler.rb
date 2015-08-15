#encoding: UTF-8
#测试定时任务
require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new

 puts Time.new
 puts 'process begin----'
 scheduler.cron '/1 * * * *' do
     puts Time.new
     puts 'Hello word'
   end
 scheduler.join