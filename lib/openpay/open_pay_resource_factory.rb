class OpenPayResourceFactory
  def OpenPayResourceFactory::create(resource, merchant_id, private_key, production, timeout, country)
    begin
      resource = resource.capitalize
      if country == "co"
        resource = "#{resource}Co".to_sym
      end
      if country == "pe"
        resource = "#{resource}Pe".to_sym
      end
      Object.const_get(resource).new(merchant_id, private_key, production, timeout, country)
    rescue NameError
      raise OpenpayException.new("Invalid resource name:#{resource}", false)
    end
  end
end

