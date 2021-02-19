require 'factory_bot'


FactoryBot.define do

  factory :customer, class: Hash do
    name 'Guadalupe'
    last_name 'Reyes'
    email 'lupereyes@lemail.com'
    phone_number '0180012345'
    address { {
        postal_code: '76190',
        state: 'QRO',
        line1: 'LINE1',
        line2: 'LINE2',
        line3: 'LINE3',
        country_code: 'MX',
        city: 'Queretaro',
    } }

    initialize_with { attributes }

  end

  factory :valid_card, class: Hash do

    bank_name 'visa'
    holder_name 'Vicente Olmos'
    expiration_month '09'
    card_number '4111111111111111'
    expiration_year '25'
    bank_code 'bmx'
    cvv2 '111'
    address { {
        postal_code: '76190',
        state: 'QRO',
        line1: 'LINE1',
        line2: 'LINE2',
        line3: 'LINE3',
        country_code: 'MX',
        city: 'Queretaro',
    } }

    initialize_with { attributes }

  end

   factory :valid_card2, class: Hash do

    bank_name 'visa'
    holder_name 'Alma Olmos'
    expiration_month '09'
    card_number '4242424242424242'
    expiration_year '22'
    bank_code 'bmx'
    cvv2 '111'
    address { {
        postal_code: '76190',
        state: 'QRO',
        line1: 'LINE1',
        line2: 'LINE2',
        line3: 'LINE3',
        country_code: 'MX',
        city: 'Queretaro',
    } }

    initialize_with { attributes }

  end

    factory :only_deposit, class: Hash do

    bank_name 'visa'
    holder_name 'Alma Olmos'
    expiration_month '09'
    card_number '4444444444444448'
    expiration_year '20'
    bank_code 'bmx'
    cvv2 '111'
    address { {
        postal_code: '76190',
        state: 'QRO',
        line1: 'LINE1',
        line2: 'LINE2',
        line3: 'LINE3',
        country_code: 'MX',
        city: 'Queretaro',
    } }

    initialize_with { attributes }

  end

  factory :expired_card, class: Hash do

    bank_name 'visa'
    holder_name 'Vicente Olmos'
    expiration_month '09'
    card_number '4000000000000069'
    expiration_year '20'
    bank_code 'bmx'
    cvv2 '111'
    address { {
        postal_code: '76190',
        state: 'QRO',
        line1: 'LINE1',
        line2: 'LINE2',
        line3: 'LINE3',
        country_code: 'MX',
        city: 'Queretaro',
    } }

    initialize_with { attributes }

  end

 
  factory :bank_account, class: Hash do

    holder_name 'Juan Perez'
    self.alias 'Cuenta principal'
    clabe '032180000118359719'

    initialize_with { attributes }

  end

  factory :card_charge, class: Hash do

    amount "1000"
    description "Cargo inicial a tarjeta"
    source_id "string"
    add_attribute :method, "card"
    order_id 'required'

    initialize_with { attributes }

  end
  

  factory :bank_charge, class: Hash do

    amount "10000"
    description "Cargo con banco"
    order_id 'required'
    add_attribute :method, "bank_account"

    initialize_with { attributes }

  end

  factory :refund_description, class: Hash do
    description 'A peticion del cliente'
    initialize_with { attributes }

  end

  factory :fee, class: Hash do
    customer_id 'dvocf97jd20es3tw5laz'
    amount '12.50'
    description 'Cobro de Comision'
    initialize_with { attributes }
  end

  factory :payout_card, class: Hash do

    add_attribute :method, 'card'
    destination_id '4444444444444448'
    amount '2'
    description 'Retiro de saldo semanal'

    initialize_with { attributes }

  end

  factory :payout_bank_account, class: Hash do

    add_attribute :method, 'bank_account'
    amount '1000'
    destination_id 'required'
    description 'Retiro de saldo semanal'

    initialize_with { attributes }

  end

  factory :plan, class: Hash do

    amount '150.00'
    status_after_retry 'cancelled'
    retry_times 2
    add_attribute :name ,'TODO INCLUIDO'
    repeat_unit 'week'
    trial_days 30
    repeat_every 1
    initialize_with { attributes }

  end

  factory :transfer, class: Hash do
    customer_id 'required'
    amount 12.50
    description 'Transferencia entre cuentas'
    initialize_with { attributes }
  end

  factory :subscription, class: Hash do
    trial_days 30
    card_id 'required'
    plan_id 'required'
    initialize_with { attributes }
  end
  
  factory :webhook1, class: Hash do
    url 'https://requestb.in/15r2d5n1'
    event_types ['charge.succeeded','charge.created','charge.cancelled','charge.failed']
    initialize_with { attributes }
  end

  factory :webhook2, class: Hash do
    url 'https://requestb.in/s3pj3ds3'
    event_types ['charge.succeeded','charge.created','charge.cancelled','charge.failed']
    initialize_with { attributes }
  end

end
