shared_examples_for "xdmod::install" do
  it { should contain_class('epel') }

  it { should contain_package('createrepo').with_ensure('present') }
  it { should contain_file('/opt/xdmod-repo').with_ensure('directory') }

  it do
    should contain_staging__file('xdmod-5.0.0-1.0.el6.noarch.rpm').with({
      :source   => 'http://downloads.sourceforge.net/project/xdmod/xdmod/5.0.0/xdmod-5.0.0-1.0.el6.noarch.rpm',
      :target   => '/opt/xdmod-repo/xdmod-5.0.0-1.0.el6.noarch.rpm',
      :notify   => 'Exec[createrepo-xdmod-repo]',
      :require  => 'File[/opt/xdmod-repo]',
    })
  end

  it { should_not contain_staging__file('xdmod-appkernels-5.0.0-1.0.el6.noarch.rpm') }

  it do
    should contain_exec('createrepo-xdmod-repo').with({
      :command      => '/usr/bin/createrepo /opt/xdmod-repo',
      :refreshonly  => 'true',
      :before       => 'Yumrepo[xdmod-local]',
      :require      => 'Package[createrepo]',
    })
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
      should contain_package('xdmod-appkernels').only_with({
        :ensure   => 'present',
        :name     => 'xdmod-appkernels',
        :require  => ['Yumrepo[xdmod-local]', 'Yumrepo[epel]'],
      })
    end

    it do
      should contain_staging__file('xdmod-appkernels-5.0.0-1.0.el6.noarch.rpm').with({
        :source   => 'http://downloads.sourceforge.net/project/xdmod/xdmod/5.0.0/xdmod-appkernels-5.0.0-1.0.el6.noarch.rpm',
        :target   => '/opt/xdmod-repo/xdmod-appkernels-5.0.0-1.0.el6.noarch.rpm',
        :notify   => 'Exec[createrepo-xdmod-repo]',
        :require  => 'File[/opt/xdmod-repo]',
      })
    end
  end

  context 'when create_local_repo => false' do
    let(:params) {{ :create_local_repo => false }}

    it { should_not contain_package('createrepo').with_ensure('present') }
    it { should_not contain_file('/opt/xdmod-repo').with_ensure('directory') }
    it { should_not contain_staging__file('xdmod-5.0.0-1.0.el6.noarch.rpm') }
    it { should_not contain_exec('createrepo-xdmod-repo') }
    it { should_not contain_yumrepo('xdmod-local') }
    it { should contain_package('xdmod').that_requires('Yumrepo[epel]') }
    it { should_not contain_package('xdmod').that_requires('Yumrepo[xdmod-local]') }

    context 'when local_repo_name is changed and repo defined' do
      let(:params) {{ :create_local_repo => false, :local_repo_name => 'local' }}
      let(:pre_condition) do
        "yumrepo { 'local': descr => 'local', baseurl => 'http://local.domain', gpgcheck => '0', enabled => '1' }"
      end

      it do
        repo = catalogue.resource('package', 'xdmod').send(:parameters)
        pp repo
      end
      it { should contain_package('xdmod').that_requires('Yumrepo[epel]') }
      it { should contain_package('xdmod').that_requires('Yumrepo[local]') }
    end
  end
end
