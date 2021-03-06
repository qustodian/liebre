module Liebre
  module Actor
    class Consumer
      class Reporter

        def initialize context
          @context = context
        end

        def on_start
          yield
          logger.info("Consumer started: #{name}")
        rescue Exception => error
          logger.error("Error starting consumer: #{name}\n#{error.message}\n#{error.backtrace}")
          raise error
        end

        def on_stop
          yield
          logger.info("Consumer stopped: #{name}")
        rescue Exception => error
          logger.error("Error stopping consumer: #{name}\n#{error.message}\n#{error.backtrace}")
          raise error
        end

        def on_consume
          yield
        rescue Exception => error
          logger.error("Error consuming: #{name}\n#{error.message}\n#{error.backtrace}")
          raise error
        end

        def on_ack
          yield
        rescue Exception => error
          logger.error("Error acking: #{name}\n#{error.message}\n#{error.backtrace}")
          raise error
        end

        def on_nack
          yield
        rescue Exception => error
          logger.error("Error nacking: #{name}\n#{error.message}\n#{error.backtrace}")
          raise error
        end

        def on_reject
          yield
        rescue Exception => error
          logger.error("Error rejecting: #{name}\n#{error.message}\n#{error.backtrace}")
          raise error
        end

        def on_failed error
          logger.error("Error on Consumer when handling a message #{name}\n#{error.message}\n#{error.backtrace}")
          yield
        rescue Exception => error
          logger.error("Error handling consumer handler failure: #{name}\n#{error.message}\n#{error.backtrace}")
          raise error
        end

        def on_clean
          yield
        rescue Exception => error
          logger.error("Error cleaning consumer: #{name}\n#{error.message}\n#{error.backtrace}")
          raise error
        end

      private

        def name
          @name ||= context.name.inspect
        end

        def logger
          @logger ||= context.logger
        end

        attr_reader :context

      end
    end
  end
end
