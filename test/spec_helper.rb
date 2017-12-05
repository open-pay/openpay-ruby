$: << '.'
$: << 'lib'
$: << 'lib/openpay'

require 'openpay'
require 'factory_bot'
FactoryBot.find_definitions
require 'test/Factories'
require 'rspec'
require 'json_spec'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  #config.before(:suite) {FactoryBot.reload}

  config.expect_with :rspec do |c|
    c.syntax = :expect
    config.include JsonSpec::Helpers
  end

end
