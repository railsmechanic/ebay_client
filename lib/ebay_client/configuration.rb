class EbayClient::Configuration
  class ApiKey
    attr_reader :appid, :devid, :certid, :token
    def initialize(key_values={})
      raise ArgumentError.new('Key values must be of type Hash') unless key_values.is_a?(Hash)
      @appid  = key_values.fetch(:appid, nil)
      @devid  = key_values.fetch(:devid, nil)
      @certid = key_values.fetch(:certid, nil)
      @token  = key_values.fetch(:token, nil)
    end
  end

  attr_reader :version, :wsdl_file, :siteid, :routing, :url, :api_keys, :warning_level, :error_language, :savon_log_level, :http_read_timeout

  def initialize(configuration={})
    raise ArgumentError.new('Configuration must be a Hash') unless configuration.is_a?(Hash)
    @version            = configuration.fetch(:version, 1119)
    @wsdl_file          = configuration.fetch(:wsdl_file, 'http://developer.ebay.com/webservices/1119/eBaySvc.wsdl')
    @siteid             = configuration.fetch(:siteid, 0)
    @routing            = configuration.fetch(:routing, 'default')
    @url                = configuration.fetch(:url, 'https://api.sandbox.ebay.com/wsapi')
    @api_keys           = Array(configuration.fetch(:api_keys, []))
    @warning_level      = configuration.fetch(:warning_level, 'High')
    @error_language     = configuration.fetch(:error_language, 'en_US')
    @savon_log_level    = configuration.fetch(:savon_log_level, :debug)
    @http_read_timeout  = configuration.fetch(:http_read_timeout, 600)
    @preload            = configuration.fetch(:preload, false)
    @api_keys           = @api_keys.flat_map { |key_values| ApiKey.new(key_values) }.shuffle
    @current_key        = @api_keys.first
  end

  def next_key!
    @current_key = @api_keys.shuffle
  end

  def appid
    @current_key.appid
  end

  def devid
    @current_key.devid
  end

  def certid
    @current_key.certid
  end

  def token
    @current_key.token
  end

  def preload?
    !!@preload
  end

end
