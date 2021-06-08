require 'spec_helper'

describe 'xdmod::ondemand' do
  on_supported_os(supported_os: [
                    {
                      'operatingsystem' => 'CentOS',
                      'operatingsystemrelease' => ['7'],
                    },
                  ]).each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to create_class('xdmod::ondemand') }
      it { is_expected.to contain_class('xdmod') }
      it { is_expected.not_to contain_class('geoip') }

      it { is_expected.to contain_yum__install('xdmod-ondemand') }
      it { is_expected.not_to contain_augeas('xdmod-ondemand-geoip_file') }
      it { is_expected.to contain_augeas('xdmod-ondemand-rm-geoip_file') }

      context 'when geoip parameters defined' do
        let(:params) { { geoip_userid: '0001', geoip_licensekey: 'secret-key' } }

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_class('geoip').with(
            packages: ['geoipupdate'],
            config: {
              'userid'             => '0001',
              'licensekey'         => 'secret-key',
              'database_directory' => '/usr/share/GeoIP',
              'productids'         => ['GeoLite2-City'],
            },
            update_timers: ['*-*-* 06:00:00'],
          )
        end
        it { is_expected.to contain_file('/etc/GeoIP.conf').with_show_diff('false') }
        it { is_expected.to contain_augeas('xdmod-ondemand-geoip_file') }
        it { is_expected.not_to contain_augeas('xdmod-ondemand-rm-geoip_file') }
      end
    end
  end
end
