module Liebre
  class Runner
    
    autoload :Starter, 'liebre/runner/starter'
    
    RETRY_INTERVAL = 5

    def initialize retry_interval = RETRY_INTERVAL
      @retry_interval = retry_interval
    end

    def start
      setup_shutdown
      conn_manager.restart
      start_consumers
      sleep
    rescue StandardError => e
      log_and_wait(e)
      retry
    end

  private

    def setup_shutdown
      Signal.trap("TERM") { do_shutdown; exit }
    end

    def do_shutdown
      Thread.start do
        logger.info("Closing AMQP connection...")
        conn_manager.stop
        logger.info("AMQP connection closed")
      end.join
    end

    def start_consumers
      rpc = Consumers.new(conn_manager.get)
      rpc.start_all
    end

    def log_and_wait e
      logger.warn(e)
      sleep(retry_interval)
      logger.warn("Retrying connection: #{conn_manager.get}")
    end

    def logger
      $logger
    end

    def conn_manager
      @conn_manager ||= ConnectionManager.new
    end

    attr_reader :retry_interval

  end
end
