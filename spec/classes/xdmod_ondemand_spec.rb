# frozen_string_literal: true

require 'spec_helper'

describe 'xdmod::ondemand' do
  on_supported_os(supported_os: [
                    {
                      'operatingsystem' => 'RedHat',
                      'operatingsystemrelease' => ['7', '8']
                    }
                  ]).each do |os, facts|
    context "when #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to create_class('xdmod::ondemand') }
      it { is_expected.to contain_class('xdmod') }
      it { is_expected.not_to contain_class('geoip') }

      it { is_expected.to contain_yum__install('xdmod-ondemand') }
      it { is_expected.to contain_xdmod_ondemand_setting('ondemand-general/geoip_database').with_value('') }

      context 'when geoip parameters defined' do
        let(:params) { { geoip_userid: '0001', geoip_licensekey: 'secret-key' } }

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_class('geoip').with(
            config: {
              'userid' => '0001',
              'licensekey' => 'secret-key',
              'database_directory' => '/usr/share/GeoIP',
              'productids' => ['GeoLite2-City']
            },
            update_timers: ['*-*-* 00:00:00'],
          )
        end

        it { is_expected.to contain_file('/etc/GeoIP.conf').with_show_diff('false') }
        it { is_expected.to contain_xdmod_ondemand_setting('ondemand-general/geoip_database').with_value('/usr/share/GeoIP/GeoLite2-City.mmdb') }
      end
    end
  end
end
