class ResourceFactory


  def ResourceFactory::create(resource,merchant_id,private_key,production)

    Object.const_get(resource.capitalize).new(merchant_id,private_key,production)


  end

end

