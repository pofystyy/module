require_relative 'connect_to_db'

module InstanceMethods
  include ConnectToDb

  def broadcast(name, data)
    service_name = self.class.current_service_name
    storage.insert("event-#{service_name}", name.to_s, data)
  end

  def trigger(address, data)
    service_name, method = address.split(/\./)
    
    obj = Object.const_get(storage.find(service_name, 'class'))
    storage.find(service_name, 'methods').include?(method) ? obj.new.send(method, data) : p("method: #{method} from: #{service_name} can not be used")
  end
end