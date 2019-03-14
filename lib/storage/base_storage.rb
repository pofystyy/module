module Storages
  class BaseStorage
    def trigger(service_name, method)
      raise NotImplementedError
    end

    def on(service_name, event_name)
      raise NotImplementedError
    end

    def insert(key, *values)
      raise NotImplementedError
    end

    def find(global_key, finding_key) 
      raise NotImplementedError
    end
  end
end