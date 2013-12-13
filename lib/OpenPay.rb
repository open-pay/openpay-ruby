require "OpenPay/version"
$: << "."










module OpenPay

  Dir['lib/OpenPay/*'].each {|file| require file }



  #API Endpoint
  DEV=' ​https://sandbox-api.openpay.mx'
  PROD='https://api.openpay.mx'







end
