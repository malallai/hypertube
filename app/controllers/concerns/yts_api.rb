module YtsApi
  include HTTParty
  include MoviesHelper

  @@total_count = 0
  @@uri = 'https://yts.mx/api/v2'

  def yts_top_rated
    yts_query("sort_by=rating")
  end

  def yts_search(params)
    query = !params['search'].nil? && !params['search'].empty? ? params['search'] : ''
    amount = 20
    page = params['page']
    sort_by = !params['sort'].nil? && !params['sort'].empty? ? params['sort'] : 'rating'
    order_by = !params['order'].nil? && !params['order'].empty? ? params['order'].downcase : 'desc'
    genre = !params['genre'].nil? && !params['genre'].empty? ? params['genre'] : ''
    yts_query("query_term=#{query}&limit=#{amount}&page=#{page}&sort_by=#{sort_by}&order_by=#{order_by}&genre=#{genre}")
  end

  def yts_find(query, imdb_code)
    yts = yts_query("query_term=#{query}")
    return nil if yts[:size] == 0
    yts[:data].each do |movie|
      return movie if movie['imdb_code'] == imdb_code
    end
    nil
  end

  def yts_serialize(data)
    movies = Array.new
    if data[:size] > 0 && !data[:data].nil?
      data[:data].each do |movie|
        movies << {
            title: movie['title'],
            rating: movie['rating'],
            year: movie['year'],
            imdb_code: movie['imdb_code'],
            genres: movie['genres'],
            cover: movie['large_cover_image'],
            details: get_details(movie['imdb_code'])
        }
      end
    end
    movies
  end

  private

  def yts_query(query)
    uri = "#{@@uri}/list_movies.json?#{query}".encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    puts uri
    api_data = HTTParty.get(uri)
    if api_data['status'] == 'ok'
      @@total_count = api_data['data']['movie_count']
      data = {data: api_data['data']['movies'], size: @@total_count}
    else
      data = {error: api_data['status_message'], size: 0}
    end
    data
  end

end