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
    @all_ratings = Movie.ratings

    @sort = params[:sort]
    @ratings = params[:ratings]
    if !@ratings.nil? then puts "----------- #{@ratings.keys}" end
    
    # if !@ratings.nil?
    #   # @all_ratings = @ratings.keys # find way to use this to check those boxes
    # end
    
    # @movies = Movie.where!({rating: @ratings.keys}).order(@sort)
    
    if !@sort.nil?
      @movies = Movie.order(@sort)
    end
    
    if !@ratings.nil?
      @movies.where!({rating: @ratings.keys})
    end
    
    if !@sort.nil? and !@ratings.nil?
      @movies = Movie.where!({rating: @ratings.keys}).order(@sort)
    end
    
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