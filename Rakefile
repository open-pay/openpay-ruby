 require 'rspec'
 require 'rspec/core/rake_task'

 task :default => [:spec]

 desc 'run specifications'
 
 RSpec::Core::RakeTask.new do |t|
   t.pattern = Dir.glob('test/spec/**/*_spec.rb')
 end


 RSpec::Core::RakeTask.new('bankaccounts') do |t|
   t.pattern = 'test/spec/bankaccounts*'
 end

