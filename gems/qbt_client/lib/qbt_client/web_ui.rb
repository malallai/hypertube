require 'multi_json'
require 'httparty'
require 'digest'

module QbtClient

  class WebUI
    include HTTParty

    if ENV["DEBUG"]
      debug_output $stdout
    end

    def initialize(ip, port, user, pass)
      @ip         = ip
      @port       = port
      @user       = user
      @pass       = pass
      @sid        = nil

      host = "#{ip}:#{port}"
      self.class.base_uri host
      self.class.headers "Referer" => "#{host}"
      authenticate
      self.class.cookies.add_cookies(@sid)
    end

    def refresh_connection
      authenticate
      self.class.cookies.add_cookies(@sid)
    end

    def authenticate
      options = {
          body: "username=#{@user}&password=#{@pass}"
      }

      self.class.cookies.clear

      res = self.class.post('/api/v2/auth/login', options)
      if res.success?
        token = res.headers["Set-Cookie"]
        raise QbtClientError.new("Login failed: no SID (cookie) returned") if token.nil?

        token = token.split(";")[0]
        @sid = token
      else
        raise QbtClientError.new(res)
      end
    end

    def api_version
      self.class.format :json
      self.class.post('/api/v2/app/webapiVersion').parsed_response
    end

    def qbittorrent_version
      self.class.format :plain
      self.class.post('/api/v2/app/version').parsed_response
    end

    def torrent_list
      self.class.format :json
      self.class.post('/api/v2/torrents/info').parsed_response
    end

    def torrent_data torrent_hash
      torrents = torrent_list

      torrents.each do |t|
        if t["hash"] == torrent_hash
          return t
        end
      end
    end

    def properties torrent_hash
      self.class.format :json
      options = {
        body: "hash=#{torrent_hash}"
      }
      self.class.post('/api/v2/torrents/properties', options).parsed_response
    end

    def trackers torrent_hash
      self.class.format :json
      options = {
        body: "hash=#{torrent_hash}"
      }
      self.class.post('/api/v2/torrents/tracker', options).parsed_response
    end

    def add_trackers torrent_hash, urls
      urls = Array(urls)
      # Ampersands in urls must be escaped.
      urls = urls.map { |url| url.gsub('&', '%26') }
      urls = urls.join('%0A')

      options = {
          body: "hash=#{torrent_hash}&urls=#{urls}"
      }

      self.class.post('/api/v2/torrents/addTrackers', options)
    end

    def contents torrent_hash
      self.class.format :json
      options = {
        body: "hash=#{torrent_hash}"
      }
      self.class.post('/api/v2/torrents/files', options).parsed_response
    end

    def transfer_info
      self.class.format :json
      self.class.post('/api/v2/transfer/info').parsed_response
    end

    def preferences
      self.class.format :json
      self.class.post('/api/v2/app/preferences').parsed_response
    end

    def set_preferences pref_hash
      pref_hash = Hash(pref_hash)
      options = {
          body: "json=#{pref_hash.to_json}"
      }

      self.class.post('/api/v2/app/setPreferences', options)
    end

    def pause torrent_hash
      options = {
          body: "hashes=#{torrent_hash}"
      }

      self.class.post('/api/v2/torrents/pause', options)
    end

    def pause_all
      pause 'all'
    end

    def resume torrent_hash
      options = {
          body: "hashes=#{torrent_hash}"
      }

      self.class.post('/api/v2/torrentsresume', options)
    end

    def resume_all
      resume 'all'
    end

    def download urls, opt = nil
      urls = Array(urls)
      urls = urls.join('%0A')
      body = "urls=#{urls}"
      unless opt.nil?
        opt.each do |key, value|
          body = "#{body}&#{key}=#{value}"
        end
      end

      options = {
          body: body
      }

      self.class.post('/api/v2/torrents/add', options)
    end

    def delete_torrent_and_data torrent_hashes
      torrent_hashes = Array(torrent_hashes)
      torrent_hashes = torrent_hashes.join('|')

      options = {
          body: "hashes=#{torrent_hashes}",
          deleteFiles: true
      }

      self.class.post('/api/v2/torrents/delete', options)
    end

    def delete torrent_hashes
      torrent_hashes = Array(torrent_hashes)
      torrent_hashes = torrent_hashes.join('|')

      options = {
          body: "hashes=#{torrent_hashes}"
      }

      self.class.post('/api/v2/torrents/delete', options)
    end

    def recheck torrent_hash
      options = {
          body: "hashes=#{torrent_hash}"
      }

      self.class.post('/api/v2/torrents/recheck', options)
    end

    def set_location(torrent_hashes, path)
      torrent_hashes = Array(torrent_hashes)
      torrent_hashes = torrent_hashes.join('|')

      options = {
          body: { "hashes" => torrent_hashes, "location" => path },
      }

      self.class.post('/api/v2/torrents/setLocation', options)
    end

    def seq torrent_hash
      options = {
          body: "hashes=#{torrent_hash}"
      }

      self.class.post('/api/v2/torrents/toggleSequentialDownload', options)
    end

    private

    def md5 str
      Digest::MD5.hexdigest str
    end
  end
end

