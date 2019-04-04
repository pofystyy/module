require_relative 'exceptions'
require_relative 'config_load'
Dir[File.dirname(__FILE__) + '/../storage/**/*.rb'].each { |file| require file }

module LightningModule
  module ConnectToDb
    def db
      LightningModule::ConfigLoad.config['db'].join.capitalize
    end

    def storage
      Object.const_get("LightningModule::Storages::#{db}").instance
    rescue NameError
      raise LightningModule::Exceptions::InvalidDatabase, "invalid database name #{db}"
    end
  end
end