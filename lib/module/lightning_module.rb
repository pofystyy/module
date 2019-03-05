require_relative 'module_methods'
require_relative 'class_methods'

module LightningModule
  include ModuleMethods

  def self.included(base)
    base.extend(ClassMethods)
  end
end