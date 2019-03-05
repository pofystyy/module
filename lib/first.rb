require_relative 'module/lightning_module'

class First
  include LightningModule

  service_name :test_service
  expose :triggered

  def initialize
    LightningModule.broadcast(:started, "testdata")
    # LightningModule.broadcast(:end, "22222222")
  end

  def triggered(name)
   p "First: #{name}"
  end

  def trigger_test_service
    LightningModule.trigger("test_second_service.test_response", "my data")
  end  
end