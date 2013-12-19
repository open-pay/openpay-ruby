$: << "../../lib/"
$: << ".."
$: << "../../lib/OpenPay/"


require 'factory_girl'
require 'RestUtils'
require 'OpenPay'
require 'Factories'
require 'rspec'
require 'rspec-expectations'
require 'json_spec'



include RestUtils
include OpenPay



RSpec.configure do |config|
  # ...
  config.expect_with :rspec do |c|
    c.syntax = :expect
    config.include JsonSpec::Helpers

  end
end