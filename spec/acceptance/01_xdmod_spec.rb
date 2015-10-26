require 'spec_helper_acceptance'

describe 'xdmod class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      host { 'xdmod.localdomain': ip => '127.0.0.1' }
      class { 'xdmod':
        apache_vhost_name => 'xdmod.localdomain',
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('xdmod') do
      it { should be_installed }
    end

    describe package('xdmod-appkernels') do
      it { should_not be_installed }
    end

    describe file('/etc/xdmod/portal_settings.ini') do
      its(:content) { should match /^appkernels = "off"$/ }
    end

    describe file('/etc/xdmod/portal_settings.d/appkernels.ini') do
      it { should_not exist }
    end

    describe command('curl -L --insecure http://xdmod.localdomain') do
      its(:stdout) { should match /Open XDMoD/ }
    end
  end

  context 'create_local_repo => false' do
    it 'should require no changes' do
      pp =<<-EOS
      host { 'xdmod.localdomain': ip => '127.0.0.1' }
      class { 'xdmod':
        create_local_repo => false,
        apache_vhost_name => 'xdmod.localdomain',
      }
      EOS

      apply_manifest(pp, :catch_changes => true)
    end
  end
end
