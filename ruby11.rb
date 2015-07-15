#encoding: UTF-8
require 'fileutils'

puts "hello from ruby11.rb"

array = [1,2,3]
array.delete_at(1)
puts array

array.each do  |item|
  if item ==  1
    break;
  end
  puts item
end1423912380495


FileUtils.cp("/tmp/.jpg","/User/junjun/documents/")