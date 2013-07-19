class Book < ActiveRecord::Base
  	attr_accessible :author, :isbn, :subtitle, :title

	after_commit :picky_index

	# Index correctly, depending on whether it
	# was destroyed or updated/created.
	#
	def picky_index
	  if destroyed?
	    BooksIndex.remove id
	  else
	    BooksIndex.replace self
	  end
	end

end
