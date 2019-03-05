require_relative 'connect_to_db'

module ClassMethods
  include ConnectToDb

  def service_name(*name)
    check
    @service_data[:service_name] = name
    @service_data[:class] = self
    call_storage_insert
  end

  def expose(*meth)
    check
    @service_data[:methods] = meth
    call_storage_insert
  end

  def on(event)
    @event_data = [] if @event_data.nil?
    @event_data.push event
  end

  private

  def check
    @service_data = {} if @service_data.nil? 
  end

  def call_storage_insert
    storage_insert if @service_data.size == 3
  end

  def storage_insert
    key   = @service_data[:service_name]
    value = { class: @service_data[:class], methods: @service_data[:methods] }
    storage.insert(key, value)
  end
end