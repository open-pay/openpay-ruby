class OpenPayResourceFactory
  def OpenPayResourceFactory::create(resource,merchant_id,private_key,production)
    begin
      Object.const_get(resource.capitalize).new(merchant_id,private_key,production)
    rescue NameError
      raise OpenpayException.new("Invalid resource name:#{resource}",false)
    end
  end
end

