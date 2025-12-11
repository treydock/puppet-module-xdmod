# frozen_string_literal: true

shared_examples_for 'xdmod::config::simplesamlphp' do |_facts|
  dirs = [
    '/etc/xdmod/simplesamlphp',
    '/etc/xdmod/simplesamlphp/config',
    '/etc/xdmod/simplesamlphp/metadata',
    '/etc/xdmod/simplesamlphp/cert'
  ]

  dirs.each do |dir|
    it { is_expected.not_to contain_file(dir) }
  end

  it { is_expected.not_to contain_file('/etc/xdmod/simplesamlphp/config/config.php') }
  it { is_expected.not_to contain_file('/etc/xdmod/simplesamlphp/config/authsources.php') }
  it { is_expected.not_to contain_file('/etc/xdmod/simplesamlphp/metadata/saml20-idp-remote.php') }

  it { is_expected.not_to contain_ssl_pkey('/etc/xdmod/simplesamlphp/cert/xdmod.key') }
  it { is_expected.not_to contain_openssl__config('/etc/xdmod/simplesamlphp/cert/xdmod.cnf') }
  it { is_expected.not_to contain_exec('create-x509-cert') }

  context 'when manage_simplesamlphp => true' do
    let(:params) { { manage_simplesamlphp: true } }

    dirs.each do |dir|
      it { is_expected.to contain_file(dir) }
    end

    it { is_expected.to contain_file('/etc/xdmod/simplesamlphp/config/config.php') }
    it { is_expected.to contain_file('/etc/xdmod/simplesamlphp/config/authsources.php') }
    it { is_expected.to contain_file('/etc/xdmod/simplesamlphp/metadata/saml20-idp-remote.php') }

    it { is_expected.to contain_ssl_pkey('/etc/xdmod/simplesamlphp/cert/xdmod.key') }
    it { is_expected.to contain_openssl__config('/etc/xdmod/simplesamlphp/cert/xdmod.cnf') }
    it { is_expected.to contain_exec('create-x509-cert') }
  end
end
