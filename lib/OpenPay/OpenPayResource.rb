require 'RestUtils'


#TODO , return JSON and HASH
#TODO expose only named methods , no REST methods


class OpenPayResource

  include RestUtils

  attr_accessor :api_hook

  def initialize(merchant_id,private_key,production=false)
     @merchant_id=merchant_id
     @private_key=private_key
     @base_url=DEV_BASE
     @errors=false
    @production=production
    @timeout=90
  end


  def  env
    if @production
      :production
    else
      :test
    end
  end

  def errors?
     @errors
  end


  #TODO, we wil require to use an array since there are resources with nested resources
  def url(args='')
    @base_url+ "#{@merchant_id}/"+ self.class.name.to_s.downcase+"/"+args
  end


 def get(args='')
   LOG.info("GET Resource URL:#{url}")
   res=RestClient::Request.new(
        :method => :get,
        :url => url(args),
        :user => @private_key,
        :timeout => @timeout,
        :headers => {:accept => :json,
                     :content_type => :json,
                     :user_agent => 'OpenPay/v1  Ruby-API',
        }
    )
   json_out=nil
  begin
    json_out=res.execute
  rescue  RestClient::ResourceNotFound => e
      warn e.http_body
      return nil
  end
   #TODO ver como puedo  sacar le status
   @status_last_call=res
   JSON[json_out]
 end



  def each
    get.each do |line|
      yield line
    end
  end


  def delete_all!

    if env == :production
      raise('This method is not supported on PRODUCTION')
    end

    each do |res|
      warn "deleting #{res}"
      self.delete(res['id'])
    end

  end



 def delete(args)

   LOG.info("DELETE Resource URL:#{url(args)}")

  RestClient::Request.new(
       :method => :delete,
       :url => url(args),
       :user => @private_key,
       :timeout => @timeout,
       :headers => {:accept => :json,
                    :content_type => :json,
                    :user_agent => 'OpenPay/v1  Ruby-API',
       }
   ).execute


 end

  def post(message,args='')

    if message.is_a?(Hash)
        json= hash2json message
    else
       json=message
    end



    LOG.info "POST  Resource URL:#{url}"
    LOG.info "   json: #{json}"

    begin
    res= RestClient::Request.new(
          :method => :post,
          :url => url(args) ,
          :user => @private_key,
          :timeout => @timeout,
          :payload => json,
          :headers => {:accept => :json,
                       :content_type => :json,
                       :user_agent => 'OpenPay/v1  Ruby-API',
                       :json => json}
      ) .execute
    rescue  RestClient::BadRequest  => e
       warn e.http_body
       @errors=true
       return JSON.parse  e.http_body
    rescue RestClient =>  e
        warn e.http_body
        @errors=true
        raise e
     end

   JSON.parse res

  end



  def put (message,args='')


    if message.is_a?(Hash)
      json= hash2json message
    else
      json=message
    end


    LOG.info "PUT  Resource URL:#{url}"
    LOG.info "   json: #{json}"

    begin
      res= RestClient::Request.new(
          :method => :put,
          :url => url(args),
          :user => @private_key,
          :timeout => @timeout,
          :payload => json,
          :headers => {:accept => :json,
                       :content_type => :json,
                       :user_agent => 'OpenPay/v1  Ruby-API',
                       :json => json}
      ) .execute
    rescue   RestClient::BadRequest  => e
      warn e.http_body
      @errors=true
      return JSON.parse  e.http_body
    end

    JSON.parse res

  end



  alias_method :all, :get
  alias_method :list, :get
  alias_method :update, :put
  alias_method  :add , :post
  alias_method  :create , :post





  def hash2json(jash)
    JSON.generate(jash)
  end

  def json2hash(json)
    JSON[json]
  end



end