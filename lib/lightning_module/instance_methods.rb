require_relative 'connect_to_db'
require_relative 'exceptions'
require_relative 'config_load'
# require_relative 'conf_conf'
require 'byebug'

module InstanceMethods
  class Exceptions
    class BaseServiceExceptions < LightningModule::Exceptions::BaseException; end
    class MethodNameFailure < BaseServiceExceptions; end
  end
  include LightningModule::ConnectToDb
  # include LightningModule::ConfConf

  def broadcast(event_name, event_data)
    services = storage.find_all('service') - ["service.#{this_service_name}"]
    unless services.first.nil?
      services = services.map { |service_n| service_n.scan(/\w+$/) }
      services.each { |service_n| storage.broadcast("broadcast.#{this_service_name}.#{service_n.join}.#{event_name.to_s}",
                                                  event_name.to_s,
                                                  event_data)
                                                } unless services.flatten.empty?

    end
  end

  def trigger(address, data)
    service_name, method = address.split('.')
    storage.insert("trigger.#{address}", 'from', this_service_name, method, data)
    service_not_found = true
    while service_not_found
      methods = storage.expose_methods("service.#{service_name}", 'methods')
      if methods.is_a?(Array)
        if methods.map(&:to_s).include?(method)
          service_not_found = false
          return check_data_from_db(service_name)
        else
          service_not_found = false
          storage.destroy("trigger.#{address}")
          return "method #{method} in service #{service_name} not found"
        end
      end
    end
  end

  private

  def this_service_name
    self.class.current_service_name
  end

  def check_data_from_db(service_name)
    output = ''
    while output.to_s.empty?
      sleep 0.3
      output = check_result("trigger.#{this_service_name}.#{service_name}")
    end
    return output
  end

  def check_result(global_key)
    output = storage.data_for_check_result(global_key, 'response')
    storage.delete(global_key)
    output
  end
end
