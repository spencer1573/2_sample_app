class Micropost < ActiveRecord::Base
  # the belongs to was generated when 
  # we typed 
  # bundle exec rake db:migrate
  belongs_to :user
  #QUESTION: i guess right now thats the only thing we 
  # need to validate when a micropost is created 
  # from the model?
  #
  validates :user_id, presence: true
end
