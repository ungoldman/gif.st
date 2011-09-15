class User
  include DataMapper::Resource

  property :id,          Serial
  property :uid,         String
  property :name,        String
  property :img,         String, :length => 1024, :format => :url
  timestamps :at
  
  has n, :gifs
  
  # has n, :relationships
  # has n, :followers, self, :through => :relationships, :via => :target
  # has n, :follows,   self, :through => :relationships, :via => :target
  
  # has n, :followers, :through => :relationships, :model => "User", :child_key => [:user_id]
  # has n, :follows, :through => :relationships, :model => "User", :via => :user, :child_key => [:follower_id]

end