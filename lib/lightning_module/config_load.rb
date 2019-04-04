require 'yaml'

module LightningModule
  class ConfigLoad
    def self.config
      YAML.load_file(File.join(__dir__, '../config.yml'))
    end
  end
end