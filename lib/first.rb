require_relative 'lightning_module/lightning_module'

class First
  include LightningModule

  service_name :test_service
  expose :triggered

  def initialize
    broadcast(:started, "testdata")
    # broadcast(:main, "main data")
    # broadcast(:data, "broadcast data")
  end

  def triggered(name)
   p "First: #{name}"
  end

  def trigger_test_service
    trigger("test_second_service.test_response", "my data")
  end   
end