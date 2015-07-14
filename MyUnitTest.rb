puts "---单元测试---"
require 'test/unit'
class MyTestUnit < Test::Unit::TestCase
  def test_basic
    assert_equal("THIS IS A TEST","this is a test".upcase)
    assert_not_equal("THIS IS A TEST","this is a test")
    assert_raise(ArgumentError){raise ArgumentError } 
    flunk  #"考试不及格" 一定会失败
  end
end