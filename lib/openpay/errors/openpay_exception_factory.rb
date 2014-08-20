class OpenpayExceptionFactory

  def OpenpayExceptionFactory::create(exception)

    LOG.warn("An exception has been raised (original exception class: #{exception.class})")

    case exception

      #resource not found
      #malformed jason, invalid data, invalid request
      when RestClient::BadRequest, RestClient::ResourceNotFound,
          RestClient::Conflict, RestClient::PaymentRequired,
          RestClient::UnprocessableEntity

        oe=OpenpayTransactionException.new exception.http_body
        LOG.warn "-OpenpayTransactionException: #{exception.http_body}"
        @errors=true
        raise oe

      #connection, timeouts, network related errors
      when Errno::EADDRINUSE, Errno::ETIMEDOUT, OpenSSL::SSL::SSLError
        #since this exceptions are not based on the rest api exceptions
        #we do not have the json message so we just build the exception
        #with the original exception message set in e.description and e.message
        oe=OpenpayConnectionException.new(exception.message,false)
        LOG.warn exception.message
        @errors=true
        raise oe
      #badgateway-connection error, invalid credentials
      when  RestClient::BadGateway, RestClient::Unauthorized
            oe=OpenpayConnectionException.new exception.http_body
            LOG.warn exception.http_body
            @errors=true
            raise oe

      when  RestClient::Exception , RestClient::InternalServerError
            LOG.warn exception
            if exception.http_body
              oe=OpenpayException.new exception.http_body
            else
              oe=OpenpayException.new(exception.message, false)
            end
            @errors=true
            raise oe
      else
        #We won't hide unknown exceptions , those should be raised
        LOG.warn exception.message
        raise exception
    end
  end

end
