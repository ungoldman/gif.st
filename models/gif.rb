class Gif
  include DataMapper::Resource
  
  property :short_url,    String,    :key => true, :unique => true
  property :filename,     String,    :length => 255
  
  belongs_to :user
  
  def location
    'https://s3.amazonaws.com/gif.st/' + filename
  end
end