module OstApi
  include HTTParty

  @@uri = 'https://rest.opensubtitles.org'

  def search_srt(imdb)
    query = "imdbid-#{imdb.slice(2, imdb.length)}"
    query_srt query
  end

  def subtitles_serialize(data)
    srts = Array.new
    if data[:size] > 0
      data[:data].each do |srt|
        srts << {
            format: srt['SubFormat'],
            lang: srt['LanguageName'],
            lang_id: srt['SubLanguageID'],
            download: srt['SubDownloadLink']
        } if srt['SubFormat'] === 'srt'
      end
    end
    srts
  end

  private

  def query_srt(query)
    headers = {
        'X-User-Agent' => 'malallai-hypertube'
    }
    api_data = HTTParty.get(
        "#{@@uri}/search/#{query}",
        :headers => headers
    )
    if api_data.nil? || api_data.empty?
      data = {error: "No results.", size: 0}
    else
      data = {data: api_data, size: api_data.length}
    end
    data
  end

end