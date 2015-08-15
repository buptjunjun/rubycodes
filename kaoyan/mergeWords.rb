require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'
require 'open-uri'


#根据单词抓取它相应的图片.

#数据库建立连接,datable.yml是配置文件
dbconfig = YAML::load(File.open('database1.yml'))
ActiveRecord::Base.establish_connection(dbconfig)

class WordBookTopicsOffline < ActiveRecord::Base
  self.table_name = "word_book_topics_offline"
end

words = WordBookTopicsOffline.where("word_level_id=?",13).map{|item| item.word}
puts words.size

words1 = []
File.open("yuedu.text").each do |line|
  ws = line.split(/[,|\.|\s+]/)
  words1+=ws
end

words2 = words1.select{|w| not w.blank?}.map{|item| item.downcase}

words3 = words2 & words
words4 = words2 - words

file = File.open("yuedu.text")
content = file.read
file.close

File.open("yuedu.text").each do |line|
  ws = line.split(/[,|\.|\s+|-]/)
  ws1 = []
  ws.each do |item|
    if words.(item.downcase)
      item = "("+item+")"
    end
    ws1 << item
  end
  puts ws1.join(" ")
end
