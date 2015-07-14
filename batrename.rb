#encoding: UTF-8
base = "/Users/Admin/Downloads/nedemo2/smmd/"
dir = Dir.open(base)
dir.each do |file|

  #f = File.open(base+file)
  newname = file.sub("u","U");
  #File.rename(file,newname);
 #puts file+":"+newname;
  system "mv "+base+file+"  "+base+newname
end