class OpenpayExceptionFactory



  def   OpenpayExceptionFactory::create(exception)


    LOG.debug("exception.class: #{exception.class}")

    case exception

      #resource not found
      #malformed jason, invalid data, invalid request
      when   RestClient::BadRequest , RestClient::ResourceNotFound ,
                   RestClient::Conflict , RestClient::PaymentRequired
            oe=OpenpayApiTransactionError.new exception.http_body
            LOG.warn exception.http_body
            @errors=true
            raise  oe
      when Errno::EADDRINUSE , Errno::ETIMEDOUT ,OpenSSL::SSL::SSLError
        oe=OpenpayApiConnectionError.new(exception.message,false)
        LOG.warn exception.http_body
        @errors=true
        raise  oe
      when  RestClient::BadGateway, RestClient::Unauthorized
            oe=OpenpayApiConnectionError.new exception.http_body
            LOG.warn exception.http_body
            @errors=true
            raise  oe
        when  RestClient::Exception
            oe=OpenpayApiTransactionError.new exception.http_body
            LOG.warn exception.http_body
            @errors=true
             raise  oe
      else
        #We won't hide unknown exceptions , those should be raised
        raise exception

    end







  end







end