class Book < ActiveRecord::Base
  attr_accessible :author, :isbn, :subtitle, :title
end
