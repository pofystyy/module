require_relative 'connect_to_db'
require_relative 'exceptions'

module InstanceMethods
  class Exceptions
    class BaseServiceExceptions < LightningModule::Exceptions::BaseException; end
    class MethodNameFailure < BaseServiceExceptions; end
  end
  include ConnectToDb

  def broadcast(name, data)
    service_name = self.class.current_service_name
    storage.insert("event-#{service_name}", name.to_s, data)
  end

  def trigger(address, data)
    service_name, method = address.split(/\./)

    info = storage.trigger(service_name, method)
    clazz, methods = info
    methods = eval(methods) if methods.is_a? String
        
    obj = Object.const_get clazz
    methods.map(&:to_s).include?(method) ? obj.new.send(method, data) : raise(Exceptions::MethodNameFailure)
  end
end