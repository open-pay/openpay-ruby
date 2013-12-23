require 'factory_girl'


FactoryGirl.define do

  factory :customer, class:Hash do
    name 'Ronnie'
    last_name 'Bermejo'
    email 'ronnie.bermejo.mx@gmail.com'
    phone_number '0180012345'
    address {{
        postal_code: '76190',
        state: 'QRO',
        line1: 'LINE1',
        line2: 'LINE2',
        line3: 'LINE3',
        country_code: 'MX',
        city: 'Queretaro',
     }}

    initialize_with { attributes }

  end



  factory :valid_card, class:Hash do

        bank_name  'visa'
        holder_name 'Vicente Olmos'
        expiration_month '09'
        card_number '4111111111111111'
        expiration_year '14'
        bank_code 'bmx'
        cvv2  '111'
       address {{
           postal_code: '76190',
           state: 'QRO',
           line1: 'LINE1',
           line2: 'LINE2',
           line3: 'LINE3',
           country_code: 'MX',
           city: 'Queretaro',
       }}

    initialize_with { attributes }

  end



  factory :expired_card, class:Hash do

    bank_name  'visa'
    holder_name 'Vicente Olmos'
    expiration_month '09'
    card_number '4000000000000069'
    expiration_year '14'
    bank_code 'bmx'
    cvv2  '111'
    address {{
        postal_code: '76190',
        state: 'QRO',
        line1: 'LINE1',
        line2: 'LINE2',
        line3: 'LINE3',
        country_code: 'MX',
        city: 'Queretaro',
    }}

    initialize_with { attributes }

  end



  factory :bank_account, class:Hash do

        holder_name  'Juan Perez'
        clabe  '032180000118359719'
        self.alias  'Cuenta principal'

        initialize_with { attributes }

  end






end
