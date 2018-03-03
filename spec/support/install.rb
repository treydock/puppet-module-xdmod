shared_examples_for "xdmod::install" do |facts|
  case facts[:operatingsystemmajrelease]
  when '6'
    rpm_release = 'el6'
  when '7'
    rpm_release = 'el7.centos'
  end

  it do
    should contain_yum__install('xdmod').with(
      :ensure  => 'present',
      :source  => "https://github.com/ubccr/xdmod/releases/download/v7.5.0/xdmod-7.5.0-1.0.#{rpm_release}.noarch.rpm",
      :require => 'Yumrepo[epel]'
    )
  end

  it { should_not contain_yum__install('xdmod-appkernels') }
  it { should_not contain_yum__install('xdmod-supremm') }

  context 'when enable_appkernel => true' do
    let(:params) {{ :enable_appkernel => true }}

    it do
      should contain_yum__install('xdmod-appkernels').with(
        :ensure  => 'present',
        :source  => "https://github.com/ubccr/xdmod-appkernels/releases/download/v7.5.0/xdmod-appkernels-7.5.0-1.0.#{rpm_release}.noarch.rpm",
        :require => 'Yumrepo[epel]'
      )
    end
  end

  context 'when enable_supremm => true' do
    let(:params) {{ :enable_supremm => true }}

    it do
      should contain_yum__install('xdmod-supremm').with(
        :ensure  => 'present',
        :source  => "https://github.com/ubccr/xdmod-supremm/releases/download/v7.5.0/xdmod-supremm-7.5.0-1.0.#{rpm_release}.noarch.rpm",
        :require => 'Yumrepo[epel]'
      )
    end
  end

  context 'when local_repo_name defined' do
    let(:pre_condition) { "yumrepo { 'local': }"}
    let(:params) {{ :local_repo_name => 'local' }}

    it do
      should contain_package('xdmod').only_with({
        :ensure   => 'present',
        :name     => 'xdmod',
        :require  => ['Yumrepo[local]', 'Yumrepo[epel]'],
      })
    end

    it { should_not contain_package('xdmod-appkernels') }

    context 'when enable_appkernel => true' do
      let(:params) {{ :local_repo_name => 'local', :enable_appkernel => true }}

      it do
        should contain_package('xdmod-appkernels').only_with({
          :ensure   => 'present',
          :name     => 'xdmod-appkernels',
          :require  => ['Yumrepo[local]', 'Yumrepo[epel]'],
        })
      end
    end

    context 'when enable_supremm => true' do
      let(:params) {{ :local_repo_name => 'local', :enable_supremm => true }}

      it do
        should contain_package('xdmod-supremm').only_with({
          :ensure   => 'present',
          :name     => 'xdmod-supremm',
          :require  => ['Yumrepo[local]', 'Yumrepo[epel]'],
        })
      end
    end
  end
end
