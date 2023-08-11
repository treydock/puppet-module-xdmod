# frozen_string_literal: true

shared_examples_for 'xdmod::install' do |facts|
  case facts[:operatingsystemmajrelease]
  when '7'
    rpm_release = 'el7'
  when '8'
    rpm_release = 'el8'
  end

  it do
    is_expected.to contain_yum__install('xdmod').with(
      ensure: 'present',
      source: "https://github.com/ubccr/xdmod/releases/download/v10.0.3/xdmod-10.0.3-1.0.#{rpm_release}.noarch.rpm",
      timeout: '0',
      require: ['Yumrepo[epel]'],
    )
  end

  it { is_expected.not_to contain_yum__install('xdmod-appkernels') }
  it { is_expected.not_to contain_yum__install('xdmod-supremm') }

  context 'when enable_appkernel => true' do
    let(:params) { { enable_appkernel: true } }

    it do
      is_expected.to contain_yum__install('xdmod-appkernels').with(
        ensure: 'present',
        source: "https://github.com/ubccr/xdmod-appkernels/releases/download/v10.0.0/xdmod-appkernels-10.0.0-1.0.#{rpm_release}.noarch.rpm",
        timeout: '0',
        require: ['Yumrepo[epel]'],
      )
    end
  end

  context 'when enable_supremm => true' do
    let(:params) { { enable_supremm: true } }

    it do
      is_expected.to contain_yum__install('xdmod-supremm').with(
        ensure: 'present',
        source: "https://github.com/ubccr/xdmod-supremm/releases/download/v10.0.0/xdmod-supremm-10.0.0-1.0.#{rpm_release}.noarch.rpm",
        timeout: '0',
        require: ['Yumrepo[epel]'],
      )
    end
  end

  context 'when local_repo_name defined' do
    let(:pre_condition) { "yumrepo { 'local': }" }
    let(:params) { { local_repo_name: 'local' } }

    it do
      is_expected.to contain_package('xdmod').only_with(ensure: 'present',
                                                        name: 'xdmod',
                                                        require: ['Yumrepo[local]', 'Yumrepo[epel]'])
    end

    it { is_expected.not_to contain_package('xdmod-appkernels') }

    context 'when enable_appkernel => true' do
      let(:params) { { local_repo_name: 'local', enable_appkernel: true } }

      it do
        is_expected.to contain_package('xdmod-appkernels').only_with(ensure: 'present',
                                                                     name: 'xdmod-appkernels',
                                                                     require: ['Yumrepo[local]', 'Yumrepo[epel]'])
      end
    end

    context 'when enable_supremm => true' do
      let(:params) { { local_repo_name: 'local', enable_supremm: true } }

      it do
        is_expected.to contain_package('xdmod-supremm').only_with(ensure: 'present',
                                                                  name: 'xdmod-supremm',
                                                                  require: ['Yumrepo[local]', 'Yumrepo[epel]'])
      end
    end
  end
end
