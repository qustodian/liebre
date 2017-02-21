require 'liebre/consumer/context'
require 'liebre/consumer/callback'

module Liebre
  class Consumer
    include Concurrent::Async

    OPTS = {:block => false, :manual_ack => true}

    def initialize chan, spec, handler_class, pool
      super()

      @chan          = chan
      @spec          = spec
      @handler_class = handler_class
      @pool          = pool
    end

    def start() async.__start__(); end
    def stop()  async.__stop__();  end

    def ack(info, opts = {})    async.__ack__(info, opts);    end
    def nack(info, opts = {})   async.__nack__(info, opts);   end
    def reject(info, opts = {}) async.__reject__(info, opts); end

    def __start__
      self.current = queue.subscribe(OPTS) do |info, properties, payload|
        callback = Callback.new(self, info)

        pool.post { handle(payload, properties, callback) }
      end
    end

    def __ack__ info, opts = {}
      queue.ack(info, opts)
    end

    def __nack__ info, opts = {}
      queue.nack(info, opts)
    end

    def __reject__ info, opts = {}
      queue.reject(info, opts)
    end

    def __stop__
      current.cancel if current
      self.current = nil
    end

  private

    def handle payload, properties, callback
      handler = handler_class.new(payload, properties, callback)
      handler.call
    rescue => e
      binding.pry
      callback.reject()
    end

    def queue
      @queue ||= begin
        context = Context.new(chan, spec)
        context.queue
      end
    end

    attr_accessor :current
    attr_reader :chan, :spec, :handler_class, :pool

  end
end
