require_relative 'connect_to_db'

module InstanceMethods
  include ConnectToDb

  def broadcast(name, data)
    service_name = (self.class.current_service_name).join
    storage.add("event-#{service_name}", name.to_s, data)
  end

  def trigger(address, data)
    service_name, method = address.split(/\./)
    service = storage.find(service_name)
    
    obj = Object.const_get service['class']   
    service['methods'].include?(method) ? obj.new.send(method, data) : p("method: #{method} from: #{service_name} can not be used")
  end
end