class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :load_var
  include YtsApi

  def index
    top_rated = yts_top_rated
    @movies = yts_serialize(top_rated)
    @size = top_rated[:size]
  end

  def terms
  end

  def privacy
  end

  def workers
    TorrentRemoverWorker.perform_async
    render json: true
  end

  private

  def load_var
    @sources = [
        'YTS',
        'PopcornTime'
    ]

    @genres = [
        '',
        'action',
        'adventure',
        'animation',
        'comedy',
        'crime',
        'disaster',
        'documentary',
        'drama',
        'eastern',
        'family',
        'fan-film',
        'fantasy',
        'film-noir',
        'history',
        'holiday',
        'horror',
        'indie',
        'music',
        'mystery',
        'none',
        'road',
        'romance',
        'science-fiction',
        'short',
        'sports',
        'sporting-event',
        'suspense',
        'thriller',
        'tv-movie',
        'war',
        'western'
    ]

    @sortby = [
        'rating',
        'year'
    ]
  end
end
