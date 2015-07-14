require 'mongo'

# make a collection to db
db = Mongo::Connection.new("127.0.0.1",27017).db("bcz")

# get a collection
coll = db.collection("demo3")

coll.remove();


#insert a doc
doc ={"name" =>"andy",
      "info"=>{
          "address"=>"shipan",
          "age"=>28}}

coll.insert(doc)

#find a doc

doc = coll.find_one()
puts doc.to_s;

#find many
coll.find().each {|row| puts row}

#find
coll.find({"name"=>"andy"}).each {|row| puts row}
coll.find()