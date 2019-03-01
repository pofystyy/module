require_relative 'module/module'

class First
  include MyModule

  service_name :test_service, self
  expose :triggered

  def intialize
   MyModule.broadcast(:started, "testdata")   
  end

  def triggered(name)
   p "First: #{name}"
  end

  def trigger_test_service
    MyModule.trigger("test_second_service.test_response", "data")
  end  
end