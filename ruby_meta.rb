# encoding: UTF-8

#ruby元编程实践
puts "一 ruby的方法"
puts "一 ruby的动态派发"

class Test
  #动态定义方法
  "method1,method2".scan(/\w+\d/) do |arg|
    puts "定义方法:#{arg}"
    define_method arg do |myarg|
      puts myarg+";"
    end
  end
end

t1 = Test.new
t2 = Test.new
t1.method1("测试method1")
t2.method2("测试method2")

#动态调用方法
t2.send("method1","测试send")