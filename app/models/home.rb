class Home < ActiveRecord::Base
  validates :street, :city, :state, :zip, :presence => true
  validates :zip, :format => {
      :with => %r{\b[0-9]{5}(?:-[0-9]{4})?\b},
      :message => 'must be a valid zip code'
  }
end