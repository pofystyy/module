require_relative 'interaction'
require_relative '../storage/redis'
require_relative 'connect_to_db'

module LightningModule
  include Interaction

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    include ConnectToDb
    def service_name(*name)
      @hsh = {}
      @hsh[:service_name] = name.first
      @hsh[:class] = name.last

    end

    def expose(*meth)
      @hsh[:methods] = meth
      data
    end

    def data
      key   = @hsh[:service_name]
      value = { class: @hsh[:class], methods: @hsh[:methods] }
      storage.insert(key, value)
    end
  end
end