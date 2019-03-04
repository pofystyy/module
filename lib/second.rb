require_relative 'module/lightning_module'

class Second
  include LightningModule

  service_name :test_second_service, self
  expose :test_response

  #on "test_service:started": :test_response

  def test_response(data)
   p "Second: #{data}"
  end

  def trigger_test_service
   LightningModule.trigger("test_service.triggered", "data")
  end
end