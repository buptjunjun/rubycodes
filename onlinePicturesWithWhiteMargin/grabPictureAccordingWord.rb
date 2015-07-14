require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'
require 'open-uri'


#根据单词抓取它相应的图片.

#数据库建立连接,datable.yml是配置文件
dbconfig = YAML::load(File.open('grabImageFileWithWhiteGap/database1.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
logger = Logger.new("./grabImageFileWithWhiteGap/"+Time.new.strftime("%Y-%m-%d%H%m%S")+".log")
logger.level = Logger::INFO

class Question < ActiveRecord::Base
  self.table_name = "question"
  def attr (attr_name)
    return Attr.find_by_question_id_and_attr_name(self.id,attr_name)
  end
end

class Attr < ActiveRecord::Base
  self.table_name = "attr"
end