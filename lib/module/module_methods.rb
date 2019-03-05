require_relative 'connect_to_db'

module ModuleMethods
    def self.included(base)
      base.extend(ModuleClassMethods)
    end

    module ModuleClassMethods
      include ConnectToDb
      
      def call(name, data)
        p "call -- name: #{name}, data: #{data}"
      end

      def emit(name, data)
        p "emit -- name: #{name}, data: #{data}"
      end

      def broadcast(name, data)
        p 'broadcast'
        # p name.to_s
        # p data
        # storage.add("broadcast", name.to_s, data )
        # p storage.find("broadcast")
        # p storage.find_where("broadcast", 'end')
      end

      def trigger(address, data)
        service_name, method = address.split(/\./)
        service = storage.find(service_name)
        
        obj = Object.const_get service['class']   
        service['methods'].include?(method) ? obj.new.send(method, data) : p("method: #{method} from: #{service_name} can not be used")
      end
    end
  end