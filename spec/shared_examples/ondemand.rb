shared_examples_for 'xdmod::ondemand' do |_facts|

  it { is_expected.to create_class('xdmod::ondemand') }
  it { is_expected.to contain_class('xdmod') }
  it { is_expected.not_to contain_class('geoip') }

  it { is_expected.to contain_yum__install('xdmod-ondemand') }
  it { is_expected.not_to contain_exec('xmod-ondemand-enable-geoip-file') }
  it { is_expected.to contain_exec('xmod-ondemand-disable-geoip-file') }

  context 'when geoip parameters defined' do
    let(:params) { { geoip_userid: '00001', geoip_licensekey: 'secret-key' } }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('geoip') }
    it { is_expected.to contain_exec('xmod-ondemand-enable-geoip-file') }
    it { is_expected.not_to contain_exec('xmod-ondemand-disable-geoip-file') }
  end
end
