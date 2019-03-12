require_relative 'module/lightning_module'
require_relative 'rabbitmq/rabbit'

class Second
  # include LightningModule
  include RabbitModule

  service_name :test_second_service
  expose :test_response

  def test_response(data)
   p "Second: #{data}"
  end

  def trigger_test_service
    trigger("test_service.triggered", "data")
  end

  on "test_service:started": :test_response
end