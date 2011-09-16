class Gif
  include DataMapper::Resource
  
  property :id,           Serial
  property :short_url,    String,    :unique => true
  property :filename,     String,    :length => 255
  
  belongs_to :user
  
  def location
    'https://s3.amazonaws.com/gif.st/' + filename
  end
end