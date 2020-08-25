module LightningModule
  module Storages
    class BaseStorage
      def find_data_for_broadcast(service_name, event_name)
        raise NotImplementedError
      end

      def insert_service_data(key, *values)
        raise NotImplementedError
      end

      def insert(key, *values)
        raise NotImplementedError
      end

      def find_all(key)
        raise NotImplementedError
      end

      def find_data_for_triggered(global_key, finding_key)
        raise NotImplementedError
      end

      def expose_methods(global_key, finding_key)
        raise NotImplementedError
      end

      def data_for_check_result(global_key, finding_key)
        raise NotImplementedError
      end

      def delete(service_name)
      end
    end
  end
end
