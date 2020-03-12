class SearchsController < ApplicationController
  before_action :authenticate_user!

  include YtsApi
  include PopTimeApi

  def index
    if params['source'].nil? || params['source'].empty? || params['source'] === 'YTS'
      yts = yts_search params
      @movies = yts_serialize(yts)
      @size = yts[:size]
    else
      ptime = ptime_search params
      @movies = ptime_serialize(ptime)
      @size = ptime[:size]
    end
    if @size == 0 || @movies.empty?
      head :ok
    else
      render :search, :layout => false
    end
  end

end
