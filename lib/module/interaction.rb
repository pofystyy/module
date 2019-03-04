require_relative '../storage/redis'
require_relative 'connect_to_db'

module Interaction
    def self.included(base)
      base.extend(InteractionClass)
    end

    module InteractionClass
      include ConnectToDb
      
      def call(name, data)
        p "call -- name: #{name}, data: #{data}"
      end

      def emit(name, data)
        p "emit -- name: #{name}, data: #{data}"
      end

      def broadcast(name, data)
        p "brodcast -- name: #{name}, data: #{data}"
      end

      def trigger(address, data)
        service_name, meth = address.split(/\./)

        hsh = storage.find(service_name)
  
        clazz = hsh['class']
        methods = hsh['methods']

        obj = Object.const_get clazz
        methods.include?(meth) ? obj.new.send(meth, data) : p("method: #{meth} from: #{service_name} can not be used")
      end
    end
  end