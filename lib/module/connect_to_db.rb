require_relative '../storage/redis'

module ConnectToDb
  def storage
    Storage::Redis.instance
  end
end