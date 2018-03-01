require 'puppetlabs_spec_helper/module_spec_helper'
require 'lib/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/support/**/*.rb"].sort.each {|f| require f}

at_exit { RSpec::Puppet::Coverage.report! }

add_custom_fact :concat_basedir, '/dne'
add_custom_fact :root_home, '/root'
add_custom_fact :sudoversion, ->(os, facts) {
  case facts[:operatingsystemmajrelease]
  when '6'
    '1.8.6p3'
  else
    '1.8.6p7'
  end
}
