# openpay

Provides a ruby api to the Openpay Rest api.

## Full documentation at: http://docs.openpay.mx/

## Installation

   Add the following line to your Gem file


   # gem install --source https://code.stripe.com stripe

    gem 'openpay'

Update your bundle:

    $ bundle

Or install it from the command line:

    $ gem install openpay

##Requirements

    * ruby 1.8.7 or higher

## Usage:


### Initialization:
```ruby
require 'openpay'

#merchant and private key
merchant_id='mywvupjjs9xdnryxtplq'
private_key='sk_92b25d3baec149e6b428d81abfe37006'


#An openpay resource factory is created pointing  to the development environment
openpay=OpenpayApi.new(merchant_id,private_key)

#To enable production mode you should pass a third argument as true
#openpay_prod=OpenPayApi.new(merchant_id,private_key,true)

### The openpay factory instance is in charge to generate the required resources.

bankaccounts=openpay.create(:bankaccounts)
cards=openpay.create(:cards)
charges=openpay.create(:charges)
customers=openpay.create(:customers)
fees=openpay.create(:fees)
payouts=openpay.create(:payouts)
plans=openpay.create(:plans)
subscriptions=openpay.create(:subscriptions)
transfers=openpay.create(:transfers)
```


Each rest resource is represented by a class.   Resource class should be inzatiatied using the factory method as noted before.


### ruby hashes are used to

```ruby
require 'pp'

pp card_hash
 {:bank_name=>"visa",
  :holder_name=>"Vicente Olmos",
  :expiration_month=>"09",
  :card_number=>"4111111111111111",
  :expiration_year=>"14",
  :bank_code=>"bmx",
  :cvv2=>"111",
  :address=>
   {:postal_code=>"76190",
    :state=>"QRO",
    :line1=>"LINE1",
    :line2=>"LINE2",
    :line3=>"LINE3",
    :country_code=>"MX",
    :city=>"Queretaro"}}
```




Below is an example of how you can create a merchant card, a hash is passed as an argument as well a hash is returned as part of the response.

                 cards=openpay.create(:cards)

                 #creates merchant card
                 response_hash=cards.create(card_hash)


If you want to use json instead, you can perform the transform prior the api call  as noted below:

             ```ruby
             cards_json='{"bank_name":"visa","holder_name":"Vicente Olmos","expiration_month":"09",
             "card_number":"4111111111111111","expiration_year":"14","bank_code":"bmx","cvv2":"111",
             "address":{"postal_code":"76190","state":"QRO","line1":"LINE1","line2":"LINE2","line3":"LINE3","country_code":"MX","city":"Queretaro"}}'

             cards.create(JSON[cards_json])

In the same way, you can perform a transform after the api call.

              response_json=cards.create(JSON[cards_json]).to_json

### Cada recurso dependiendo sus estrucutra y metodos disponibles tendra cada uno de los metodos correspondientes:


####Argumentos
Dado que algunos recursos pueden formar parte del establecimiento o de los clientes,
los métodos listados disponen de un argumento opcional el cual acepta el id del cliente,
de esta forma esta función será aplicada a nivel cliente, y en su defecto la operación será aplicada a nivel establecimiento.

         #nivel establecimiento
         open_pay_resource.create(object_id)

         #nivel cliente
         open_pay_resource.create(object_id,customer_id)

####Metodos

#####create

   Crea el recurso dado

     open_pay_resource.create(object_id,customer_id=nil)

#####get

   Obtiene el objeto de un recurso dado

      open_pay_resource.get(object_id,customer_id=nil)


#####delete

   Borra un una instancia de un recurso

        open_pay_resource.delete(object_id,customer_id=nil)


#####delete_all

   Borra todas las instancia de un recurso (disponible solo en algunos metodos y en ambiente de pruebas)

         open_pay_resource.delete_all(customer_id=nil)


#####all
   Regresa un Array con todas  las  instancia de un recurso
     open_pay_resource.all(customer_id=nil)
#####each
   Regresa un bloque con todas  las  instancia de un recurso
      open_pay_resource.each(customer_id=nil)


## Excepciones/Errores

#### Este Api utiliza como base la libreria de rest-client[1][2]
Por lo cual hemos decidido utilizar su sistema de exepciones tal cual es.

Para codigos de regreso del 200 al 207, una excepcion de tipo  RestClient::Response sera regresada.

Para codigos de regreso 301, 302 o 307, se hara un redirecionamiento si la peticion de GET o HEAD.

Para el codigo 303, se hara un redirecionamiento y el request sera transformado  en un GET.

 Para otros casos una RestClient::Exception con la Respuesta sera lanzado; Una expcion expecifica sera lanzada para errores conocidos.

       #En el caso de listar un objeto no existente una excepcion de tipo RestClient::ResourceNotFound sera lanzada

      expect { @cards.all('111111') } .to raise_exception   RestClient::ResourceNotFound

Al generarse una exepcion se genera tambien un warning, si tienes acceso a la consola, podras ver ahi tus mensajes de errror en forma de warnings


[1] https://github.com/rest-client/rest-client

[2] http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html




## Mas Información

Para todos los ejemplos de uso recomiendo mirar los casos de prueba bajo el folder test/spec

1.  http://docs.openpay.mx/
