# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  
  has_many :visits,
    class_name: "Visit",
    foreign_key: :user_id,
    primary_key: :id

  has_many :visited_urls,
    proc { distinct },
    through: :visits,
    source: :shortened_url

end
