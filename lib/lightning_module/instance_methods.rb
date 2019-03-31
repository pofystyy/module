require_relative 'connect_to_db'
require_relative 'exceptions'
require 'byebug'

module InstanceMethods
  class Exceptions
    class BaseServiceExceptions < LightningModule::Exceptions::BaseException; end
    class MethodNameFailure < BaseServiceExceptions; end
  end
  include ConnectToDb

  def broadcast(name, data)
    service_name = self.class.current_service_name

    services = storage.findall('service')
    services = services - ["service.#{service_name}"]
    services = services.map { |service_n| service_n.scan(/\w+$/) }

    services.each { |service_n| storage.insert("#{service_name}.#{service_n.join}.#{name.to_s}",
                                                name.to_s,
                                                data) } unless services.flatten.empty?
  end

  def trigger(address, data)
    service_name, method = address.split(/\./)

    arr = []
    i = 0
    while arr.empty? #|| i < 5
      clazz = storage.trigger(service_name, 'class')
      # arr << clazz.nil?
      arr << Object.const_get(clazz).new.send(method, data) unless clazz.nil?
      sleep 1
      # i += 1
    end
    return arr
  end
end
