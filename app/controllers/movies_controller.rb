class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @movies = Movie.all
    @all_ratings = Movie.ratings # used to generate check boxes
    
    
    # if params is nil then look for value in the session
    @sort = params[:sort] ? params[:sort] : session[:sort]
    
    # if params is nil then look for value in the session
    @ratings = params[:ratings] ? params[:ratings] : session[:ratings]
    
    # puts "-------------@sort = #{@sort}"
    # puts "-------------@sort session= #{session[:sort]}"
    # puts "-------------@ratings params = #{params[:ratings]}"
    # puts "-------------@ratings session = #{session[:ratings]}"
    # puts "-------------@ratings = #{@ratings}"
    # ?utf8=✓&ratings%5BG%5D=1&commit=Refresh
    
    
    if !@sort.nil?
      @movies = @movies.order(@sort)
    end
    if !@ratings.nil?
      if @ratings.kind_of?(Array) 
        @movies = @movies.where(@ratings) 
        # puts "----**** HERE ***-----"
      else @movies = @movies.where({rating: @ratings.keys}) end
    end
    
    # # for check boxes - makes all checked if this is nil (i.e. all movie ratings are showing so check them all)
    # # b/c having none of the boxes checked doesnt make sense 
    if @ratings.nil? then @ratings = Movie.ratings end
      
    session[:sort] = @sort
    session[:ratings] = @ratings
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
