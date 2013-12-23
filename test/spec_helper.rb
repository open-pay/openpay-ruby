$: << "../../lib/"
$: << ".."
$: << "../../lib/OpenPay/"


require 'factory_girl'
require 'open_pay'
require 'Factories'
require 'rspec'
require 'rspec-expectations'
require 'json_spec'



include OpenPay



RSpec.configure do |config|
  # ...
  config.expect_with :rspec do |c|
    c.syntax = :expect
    config.include JsonSpec::Helpers

  end
end