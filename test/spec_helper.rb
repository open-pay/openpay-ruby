$: << '.'
$: << 'lib'
$: << 'lib/openpay'

require 'openpay'
require 'factory_bot'
#uncomment below to test on travis-ci
# FactoryBot.find_definitions
require 'Factories'
require 'rspec'
require 'json_spec'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  #uncomment below to test on local
  #config.before(:suite) {FactoryBot.reload}

  config.expect_with :rspec do |c|
    c.syntax = :expect
    config.include JsonSpec::Helpers
  end

end
