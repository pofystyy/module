require_relative 'connect_to_db'
require_relative 'exceptions'
require 'byebug'

module ClassMethods
    include LightningModule::ConnectToDb
    attr_accessor :triggered_services

    def service_name(name)
      check_service_data
      @service_data[:service_name] = name.to_s
      @service_data[:class] = self
      call_insert_to_storage
    end

    def expose(*meth)
      check_service_data
      @service_data[:methods] = meth
      call_insert_to_storage
    end

    def on_broadcast(event)
      @event_data = [] if @event_data.nil?
      @event_data.push(event)
      parse_event_data
      data = storage.on_broadcast("broadcast.#{@service_name}.#{current_service_name}.#{@event_name}", @event_name)
      self.new.send(@method, data)
    end

    def current_service_name
      @service_data[:service_name]
    end

    def on_triggered(data)
      method = data.split('.').last
      result = storage.on_triggered("trigger.#{data}", method)
      response = self.new.send(method, result)
      storage.trigger("result.trigger.#{data}", 'response', response, 'code', '200')
    end

    private

    def check_service_data
      @service_data = {} if @service_data.nil?
    end

    def call_insert_to_storage
      storage_insert if @service_data.size == 3
    end

    def storage_insert
      storage.insert_service_data("service.#{current_service_name}", 'class', @service_data[:class].to_s, 'methods', @service_data[:methods])
    end

    def parse_event_data
      @service_name, @event_name = @event_data.first.keys.join.split /:/
      @method = @event_data.first.values.join
      @event_data.shift
    end
  end
