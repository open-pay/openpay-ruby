$: << '.'
$: << 'lib'
$: << 'lib/openpay'

require 'openpay'
require 'factory_bot'
require 'test/Factories'
require 'rspec'
require 'json_spec'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:all) do
    FactoryBot.reload
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
    config.include JsonSpec::Helpers
  end

end
