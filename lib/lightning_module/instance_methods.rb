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

    services = storage.findall('service')
    services = services - ["service:#{service_name}"]
    services = services.map { |service_n| service_n.scan(/\w+$/) }

    services.each { |service_n| storage.insert("broadcast-#{service_n.join}-#{service_name}-#{name.to_s}", 
                                                name.to_s, 
                                                data) } unless services.flatten.empty?
  end

  def trigger(address, data)
    service_name, method = address.split(/\./)

    info = storage.trigger("service:#{service_name}", method)
    clazz, methods = info
    methods = eval(methods) if methods.is_a? String

    obj = Object.const_get clazz
    methods.map(&:to_s).include?(method) ? obj.new.send(method, data) : raise(Exceptions::MethodNameFailure)
  end
end