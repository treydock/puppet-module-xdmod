shared_examples_for "xdmod::repo" do |facts|
  case facts[:operatingsystemmajrelease]
  when '6'
    rpm_release = 'el6'
  when '7'
    rpm_release = 'el7.centos'
  end

  it { should contain_class('epel') }

  it { should contain_package('createrepo').with_ensure('present') }
  it { should contain_file('/opt/xdmod-repo').with_ensure('directory') }

  it do
    should contain_archive("/opt/xdmod-repo/xdmod-7.0.1-1.0.#{rpm_release}.noarch.rpm").with({
      :source   => "https://github.com/ubccr/xdmod/releases/download/v7.0.1/xdmod-7.0.1-1.0.#{rpm_release}.noarch.rpm",
      :notify   => ['Exec[createrepo-xdmod-repo]', 'Exec[refresh-xdmod-repo]'],
      :require  => 'File[/opt/xdmod-repo]',
    })
  end

  it do
    should contain_archive("/opt/xdmod-repo/xdmod-appkernels-7.0.0-1.0.#{rpm_release}.noarch.rpm").with({
      :source   => "https://github.com/ubccr/xdmod-appkernels/releases/download/v7.0.0/xdmod-appkernels-7.0.0-1.0.#{rpm_release}.noarch.rpm",
      :notify   => ['Exec[createrepo-xdmod-repo]', 'Exec[refresh-xdmod-repo]'],
      :require  => 'File[/opt/xdmod-repo]',
    })
  end

  it do
    should contain_archive("/opt/xdmod-repo/xdmod-supremm-7.0.0-1.0.#{rpm_release}.noarch.rpm").with({
      :source   => "https://github.com/ubccr/xdmod-supremm/releases/download/v7.0.0/xdmod-supremm-7.0.0-1.0.#{rpm_release}.noarch.rpm",
      :notify   => ['Exec[createrepo-xdmod-repo]', 'Exec[refresh-xdmod-repo]'],
      :require  => 'File[/opt/xdmod-repo]',
    })
  end

  it do
    should contain_exec('createrepo-xdmod-repo').with({
      :command      => '/usr/bin/createrepo /opt/xdmod-repo',
      :refreshonly  => 'true',
      :before       => 'Yumrepo[xdmod-local]',
      :require      => 'Package[createrepo]',
    })
  end

  it do
    should contain_exec('refresh-xdmod-repo').with({
      :command      => '/usr/bin/yum clean metadata --disablerepo=* --enablerepo=xdmod-local',
      :refreshonly  => 'true',
      :require      => 'Yumrepo[xdmod-local]',
    })
  end

  it do
    should contain_exec('refresh-xdmod-repo').that_comes_before('Package[xdmod]')
  end

  it do
    should contain_yumrepo('xdmod-local').with({
      :descr    => 'xdmod-local',
      :baseurl  => 'file:///opt/xdmod-repo',
      :gpgcheck => '0',
      :enabled  => '1',
    })
  end

  it do
    should contain_package('xdmod').only_with({
      :ensure   => 'present',
      :name     => 'xdmod',
      :require  => ['Yumrepo[xdmod-local]', 'Yumrepo[epel]'],
    })
  end

  it { should_not contain_package('xdmod-appkernels') }

  context 'when enable_appkernel => true' do
    let(:params) {{ :enable_appkernel => true }}

    it do
      should contain_exec('refresh-xdmod-repo').with_before(['Package[xdmod]', 'Package[xdmod-appkernels]'])
    end
  end

  context 'when create_local_repo => false' do
    let(:params) {{ :create_local_repo => false }}

    it { should_not contain_package('createrepo').with_ensure('present') }
    it { should_not contain_file('/opt/xdmod-repo').with_ensure('directory') }
    it { should_not contain_staging__file('xdmod-5.0.0') }
    it { should_not contain_exec('createrepo-xdmod-repo') }
    it { should_not contain_yumrepo('xdmod-local') }
  end
end
