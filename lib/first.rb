require_relative 'module/lightning_module'

class First
  include LightningModule

  service_name :test_service, self
  expose #:triggered

  def intialize
   LightningModule.broadcast(:started, "testdata")   
  end

  def triggered(name)
   p "First: #{name}"
  end

  def trigger_test_service
    LightningModule.trigger("test_second_service.test_response", "data")
  end  
end