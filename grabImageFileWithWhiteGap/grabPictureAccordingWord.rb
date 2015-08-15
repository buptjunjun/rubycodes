require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'
require 'open-uri'


#根据单词抓取它相应的图片.

#数据库建立连接,datable.yml是配置文件
dbconfig = YAML::load(File.open('database1.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
logger = Logger.new(""+Time.new.strftime("%Y-%m-%d%H%m%S")+".log")
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

puts Question.count
q1 = Question.find_by_word("actual")
puts q1.inspect

File.open('whitegap.txt').each_line do |line|
  #puts line

  basedir = "data/"
  qs = Question.find_all_by_word(line.strip!)
  #puts qs
  if qs and qs.size > 0
    word_dir = basedir+line+"/"
    Dir.mkdir word_dir if not File.exist?(word_dir)
    image_files = []

    qs.each do |q|
      image_file_attr = q.attr("image_file")
      image = image_file_attr.content
      if not image_files.include?(image)
        retrycount = 0
        url = 'http://baicizhan.qiniucdn.com/cropped_images/'+image
        begin
          retrycount+=1
          download = open(url)
          IO.copy_stream(download, word_dir+image)
          puts "download #{line} #{url}"
        rescue Exception=>e
          url = 'http://talent.baicizhan.com/qm/upload/'+image
          logger.error("download #{line} #{url} "+e.inspect)
          if retrycount < 3
              puts " retry #{retrycount} download #{line} #{url} "+e.inspect
              retry
          end
        end

      end
    end
    image_files.clear

  end

end

