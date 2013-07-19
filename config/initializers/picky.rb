# Silence Picky, as an example.
#
Picky.logger = Picky::Loggers::Silent.new

# We create a new index and store it in the constant BooksIndex.
#
BooksIndex = Picky::Index.new :things do
  # Our keys are integers.
  # Use :to_s if you have strings.
  #
  key_format :to_i

  # Default indexing options.
  # Please see: https://github.com/floere/picky/wiki/Indexing-configuration
  # for more information.
  #
  indexing removes_characters: /[^a-z0-9\s\/\-\_\:\"\&\.]/i,
           stopwords:          /\b(and|the|of|it|in|for)\b/i,
           splits_text_on:     /[\s\/\-\_\:\"\&\/]/,
           rejects_token_if:   lambda { |token| token.size < 2 }

  # We can search on the titles of the thing.
  #
  # We use postfix partials which means a word can
  # be found if only part has been entered (from the beginning).
  #
  # category :title, :partial => Picky::Partial::Postfix.new(:from => 1)
  category :title,
          similarity: Picky::Similarity::DoubleMetaphone.new(3),
          partial: Picky::Partial::Substring.new(from: 1) # Default is from: -3.
  category :author, partial: Picky::Partial::Substring.new(from: 1)


end

# BooksSearch is the search interface
# on the things index.
#
# See https://github.com/floere/picky/wiki/Searching-Configuration
# for some tokenizing options.
#
BookSearch = Picky::Search.new BooksIndex

# We are indexing at the end of this method
# using explicit indexing.
#
# Feel free to run the initial indexing somewhere else.
#
Book.order('title ASC').each do |thing|
  BooksIndex.add thing
end