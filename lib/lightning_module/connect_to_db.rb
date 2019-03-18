require_relative '../storage/redis'
require_relative '../storage/rabbit'

module ConnectToDb
  def storage(db = 'redis')
    # redis, rabbit
    Object.const_get("Storages::#{db.capitalize}").instance
  end
end