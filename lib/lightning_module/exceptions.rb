module LightningModule
  module Exceptions
    class BaseException < StandardError; end
    class InvalidDatabase < BaseException; end
  end
end