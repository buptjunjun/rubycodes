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
dbconfig = YAML::load(File.open('database1.yml'))

ActiveRecord::Base.establish_connection(dbconfig)
dir = "/var/www/data/qmupload/"
host = "http://baicizhan.qiniucdn.com/df_transparent/"

if not  Dir.exist?('./log/')
  Dir.mkdir("./log/")
end

if not  Dir.exist?('./files/')
  Dir.mkdir("./files/")
end

logger = Logger.new("./log/d"+Time.new.strftime("%Y-%m-%d%H%m%S")+".log")
logger.level = Logger::INFO

class Attr < ActiveRecord::Base
  self.table_name = "attr"
end

image_file_count = Attr.where("attr_name = 'deformation_img_url'").count
puts image_file_count

Attr.transaction do
  Attr.where("attr_name = 'deformation_img_url' ").order("create_date desc").each_with_index do |attr,index|
    sizeAttr = Attr.find_by_question_id_and_attr_name(attr.question_id,"deformation_img_size")

      file_path = nil
      size = -1
      if attr.content.nil? or attr.content.empty?
	next      
      end

      file_path = dir + attr.content
      isvalid = false
      if File.exist? file_path
        begin
          image = MiniMagick::Image.open(file_path)
          isvalid = image.valid?
          size = File.size(file_path)
        rescue Exception => e
          logger.error("#{index} - #{isvalid}  #{attr.question_id} #{file_path} #{sizeAttr.content} #{size} #{e.inspect}")
        end
      else
        trycount = 0
        file_path = host + attr.content
        begin
          trycount += 1 #重复3次
          file_path = host + attr.content
          image = MiniMagick::Image.open(file_path)
          isvalid = image.valid?
          size = image.size
        rescue Exception => e
          logger.error("#{index} - #{isvalid}  #{attr.question_id} #{file_path} #{sizeAttr.content} #{size} #{e.inspect}")

          if trycount < 3
            retry
          end

        end
      end

      if size > 0 and size != sizeAttr.content.to_i
        old_size = sizeAttr.content
        sizeAttr.content = size
        sizeAttr.modified = 1

        history = sizeAttr.change_history
        if not sizeAttr.change_history
          history = "null";
        end

        sizeAttr.change_history = history + "|系统在#{Time.new.strftime("%Y-%m-%d %H:%m:%S")}修改过(image_size不一样)"
        sizeAttr.content = size;
	sizeAttr.last_modify_date = Time.new
        sizeAttr.save

        puts "#{index} #{isvalid} #{attr.question_id} #{file_path} #{old_size} #{size}"
        logger.info("#{index} #{isvalid} #{attr.question_id} #{file_path} #{old_size} #{size}")
      end

  end
end

logger.close
