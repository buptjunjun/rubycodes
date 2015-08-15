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
image_file_host = "http://baicizhan.qiniucdn.com/cropped_images/"
xiangxing_file_host = "http://baicizhan.qiniucdn.com/df_transparent/"

logger1 = Logger.new("./log/output."+Time.new.strftime("%Y-%m-%d%H%m%S")+".log")
logger2 = Logger.new("./log/error."+Time.new.strftime("%Y-%m-%d%H%m%S")+".log")
logger1.level = Logger::INFO
logger2.level = Logger::INFO

class WordBookTopicsOffline < ActiveRecord::Base
  self.table_name = "word_book_topics_offline"
end

image_size_cache = {}
df_size_cache={}

WordBookTopicsOffline.find_by_sql("select w.* from word_book_topics_offline as w inner join (select word_level_id, topic_id, tag_id, max(version) as maxversion from `word_book_topics_offline` group by word_level_id, topic_id,tag_id) as m  on w.tag_id = m.tag_id and w.version = m.maxversion and w.topic_id = m.topic_id and w.word_level_id = m.word_level_id").each_with_index do |wbto,index|
   retrycount = 0
   begin
      image_size = -1;
      url1 = image_file_host + wbto.image_file
      if image_size_cache.include?(wbto.image_file)
          image_size = image_size_cache[wbto.image_file]
          puts "get from image_size_cache"
      else
          image1 = MiniMagick::Image.open(url1)
          image_size = image1.size
          image_size_cache[wbto.image_file] = image_size
      end

      if image_size > 0
        wbto.image_size = image_size
      end
      puts "#{wbto.word_level_id},#{wbto.topic_id},#{wbto.version}  #{url1}->#{image_size}"

      xiangxing_image_size = -1
      if wbto.deformation_img_url
          url2 = xiangxing_file_host + wbto.deformation_img_url
          if df_size_cache.include?(wbto.deformation_img_url)
            xiangxing_image_size = df_size_cache[wbto.deformation_img_url]
            puts "get from df_size_cache"
          else

            image2 = MiniMagick::Image.open(url2)
            xiangxing_image_size = image2.size
            df_size_cache[wbto.deformation_img_url] = xiangxing_image_size
          end

          if xiangxing_image_size > 0
            wbto.deformation_img_size = xiangxing_image_size
          end

          puts "#{wbto.word_level_id},#{wbto.topic_id},#{wbto.version} #{url2}->#{xiangxing_image_size}"
      end

      saveret = false
      if image_size > 0
        saveret = wbto.save
      end

      puts "#{index} -- #{wbto.word_level_id},#{wbto.topic_id},#{wbto.version} ---- save #{saveret} -----"
      logger1.info("#{index} -- #{wbto.word_level_id},#{wbto.topic_id},#{wbto.version} ---- save #{saveret} -----")

      if index % 5 == 1
        sleep 1
      end

   rescue =>e
      if retrycount == 0
        logger2.error("#{wbto.id} -- #{wbto.inspect} -- #{e.inspect}")
      else
        logger2.error("retry #{wbto.id} -- #{wbto.inspect} -- #{e.inspect}")
      end

      retrycount += 1
      if retrycount < 3
        retry
      end
   end
end


logger1.close
logger2.close