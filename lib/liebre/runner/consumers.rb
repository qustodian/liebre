require 'yaml'

module Liebre
  class Runner
    class Consumers
      
      autoload :Starter, "segments/amqp/rpc/starter"

      def initialize connection
        @connection = connection
      end
    
      def consumer_names
        consumers.keys
      end

      def start_all
        consumer_names.each { |name| start(name) }
      end

      def start name
        params = config.fetch(name)

        starter = Starter.new(connection, params)
        starter.call
      end

    private

      def consumers
        Liebre.config.consumers
      end

      attr_reader :connection

    end
  end
end
