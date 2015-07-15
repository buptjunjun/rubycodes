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
dbconfig = YAML::load(File.open('/User/junjun/projects/projects4ruby/ZhuaNiuBackend/qmMendData/database1.yml'))

ActiveRecord::Base.establish_connection(dbconfig)
dir = "/Users/Admin/Documents/workspace/qm/WebRoot/upload/"
host = "http://baicizhan.qiniucdn.com/cropped_images/"

if not  Dir.exist?('./log/')
  Dir.mkdir("./log/")
end

if not  Dir.exist?('./files/')
  Dir.mkdir("./files/")
end

logger = Logger.new("./log/"+Time.new.strftime("%Y-%m-%d%H%m%S")+".log")
logger.level = Logger::INFO

class Attr < ActiveRecord::Base
  self.table_name = "attr"
end

image_file_count = Attr.where("attr_name = 'image_file'").count
puts image_file_count

Attr.transaction do
  Attr.where("attr_name = ? and change_history is not null" ,'word_audio_name').order("create_date desc").each_with_index do |attr,index|
      sizeAttr = Attr.find_by_question_id_and_attr_name(attr.question_id,"image_size")
  end
end

logger.close