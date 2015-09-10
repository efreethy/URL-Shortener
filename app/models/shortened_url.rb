# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  long_url   :string
#  short_url  :string
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'SecureRandom'

class ShortenedUrl < ActiveRecord::Base
  include SecureRandom
  validates :short_url, presence: true, uniqueness: true

  belongs_to :user,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :visitors,
    proc { distinct },
    through: :visits,
    source: :user


  def self.create_for_user_and_long_url!(user, long_url)
    create!({long_url: long_url, short_url: random_code, user_id: user.id})
  end

  def self.random_code
    code = SecureRandom.base64(16)[0..16]

    while exists?(short_url: code)
      code = SecureRandom.base64(16)[0..16]
    end

    code
  end

  def num_clicks
    self.visits.count
  end

  def num_clicks_unique
    self.visitors.count
  end

  def clicks_since(mins)
    self.visits.where('created_at > ?', (Time.now - mins.minutes)).count
  end
end
