require_relative 'exceptions'
Dir[File.dirname(__FILE__) + '/../storage/**/*.rb'].each { |file| require file }

module ConnectToDb
  def storage(db = 'redis')
  # redis, rabbit
    Object.const_get("Storages::#{db.capitalize}").instance
  rescue NameError
    raise LightningModule::Exceptions::InvalidDatabase, "invalid database name #{db.capitalize}"
  end
end