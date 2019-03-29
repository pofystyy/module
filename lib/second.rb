require_relative 'lightning_module/lightning_module'

class Second
  include LightningModule

  service_name :test_second_service
  expose :test_response

  def test_response(data)
   p "Second: #{data}"
  end

  def trigger_test_service
    trigger("test_service.triggered", "data1")
  end

   def trigger_test_service2
    trigger("test_service.triggered2", "data2")
  end

  on "test_service:started": :test_response
  # on "test_service:main": :test_response
  # on "test_service:data": :test_response
end