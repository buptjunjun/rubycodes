#encoding:utf-8
require "mini_magick"
begin
  image = MiniMagick::Image.open("http://baicizhan.qiniudn.com/df_transparent/20121225_19_25_37_874.png")
  puts image.valid?
  puts image.size
rescue

end
puts ("".nil? or "".empty?)
