module LightningModule
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

      def trigger(service_name)
        raise NotImplementedError
      end

      def findall(key)
        raise NotImplementedError
      end

      def insert_service_data(key, *values)
        raise NotImplementedError
      end

      def delete(service_name)
      end
    end
  end
end