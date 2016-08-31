require "liebre/version"

module Liebre
  
  autoload :Common,            'liebre/common'
  autoload :Config,            'liebre/config'
  autoload :ConnectionManager, 'liebre/connection_manager'
  autoload :Runner,            'liebre/runner'
  
  def self.config
    @config ||= Config.new
  end
  
  def self.env
    Config.env
  end
  
  def self.logger
    Config.logger
  end
  
end