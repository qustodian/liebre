module Liebre
  class Engine
    class Starter
      module RPC
        class Server

          ACTOR = Liebre::Actor::RPC::Server

          def initialize bridge, opts
            @bridge = bridge
            @opts   = opts
          end

          def call
            starter = Shared::PooledActor.new(bridge, opts, ACTOR)
            starter.call
          end

        private

          attr_reader :bridge, :opts

        end
      end
    end
  end
end