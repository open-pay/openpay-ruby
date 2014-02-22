require 'logger'
require 'base64'
require 'rest-client'
require 'uri'

require 'openpay/open_pay_resource_factory'
require 'errors/openpay_exception'

LOG= Logger.new(STDOUT)
#change to Logger::DEBUG if need trace information
#due the nature of the information, we recommend to never use a log file when in debug
LOG.level=Logger::ERROR

class OpenpayApi
  #API Endpoints
  API_DEV='https://sandbox-api.openpay.mx/v1/'
  API_PROD='https://api.openpay.mx'

  #by default the testing environment is used
  def initialize(merchant_id, private_key,production=false)
    @merchant_id=merchant_id
    @private_key=private_key
    @production=production
  end


  # @return [nil]
  def create(resource)
    klass=OpenPayResourceFactory::create(resource, @merchant_id,@private_key,@production)
    #attach api hook to be able to refere to same API instance from created resources
    #TODO we may move it to the initialize method
    klass.api_hook=self
    klass
  end


  def OpenpayApi::base_url(production)
    if production
      API_PROD
    else
      API_DEV
    end
  end


  def  env
    if @production
      :production
    else
      :test
    end
  end





end