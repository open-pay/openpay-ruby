class OpenpayException < StandardError
  attr_reader :description
  attr_reader :http_code
  attr_reader :http_body
  attr_reader :json_body
  attr_reader :error_code
  attr_reader :category


  def initialize(message=nil,json_message=true)
  #openpay errors  have a json error string
   if json_message
       json= JSON.parse message
      @description = json['description']
      @http_code =   json['http_code']
      @error_code = json['error_code']
      @json_body = message
     @category   = json['category']
   #other errors may or not have a json error string, so this case is for them
   else
     @description = message
     @http_code  =   ''
     @http_body  =  ''
     @json_body  =  ''
     @error_code = ''
    end
  end



=begin
rescue  RestClient::BadRequest  => e
  oe=OpenpayTransactionException.new(e.message,e.http_code,e.http_body,e.http_body)
  LOG.warn e.http_body
  @errors=true
  raise  oe
rescue RestClient::BadGateway => e
  oe=OpenpayConnectionException.new(e.message,e.http_code,e.http_body,e.http_body)
  LOG.warn e.http_body
  @errors=true
  raise  oe
rescue RestClient::Exception =>  e
  oe=OpenpayApiError.new(e.message,e.http_code,e.http_body,e.http_body)
  LOG.warn e.http_body
  @errors=true
  raise  oe
=end



end