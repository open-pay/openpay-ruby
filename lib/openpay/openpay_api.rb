require 'logger'
require 'base64'
require 'rest-client'
require 'uri'

require 'openpay/open_pay_resource_factory'
require 'errors/openpay_exception'

LOG = Logger.new(STDOUT)
#change to Logger::DEBUG if need trace information
#due the nature of the information, we recommend to never use a log file when in debug
LOG.level = Logger::FATAL

class OpenpayApi
  #API Endpoints
  API_DEV = 'https://sandbox-api.openpay.mx/v1/'
  API_PROD = 'https://api.openpay.mx/v1/'
  API_DEV_CO = 'https://sandbox-api.openpay.co/v1/'
  API_PROD_CO = 'https://api.openpay.co/v1/'

  # by default testing environment is used
  # country can take value 'mx' (Mexico) or 'co' Colombia
  def initialize(merchant_id, private_key, country = "mx", production = false, timeout = 90)
    @merchant_id = merchant_id
    @private_key = private_key
    @production = production
    @timeout = timeout
    @country = country
  end

  def create(resource)
    klass = OpenPayResourceFactory::create(resource, @merchant_id, @private_key, @production, @timeout, @country)
    klass.api_hook = self
    klass
  end

  def OpenpayApi::base_url(production, country)
    if country == "mx"
      if production
        API_PROD
      else
        API_DEV
      end
    elsif country == "co"
      if production
        API_PROD_CO
      else
        API_DEV_CO
      end
    else
      LOG.error "Country not found, only mx (México) or co (Colombia)"
      raise OpenpayException.new "Country not found, only 'mx' (México) or 'co' (Colombia)", false
    end
  end

  def env
    if @production
      :production
    else
      :test
    end
  end

end
