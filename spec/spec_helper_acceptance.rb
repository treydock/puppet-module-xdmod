require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/acceptance/shared_examples/**/*.rb"].sort.each {|f| require f}

run_puppet_install_helper
install_module_on(hosts)
install_module_dependencies_on(hosts)
collection = ENV['BEAKER_PUPPET_COLLECTION'] || 'puppet5'

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
  if collection == 'puppet6'
    on hosts, puppet('module', 'install', 'puppetlabs-yumrepo_core', '--version', '">= 1.0.1 < 2.0.0"'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'puppetlabs-cron_core', '--version', '">= 1.0.0 < 2.0.0"'), { :acceptable_exit_codes => [0,1] }
  end
end
on hosts, 'puppet config set --section main show_diff true'
