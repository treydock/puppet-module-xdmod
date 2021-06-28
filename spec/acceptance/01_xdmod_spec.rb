require 'spec_helper_acceptance'

describe 'xdmod class:' do
  context 'default parameters' do
    it 'runs successfully' do
      pp = <<-EOS
      host { 'xdmod.localdomain': ip => '127.0.0.1' }
      class { 'mysql::server':
        root_password => 'secret',
      }
      class { 'xdmod':
        apache_vhost_name => 'xdmod.localdomain',
        resources         => [{
          'resource' => 'example',
          'name' => 'Example',
        }],
        manage_simplesamlphp => true,
        php_timezone => 'America/New_York',
        enable_ondemand => true,
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it_behaves_like 'xdmod-default', default
  end
end
