require_relative 'lightning_module/lightning_module'

class Third
  include LightningModule

  service_name :test_third_service
  expose :test_resp, :else_resp

  def test_resp(data)
  p "Third: #{data}"
  end

  def trigger_test_service2
  p trigger("test_first_service.triggered", "data1")
  end

  def trigger_test_service
  p trigger("test_second_service.test_response", ['zzzz'])
  end

  def else_resp(data)
  p "result from Second#on_triggered: #{data}"
  end

  on_broadcast "test_first_service:started": :test_resp
end