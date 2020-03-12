module MoviesHelper
  def get_details(imdb_code)
    tmdb = Tmdb::Find.imdb_id(imdb_code)
    return nil if tmdb['movie_results'].empty?
    id = tmdb['movie_results'][0]['id']
    {:details => Tmdb::Movie.detail(id), :crew => Tmdb::Movie.crew(id), :cast => Tmdb::Movie.casts(id)}
  end
end
