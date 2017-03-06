module Liebre
  module Actor
    module RPC
      class Server
        class Context

          def initialize chan, spec
            @chan = chan
            @spec = spec
          end

          def exchange
            chan.default_exchange
          end

          def request_queue
            name = queue_config.fetch("name")
            opts = queue_config.fetch("opts")

            chan.queue(name, symbolize(opts)).tap do |queue|
              queue.bind(request_exchange)
            end
          end

        private

          def request_exchange
            name = exchange_config.fetch("name")
            type = exchange_config.fetch("type")
            opts = exchange_config.fetch("opts")

            chan.exchange(name, type, symbolize(opts))
          end

          def queue_config
            spec.fetch("queue")
          end

          def exchange_config
            spec.fetch("exchange")
          end

          def symbolize opts
            opts.reduce({}) { |new, (key, value)| new.merge!(key.to_sym => value) }
          end

          attr_reader :chan, :spec

        end
      end
    end
  end
end
