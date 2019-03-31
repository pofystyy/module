require_relative 'lightning_module/lightning_module'

class First
  include LightningModule

  service_name :test_service
  expose :triggered, :triggered2

  def initialize
    broadcast(:started, "testdata")
    # broadcast(:main, "main data")
    # broadcast(:data, "broadcast data")
  end

  def triggered(name)
   p "First: #{name}"
  end

  def triggered2(name)
   p "First2: #{name}"
  end

  def trigger_test_service
    p trigger("test_second_service.test_response", "my data")
  end
end
