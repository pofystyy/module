require_relative 'instance_methods'
require_relative 'class_methods'

module LightningModule
  include InstanceMethods

  def self.included(base)
    base.extend(ClassMethods)
  end
end