module PopTimeApi
  include HTTParty
  include MoviesHelper

  @@total_count = 0
  @@uri = 'https://tv-v2.api-fetch.website'

  def ptime_top_rated
    ptime_query("1?sort=rating")
  end

  def ptime_search(params)
    query = !params['search'].nil? && !params['search'].empty? ? params['search'] : ''
    page = params['page']
    sort_by = !params['sort'].nil? && !params['sort'].empty? ? params['sort'] : 'rating'
    order_by = !params['order'].nil? && !params['order'].empty? ? params['order'].downcase : 'desc'
    genre = !params['genre'].nil? && !params['genre'].empty? ? params['genre'] : ''
    order_by = order_by == 'desc' ? -1 : 1
    ptime_query("#{page}?keywords=#{query}&sort=#{sort_by}&order=#{order_by}&genre=#{genre}")
  end

  def ptime_find(query, imdb_code)
    ptme = ptime_query("1?keywords=#{query}")
    return nil if ptme[:size] == 0
    ptme[:data].each do |movie|
      return movie if movie['imdb_id'] == imdb_code
    end
    nil
  end

  def ptime_serialize(data)
    movies = Array.new
    if data[:size] > 0 && !data[:data].nil?
      data[:data].each do |movie|
        movies << {
            title: movie['title'],
            rating: movie['rating']['percentage'] / 10,
            year: movie['year'],
            imdb_code: movie['imdb_id'],
            genres: movie['genres'],
            cover: movie['images']['poster'],
            details: get_details(movie['imdb_id'])
        }
      end
    end
    movies
  end

  private

  def ptime_query(query)
    uri = "#{@@uri}/movies/#{query}".encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    puts uri
    api_data = HTTParty.get(uri)
    if api_data.nil? || api_data.empty?
      data = {error: "No results.", size: 0}
    else
      @@total_count = api_data.length
      data = {data: api_data, size: @@total_count}
    end
    data
  end

end