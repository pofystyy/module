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

        text = File.open('expose_methods.txt').read
        conf = text.each_line.map { |line| line.chomp.split }[1..-1].uniq

        clazz = conf.assoc(service_name)[1]
        methods = conf.assoc(service_name)[2..-1]

        obj = Object.const_get clazz
        methods.include?(meth) ? obj.new.send(meth, data) : p("method: #{meth} from: #{service_name} can not be used")
      end
    end
  end