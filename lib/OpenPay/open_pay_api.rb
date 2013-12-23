require 'logger'
require 'resource_factory'
require 'base64'
require 'rest-client'
require 'uri'





LOG= Logger.new(STDOUT)


class OpenPayApi


  #API Endpoints
  API_DEV="https://sandbox-api.openpay.mx/v1/"
  API_PROD='https://api.openpay.mx'







  #by default the testing environment is used
  # need to c
  def initialize(merchant_id, private_key,production=false)
    @merchant_id=merchant_id
    @private_key=private_key
    @production=production
  end


  # @return [nil]
  def create(resource)
    klass=ResourceFactory::create(resource, @merchant_id,@private_key,@production)
    #attach api hook to be able to refere to same API instance from created resources
    #TODO we may move it to the initialize method
    klass.api_hook=self
    klass
  end


  def OpenPayApi::base_url(production)
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