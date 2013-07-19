class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @books = Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  def search
    # This line prepends the current user to the query.
    #
    # Since we have indexed the thing's user in the
    # user category, we can prepend a filter to the
    # currently received query.
    #
    # A query like
    #   "one two three"
    # will be transformed into
    #   "user:15 one two three"
    # which will result in things only
    # being found if it is associated to the current user.
    #
    query = "#{params[:query]}"

    # Perform the search.
    #
    results = BookSearch.search query, params[:ids] || 20, params[:offset] || 0
    
    # Render each thing in the results nicely as a partial.
    #
    # (You need to have a "thing" partial file)
    #
    results = results.to_hash
    results.extend Picky::Convenience
    results.populate_with Book do |book|
      render_to_string :partial => "book", :object => book
    end
    
    # We respond with a nice JSON result.
    #
    respond_to do |format|
      format.html do
        # Homework: Make this a nice HTML results page.
        #
        render :text => "Deal result ids: #{results.ids.to_s}"
      end
      format.json do
        render :text => results.to_json
      end
    end
  end
end
