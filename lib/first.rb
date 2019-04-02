require_relative 'lightning_module/lightning_module'
require 'byebug'

class First
  include LightningModule

  service_name :test_first_service
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
    trigger("test_second_service.test_response", { kbkj: 2 })

    output = ''
    while output.to_s.empty?
      output = check_result("test_second_service.test_response")
    end
    p output
  end

  # def trigger_test_service2
  #   trigger("test_second_service.else_response", "data from first to Second#else_response")
  #   output = ''
  #   while output.empty?
  #     output = check_result("test_second_service.else_response")
  #     # byebug
  #   end
  #   p output
  # end
end
