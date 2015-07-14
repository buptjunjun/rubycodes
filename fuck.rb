#encoding: utf-8
fileName = "/Users/Admin/Downloads/中考例句优化.txt"
content = open(fileName).read();
puts content
words = content.split(',')
puts words.size
puts words[0...359].join(",")
puts words[359...359*2].join(",")
puts words[359*2...359*3].join(",")
puts words[359*3...words.size].join(",")


puts "aaa" + (nil||"")

testvar = 1
if true
  testvar = 2
end
puts testvar
