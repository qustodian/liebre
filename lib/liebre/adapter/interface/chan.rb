module Liebre
  module Adapter
    module Interface
      module Chan

        def default_exchange
          raise NotImplementedError, "All adapters must implement channel default_exchange() to build the default exchange"
        end

        def exchange name, type, opts
          raise NotImplementedError, "All adapters must implement channel exchange(name, type, opts) to declare and build exchanges"
        end

        def queue name, opts
          raise NotImplementedError, "All adapters must implement channel queue(name, opts) to declare and build queues"
        end

        def set_prefetch count
          raise NotImplementedError, "All adapters must implement channel set_prefetch(count) to set the prefetch count for this channel"
        end

        def close
          raise NotImplementedError, "All adapters must implement channel close() to close a channel"
        end

      end
    end
  end
end
