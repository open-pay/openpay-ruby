
class OpenPayResource


  attr_accessor :api_hook

  def initialize(merchant_id,private_key,production=false)
     @merchant_id=merchant_id
     @private_key=private_key
     @base_url=OpenPayApi::base_url(production)
     @errors=false
    @production=production
    @timeout=90
    @api_hook=nil
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


  def url(args='')
     @base_url+"#{@merchant_id}/"+ self.class.name.to_s.downcase+ '/'+args
  end


  def list(args='')
    @base_url+ "#{@merchant_id}/"+ self.class.name.to_s.downcase+"/"+args
  end


 def get(args='')


   LOG.info("#{self.class.name.downcase}:")
   LOG.info("   GET Resource URL:#{url(args)}")
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
      raise e
  end


   JSON[json_out]
 end



  def each
    all.each do |line|
      yield line
    end
  end


  def delete_all

    if env == :production
      raise OpenPayError ('This method is not supported on PRODUCTION')
    end

    each do |res|
      warn "deleting #{res}"
      self.delete(res['id'])
    end

  end



 def delete(args)

   LOG.info("#{self.class.name.downcase}:")
   LOG.info("    DELETE  URL:#{url(args)}")

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


    LOG.info("#{self.class.name.downcase}:")

    LOG.info "   POST URL:#{url(args)}"
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

      #TODO vamos a regresar exception
       warn e.http_body
       @errors=true
       return JSON.parse  e.http_body
    rescue RestClient::Exception =>  e
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
  alias_method  :create , :post





  def hash2json(jash)
    JSON.generate(jash)
  end

  def json2hash(json)
    JSON[json]
  end



end