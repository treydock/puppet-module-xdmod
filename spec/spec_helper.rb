require 'puppetlabs_spec_helper/module_spec_helper'
require 'lib/module_spec_helper'

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/support/**/*.rb"].sort.each {|f| require f}

at_exit { RSpec::Puppet::Coverage.report! }
