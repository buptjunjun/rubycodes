#encoding = utf-8
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

uri = URI.parse("http://api.douban.com/v2/book/user/onebird/collections?status=read&count=100")
res = Net::HTTP.get(uri)

puts res.to_s
#json
json = JSON.parse(res)
i = 0
puts json["collections"].size()