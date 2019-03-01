require_relative 'interaction'

module MyModule
  include Interaction

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def service_name(*name)
      File.open('expose_methods.txt', 'a') { |f| 
        f.write("\n")
        f.write(name.map(&:to_s).join(" ")) }
    end

    def expose(*meth)
      File.open('expose_methods.txt', 'a') do |f|
        f.write(" ")
        f.write(meth.map(&:to_s).join(" "))
        f.write(" ")
      end
    end
  end
end