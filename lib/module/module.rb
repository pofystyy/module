require_relative 'interaction'
require_relative '../storage/redis'

module MyModule
  include Interaction

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def service_name(*name)
      @arr = []
      @arr << name
    end

    def expose(*meth)
      @arr << meth
      data
    end

    def data
      key   = @arr[0][0].to_s
      value = { class: @arr[0][1].to_s, methods: @arr[1].map(&:to_s) }
      Storage.new.insert(key, value)
    end
  end
end