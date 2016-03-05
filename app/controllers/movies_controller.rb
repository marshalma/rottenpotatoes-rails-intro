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
    @all_ratings = Movie.unique_values(:rating)
    @ratings = @all_ratings
    @sort = :id

    flag_redirect_1 = false
    flag_redirect_2 = false
    if params.has_key?(:sort)
      @sort = params[:sort]
      session[:sort] = @sort
    elsif session.has_key?(:sort)
      flag_redirect_1 = true
    end

    if params.has_key?(:ratings)
      @ratings = params[:ratings].keys
      session[:ratings] = @ratings
    elsif session.has_key?(:ratings)
      flag_redirect_2 = true
    end

    if flag_redirect_1 && flag_redirect_2
      redirect_to movies_path({:sort => session[:sort], :ratings => Hash[session[:ratings].map {|x| [x,1]}]})
    elsif flag_redirect_1
      redirect_to movies_path({:sort => session[:sort], :ratings => params[:ratings]})
    elsif flag_redirect_2
      redirect_to movies_path({:sort => params[:sort], :ratings => Hash[session[:ratings].map {|x| [x,1]}]})
    end

    # logger.debug("ratings:: #{@ratings.inspect}")
    @movies = Movie.where(rating: @ratings).order(@sort)
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
