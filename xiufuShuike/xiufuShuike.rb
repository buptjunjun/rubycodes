#encoding:utf-8

require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'
require 'open-uri'
require "mini_magick"

#根据单词抓取它相应的图片.
MiniMagick.configure do |config|
  config.cli = :imagemagick
  config.timeout = 10
end

#数据库建立连接,datable.yml是配置文件
dbconfig = YAML::load(File.open('./database1.yml'))

ActiveRecord::Base.establish_connection(dbconfig)
logger1 = Logger.new("./log/output."+Time.new.strftime("%Y-%m-%d%H%m%S")+".log")
logger1.level = Logger::INFO

class WordBookTopicsTest < ActiveRecord::Base
  self.table_name = "word_book_topics_test"
end

class DataOperationLog < ActiveRecord::Base
  self.table_name = "data_operation_log"
end

succeed = "test_succeed";

word_level_ids_str = %{
1
4
21
31
32
33
34
35
36
37
38
39
40
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
91
93
94
95
96
97
99
100
101
102}

word_level_ids = word_level_ids_str.split()
word_level_ids.each do |id|
    word_level_id = id.to_i
    logger1.info("start update book #{word_level_id} ok")
    puts "start update book #{word_level_id} ok"

    DataOperationLog.transaction do
      WordBookTopicsTest.where("word_level_id=?",word_level_id).each_with_index do |wbto,index|
        dols = DataOperationLog.where("word_level_id = ? and topic_id = ? and tag_id=? and version=? and action = ?", wbto.word_level_id, wbto.topic_id, wbto.tag_id, wbto.cur_version,succeed)
        if not dols or dols.size == 0
          dol = DataOperationLog.new({:word_level_id=>wbto.word_level_id, :topic_id => wbto.topic_id, :tag_id=>wbto.tag_id, :version=>wbto.cur_version,:action=>succeed})
          if dol.save
            logger1.info(dol.inspect + " ok")
            puts dol.inspect + " ok"
          else
            logger1.info(dol.inspect + " fail")
            puts dol.inspect + " fail"
          end
        end
      end
    end

end
logger1.close