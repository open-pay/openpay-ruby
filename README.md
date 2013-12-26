# OpenPay

Esta Gema permite utilizar el Rest API de OpenPay desde ruby.

## Documentacion completa en: http://docs.openpay.mx/

## Instalacion

   Adiciona estas lineas a tu gem file

    gem 'OpenPay'

Actualiza tu bundle:

    $ bundle

O instalala tu mismo:

    $ gem install OpenPay




## Uso:


###Inicializacion
    require 'OpenPay'

    #Tu llave de negocio y llave privada
    merchant_id='mywvupjjs9xdnryxtplq'
    private_key='sk_92b25d3baec149e6b428d81abfe37006'

    #creamos factoria openpay  apuntando al ambiente de pruebas   (ambiente de pruebas por default)
    openpay=OpenPayApi.new(merchant_id,private_key)

    #Para utilizar el ambiente de produccion es necesario el tercer argumento puesto en true
    #openpay_prod=OpenPayApi.new(merchant_id,private_key,true)

###El Objeto openpay actua como una factoria de recursos rest , esta regresa un objeto que representa cada recurso

       bankaccounts=openpay.create(:bankaccounts)
       cards=openpay.create(:cards)
       charges=openpay.create(:charges)
       customers=openpay.create(:customers)
       fees=openpay.create(:fees)
       payouts=openpay.create(:payouts)
       plans=openpay.create(:plans)
       subscriptions=openpay.create(:subscriptions)
       transfers=openpay.create(:transfers)


### Los recursos OpenPay aceptan Hash nativos de ruby
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


#### Aqui se demustra como se crea una tarjeta a nivel establecimiento, un hash se pasa como argumento y a su vez un hash regresa como parte de la respuesta
                 cards=openpay.create(:cards)

                 #creates merchant card
                 response_hash=cards.create(card_hash)


#### Si recibes tus mensajes directo en json , puedes transformarlo justo antes de pasarlo como argumento en forma de Hash

             cards_json='{"bank_name":"visa","holder_name":"Vicente Olmos","expiration_month":"09",
             "card_number":"4111111111111111","expiration_year":"14","bank_code":"bmx","cvv2":"111",
             "address":{"postal_code":"76190","state":"QRO","line1":"LINE1","line2":"LINE2","line3":"LINE3","country_code":"MX","city":"Queretaro"}}'

             cards.create(JSON[cards_json])

#### A su vez las respuestas en caso de necesitasrlas en json puedas transformarlas justo al recibirlas

              response_json=cards.create(JSON[cards_json]).to_json







### Cada recurso dependiendo sus estrucutra y metodos disponibles tendra cada uno de los metodos correspondientes:

Dado que algunos recursos pueden formar parte del establecimiento o de los clientes,
los metodos listados disponen de un argumento opcional el cual acepta el id del cliente,
de esta forma esta funcion sera aplicada a nivel cliente, y en su defecto la operacion sera aplicada a nivel establecimiento.

         #nivel establecimiento
          open_pay_resource.create(object_id)

          #nivel cliente
          open_pay_resource.create(object_id,customer_id)


####create

   Crea el recurso dado

     open_pay_resource.create(object_id,customer_id=nil)

####get

   Obtiene el objeto de un recurso dado

      open_pay_resource.get(object_id,customer_id=nil)


####delete

   Borra un una instancia de un recurso


        open_pay_resource.delete(object_id,customer_id=nil)


####delete_all

   Borra todas las  instancia de un recurso   (disponible solo en algunos metodos y en ambiente de pruebas)

         open_pay_resource.delete_all(customer_id=nil)


####all

     open_pay_resource.all(customer_id=nil)
####each

     open_pay_resource.each(customer_id=nil)


## Excepciones/Errores

#### Este Api utiliza como base la libreria de rest-client[1][2]
Por lo cual hemos decidido utilizar su sistema de exepciones tal cual es.

Para codigos de regreso del 200 al 207, una excepcion de tipo  RestClient::Response sera regresada

Para codigos de regreso 301, 302 o 307, se hara un redirecionamiento si la peticion de GET o HEAD

Para el codigo 303, se hara un redirecionamiento y el request sera transformado  en un GET

 Para otros casos  una RestClient::Exception con la  Respuesta sera lanzado; Una expcion expecifica sera lanzada para errores conocidos.

       #En el caso de listar un objeto no existente una excepcion de tipo RestClient::ResourceNotFound sera lanzada

      expect { @cards.all('111111') } .to raise_exception   RestClient::ResourceNotFound

Al generarse una exepcion se genera tambien un warning, si tienes acceso a la consola, podras ver ahi tus mensajes de errror en forma de warnings









[1] https://github.com/rest-client/rest-client

[2] http:/   www.w3.org/Protocols/rfc2616/rfc2616-sec10.html




## Mas informacion

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
