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
dbconfig = YAML::load(File.open('database1.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
logger = Logger.new(""+Time.new.strftime("%Y-%m-%d%H%m%S")+".log")

class Attr < ActiveRecord::Base
  self.table_name = "attr"
end


def checkImage
  count = 0
  directories = ["/User/junjun/documents/白边713" , "/User/junjun/documents/白边724"]
  directories.each do |dir|
    queue = [dir]
    while not queue.empty?
        file = queue.delete_at(0)
        if File.exist?(file) && File.file?(file)
           if file =~ /.*[jpg|png|gif]$/
             begin
              image1 = MiniMagick::Image.open(file)
              if 1.3333 <  (image1.width.to_f / image1.height) && image1.size < 100000
                puts "#{file} ok #{image1.size}"
                FileUtils.cp(file,"/User/junjun/documents/whitespaceImage/20150729/i_wm_"+File.basename(file))
              else
                puts "#{file} fail #{image1.size}"
              end

             rescue => e
               puts "#{file} failed #{e.inspect}"
             end
           end
        elsif File.exist?(file) && File.directory?(file)
          files = Dir.foreach(file).select {|item| "/"+item if not [".",".."].include?(item)}.map{|item| file+"/"+item}
           queue+=files
        end
    end
  end
end


def replay
  directories = ["/User/junjun/documents/白边713" , "/User/junjun/documents/白边724"]
  directories.each do |dir|
    queue = [dir]
    while not queue.empty?
      file = queue.delete_at(0)
      if File.exist?(file) && File.file?(file)
        if file =~ /.*[jpg|png|gif]$/
          puts "#{file} ok "
          fileName = File.basename(file)
          attrs = Attr.where("content = ?",fileName)

          if  attrs && attrs.size != 0
              new_file_name = "i_wm_"+fileName
              attrs.each do |attr|

                attr.content = new_file_name;
                attr.modified = 1
                attr.change_history = (attr.change_history == nil ? "null": attr.change_history) + "|" + "admin在#{Time.new}修复改带白边的主图#{fileName}->#{new_file_name}"

                if attr.save
                  puts "#{attr.inspect} save ok"
                else
                  puts "#{attr.inspect} save failed"
                end
              end
          end

        end
      elsif File.exist?(file) && File.directory?(file)
        files = Dir.foreach(file).select {|item| "/"+item if not [".",".."].include?(item)}.map{|item| file+"/"+item}
        queue+=files
      end
    end
  end
end


#checkImage()
replay()