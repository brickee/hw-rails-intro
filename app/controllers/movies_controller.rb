class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index

      @all_ratings = Movie.all_ratings
      
      # select ratings
      sort_by = params[:sort] || session[:sort]
      @selected_ratings = params[:ratings] || session[:ratings] || Hash[@all_ratings.map { |rating| [rating, 1] }]
      
      if !params[:commit].nil? || params[:ratings].nil? || (params[:sort].nil? && !session[:sort].nil?)
        flash.keep
        redirect_to movies_path :sort => sort_by, :ratings => @selected_ratings
      end
      
      @movies = Movie.with_ratings(@selected_ratings.keys).order(sort_by)
      
      
      # set sorting background
      if sort_by == 'title'
      # @title_header = 'p-3 mb-2 bg-warning text-dark'
        @title_header = "hilite"
      elsif sort_by == 'release_date'
        @release_header = "hilite"
      end
      
      session[:sort] = sort_by
      session[:ratings] = @selected_ratings
      
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
    
    def sort_by_title
      @movie = Movie.order(:title)
    end
      
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end