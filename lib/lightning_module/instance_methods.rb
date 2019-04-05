require_relative 'connect_to_db'
require_relative 'exceptions'
require_relative 'config_load'
require 'byebug'

module InstanceMethods
  class Exceptions
    class BaseServiceExceptions < LightningModule::Exceptions::BaseException; end
    class MethodNameFailure < BaseServiceExceptions; end
  end
  include LightningModule::ConnectToDb

  def broadcast(name, data)
    # byebug
    p services = storage.findall('service')
    # p "this: service.#{this_service_name}"
    p services = services - ["service.#{this_service_name}"]
    # p services
    unless services.first.nil?
      services = services.map { |service_n| service_n.scan(/\w+$/) } 

      services.each { |service_n| storage.insert_service_data("broadcast.#{this_service_name}.#{service_n.join}.#{name.to_s}",
                                                  name.to_s,
                                                  data) } unless services.flatten.empty?
    end
  end

  def trigger(address, data)
    service_name, method = address.split('.')
    if (storage.find("service.#{service_name}", 'methods').map(&:to_s).include?(method) rescue true)
      storage.trigger("trigger.#{this_service_name}.#{address}", method, data, 'response', '', 'code', '')
      check_data_from_db(address)
    else
      return "method #{method} in service #{service_name} not found"
      # raise Exceptions::MethodNameFailure
    end
  end

  private

  def this_service_name
    self.class.current_service_name
  end

  def check_data_from_db(address)
    output = ''
    while output.to_s.empty?
      output = check_result("trigger.#{this_service_name}.#{address}")
    end
    return output
  end

  def check_result(global_key)
    output = storage.find(global_key, 'response')
    storage.delete(global_key) if storage.find(global_key, 'code') == '200' && !output.empty?
    output
  end

end
