class Gif
  include DataMapper::Resource
  
  property :short_url,    String,    :key => true, :unique => true
  property :filename,     String
  property :s3_location,  String,    :length => 1024, :format => :url
end