require_relative 'config_load'

module LightningModule
  module ConfConf
    def db
      LightningModule::ConfigLoad.config['db'].join.capitalize
    end

    def search_string
      case db
        when 'Redis'
          'service.*'
        when 'Rabbit'
          'service'
      end
    end
  end
end