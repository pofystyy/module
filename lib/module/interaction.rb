require_relative '../storage/redis'

 module Interaction
    def self.included(base)
      base.extend(InteractionClass)
    end

    module InteractionClass
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

        hsh = Storage.new.find(service_name)
  
        clazz = hsh['class']
        methods = hsh['methods']

        obj = Object.const_get clazz
        methods.include?(meth) ? obj.new.send(meth, data) : p("method: #{meth} from: #{service_name} can not be used")
      end
    end
  end