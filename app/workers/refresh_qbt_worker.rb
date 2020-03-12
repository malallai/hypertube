class RefreshQbtWorker
  include Sidekiq::Worker

  def perform
    $qbt_client.refresh_connection
  end

end
