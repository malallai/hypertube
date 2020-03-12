class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:destroy]

  def create
    @movie = Movie.find params['movie']
    unless @movie.nil?
      @movie.comments.create({:user => current_user, :comment => params['comment']})
      @movie.save
      render :show, :layout => false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end
end
