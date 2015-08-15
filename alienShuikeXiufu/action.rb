#encoding:utf-8

require "json"
jsonFile = "/Users/Admin/Downloads/need_change.txt"

jsonContent = File.open(jsonFile).read();
#puts jsonContent
content = JSON.parse(jsonContent)

class WordBookTopicsOffline < ActiveRecord::Base
  self.table_name = "word_book_topics_offline"
end

content.each do |word_level_id, topic_ids|
  puts "开始修改#{word_level_id}"
  topic_ids.each do |topic_id|
    puts "#{word_level_id}, #{topic_id}"
    wbto = WordBookTopicsOffline.where("word_level_id=? and topic_id=?",word_level_id,topic_id)
  end
end

