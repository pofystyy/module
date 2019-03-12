require_relative 'module/lightning_module'
require_relative 'rabbitmq/rabbit'

class First
  # include LightningModule
  include RabbitModule

  service_name :test_service
  # expose :triggered

  def initialize
    broadcast(:started, "testdata")
  end

  def triggered(name)
   p "First: #{name}"
  end

  def trigger_test_service
    # trigger("test_second_service.test_response", "my data")
  end  
end