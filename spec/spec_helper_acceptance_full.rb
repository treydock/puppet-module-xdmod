require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/acceptance/shared_examples/**/*.rb"].sort.each {|f| require f}

run_puppet_install_helper
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
end

on hosts, 'puppet config set --section main show_diff true'
apply_manifest_on(find_only_one(:web), "host { 'xdmod.localdomain': ip => '127.0.0.1' }", :catch_failures => true)
