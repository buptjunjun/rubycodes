#encoding:utf-8
#测试ruby上传文件
require 'net/http/post/multipart'

url = URI.parse('http://www.example.com/upload')
File.open("./image.jpg") do |jpg|
  req = Net::HTTP::Post::Multipart.new url.path, "file" => UploadIO.new(jpg, "image/jpeg", "image.jpg")
  res = Net::HTTP.start(url.host, url.port) do |http|
    http.request(req)
  end
end