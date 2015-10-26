require 'spec_helper_acceptance'

describe 'xdmod class:' do
  context 'appkernel and akrr enabled' do
    it 'should run successfully' do
      pp =<<-EOS
      host { 'xdmod.localdomain': ip => '127.0.0.1' }
      class { 'xdmod':
        apache_vhost_name => 'xdmod.localdomain',
        enable_appkernel  => true,
        akrr              => true,
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('xdmod') do
      it { should be_installed }
    end

    describe package('xdmod-appkernels') do
      it { should be_installed }
    end

    describe file('/etc/xdmod/portal_settings.ini') do
      its(:content) { should match /^appkernels = "on"$/ }
    end

    describe file('/etc/xdmod/portal_settings.d/appkernels.ini') do
      its(:content) { should match /^appkernels = "on"$/ }
    end

    describe command('curl -L --insecure http://xdmod.localdomain') do
      its(:stdout) { should match /Open XDMoD/ }
    end

    describe command('/home/akrr/akrr-1.0.0/bin/akrr.sh status') do
      its(:stdout) { should match /AKRR Server is up/ }
    end

    describe command('python /home/akrr/akrr-1.0.0/setup/scripts/akrrcheck_daemon.py') do
      its(:stdout) { should match /REST API is up and running/ }
      its(:stderr) { should be_empty }
      its(:exit_status) { should eq 0 }
    end
  end
end
