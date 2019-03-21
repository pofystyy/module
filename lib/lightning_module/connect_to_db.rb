require_relative '../storage/redis'
require_relative '../storage/rabbit'

module ConnectToDb
  def storage(db = 'rabbit')
    # redis, rabbit
    Object.const_get("Storages::#{db.capitalize}").instance
  end
end