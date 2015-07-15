#encoding:utf-8

require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'
require 'open-uri'
require "mini_magick"
require 'mp3info'
require 'fileutils'

#数据库建立连接,datable.yml是配置文件
dbconfig = YAML::load(File.open('./database1.yml'))
ActiveRecord::Base.establish_connection(dbconfig)

if not Dir.exist?('./log/')
  Dir.mkdir("./log/")
end


logger = Logger.new("./log/"+Time.new.strftime("%Y-%m-%d%H%m%S")+".log")


if not Dir.exist?('./files/')
  Dir.mkdir("./files/")
end

if not Dir.exist?('./files/sentence_audio')
  Dir.mkdir("./files/sentence_audio/")
end

if not Dir.exist?('./files/word_audios')
  Dir.mkdir("./files/word_audios/")
end

class Attr < ActiveRecord::Base
  self.table_name = "attr"
end

#------

BaseDirTo = "/var/www/data/talent_data/check_mp3_20150715/"
BaseDirFrom = "/var/www/data/qmupload/"

audio_files = []
word_audio_files = []

Attr.where("attr_name = 'word_audio_name' and change_history is not null ").order("create_date desc").each_with_index do |attr,index|
  if not word_audio_files.include? attr.content
    file1 = BaseDirFrom+attr.content
    file2 = BaseDirTo+attr.content
    if File.exist? file1
       FileUtils.cp(file1, file2)
    end
    logger.info("copy #{attr.content} to #{attr.content}")
  end
end

Attr.where("attr_name = 'audio_file' and change_history is not null ").order("create_date desc").each_with_index do |attr,index|
  if not audio_files.include? attr.content
    file1 = BaseDirFrom+attr.content
    file2 = BaseDirTo+attr.content
    if File.exist? file1
      FileUtils.cp(file1, file2)
    end
    logger.info("copy #{attr.content} to #{attr.content}")
  end
end

logger.close
