require 'logger'
require 'ResourceFactory'



LOG= Logger.new(STDOUT)


class OpenPayApi

  #by default the testing envirionment is used
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


  def  env
    if @production
      :production
    else
      :test
    end
  end





end