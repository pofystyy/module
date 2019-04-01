require_relative 'lightning_module/lightning_module'

class Second
  include LightningModule

  service_name :test_second_service
  expose :test_response, :else_response

  def test_response(data)
   p "Second: #{data}"
  end

  def trigger_test_service
    p trigger("test_first_service.triggered", "data1")
  end

   def trigger_test_service2
    p trigger("test_first_service.triggered2", "data2")
  end

  def else_response(data)
    p "from triggered: #{data}"
  end

  # from broadcast
  on_broadcast "test_first_service:started": :test_response

  # from trigger
  on_triggered 'trgger.test_second_service.test_response'
  # on 'trgger.test_second_service.else_response'
end
