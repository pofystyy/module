require_relative 'connect_to_db'
require_relative 'exceptions'
require 'byebug'

module InstanceMethods
  class Exceptions
    class BaseServiceExceptions < LightningModule::Exceptions::BaseException; end
    class MethodNameFailure < BaseServiceExceptions; end
  end
  include LightningModule::ConnectToDb

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
    method = address.split(/\./).last
    storage.trigger(address, method, data, 'response', '', 'code', '')
  end

  def check_result(global_key)
    out = storage.find(global_key, 'response')
    storage.delete(global_key) if storage.find(global_key, 'code') == '200' && !out.empty?
    out
  end

end
