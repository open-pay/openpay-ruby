

#This class is the abstract base class for other Openpay resources
#This class defines the basic rest verbs making use of the rest-api gem.
#Method aliases are created to provide friendly names.
class OpenPayResource

  attr_accessor :api_hook

  def initialize(merchant_id,private_key,production=false)
     @merchant_id=merchant_id
     @private_key=private_key
     #assigns base url depending the request env
     @base_url=OpenpayApi::base_url(production)
     @errors=false
    @production=production
    @timeout=90
     #created resources should have a hook with the base class to keep control of created resources
    @api_hook=nil
  end


#returns the env set
  def  env
    if @production
      :production
    else
      :test
    end
  end

  #errors on last call
  def errors?
     @errors
  end




  def list(args='')
    @base_url+ "#{@merchant_id}/"+ self.class.name.to_s.downcase+"/"+args
  end


  def each
    all.each do |line|
      yield line
    end
  end


  def delete_all

    if env == :production
      raise OpenpayException.new('delete_all method cannot be used on production',false)
    end

    each do |res|
      warn "deleting #{res}"
      self.delete(res['id'])
    end

  end


  def get(args='')

    @errors=false

    LOG.debug("#{self.class.name.downcase}:")
    LOG.debug("   GET Resource URL:#{url(args)}")
    res=RestClient::Request.new(
        :method => :get,
        :url => url(args),
        :user => @private_key,
        :timeout => @timeout,
        :headers => {:accept => :json,
                     :content_type => :json,
                     :user_agent => 'Openpay/v1  Ruby-API',
        }
    )
    json_out=nil
    begin
      json_out=res.execute
     #exceptions
    rescue Exception => e
      @errors=true
      #will raise the appropriate exception and return
      OpenpayExceptionFactory::create(e)
    end

    JSON[json_out]

  end

 def delete(args)

   @errors=false

   LOG.debug("#{self.class.name.downcase}:")
   LOG.debug("    DELETE  URL:#{url(args)}")

   res=''
   req=RestClient::Request.new(
       :method => :delete,
       :url => url(args),
       :user => @private_key,
       :timeout => @timeout,
       :headers => {:accept => :json,
                    :content_type => :json,
                    :user_agent => 'Openpay/v1  Ruby-API',
       }
   )

  begin
      res=req.execute
      #exceptions
  rescue Exception => e
    @errors=true
    #will raise the appropriate exception and return
    OpenpayExceptionFactory::create(e)
  end

    #returns a hash
   JSON[res] if not res.empty?

 end

  def post(message,args='')

    return_hash=false
    @errors=false


    if message.is_a?(Hash)
      return_hash=true
      json= hash2json message
    else
      json=message
      return_hash=false
    end


    LOG.debug("#{self.class.name.downcase}:")
    LOG.debug "   POST URL:#{url(args)}"
    LOG.debug "   json: #{json}"

    begin

    #request
    res= RestClient::Request.new(
          :method => :post,
          :url => url(args) ,
          :user => @private_key,
          :timeout => @timeout,
          :payload => json,
          :headers => {:accept => :json,
                       :content_type => :json,
                       :user_agent => 'Openpay/v1  Ruby-API',
                       :json => json}
      ) .execute

    #exceptions
    rescue Exception => e
      @errors=true
      #will raise the appropriate exception and return
      OpenpayExceptionFactory::create(e)
    end

    #return
    if return_hash
      JSON.parse res
    else
      res
    end

  end



  def put (message,args='')

    return_hash=false

    if message.is_a?(Hash)
      return_hash=true
      json= hash2json message
    else
      json=message
      return_hash=false
    end


    LOG.info "PUT URL:#{url}"
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
                       :user_agent => 'Openpay/v1  Ruby-API',
                       :json => json}
      ) .execute
    rescue   RestClient::BadRequest  => e
      warn e.http_body
      @errors=true
      return JSON.parse  e.http_body
    end


    if return_hash
       JSON.parse res
    else
       res
    end

  end


  #aliases for rest verbs
  alias_method :all, :get
  alias_method :list, :get
  alias_method :update, :put
  alias_method  :create , :post


  def hash2json(jash)
    JSON.generate(jash)
  end

  def json2hash(json)
    JSON[json]
  end


 private
  def url(args='')
    @base_url+"#{@merchant_id}/"+ self.class.name.to_s.downcase+ '/'+args
  end




end