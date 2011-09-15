class Relationship
  include DataMapper::Resource

  property :user_id,   Integer, :key => true, :min => 1
  property :target_id, Integer, :key => true, :min => 1

  belongs_to :user, :key => true
  belongs_to :target, 'User', :key => true
end