shared_examples_for "xdmod::install" do |facts|

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
  end

  context 'when create_local_repo => false' do
    let(:params) {{ :create_local_repo => false }}

    it { should contain_package('xdmod').that_requires('Yumrepo[epel]') }
    it { should_not contain_package('xdmod').that_requires('Yumrepo[xdmod-local]') }

    context 'when local_repo_name is changed and repo defined' do
      let(:params) {{ :create_local_repo => false, :local_repo_name => 'local' }}
      let(:pre_condition) do
        "yumrepo { 'local': descr => 'local', baseurl => 'http://local.domain', gpgcheck => '0', enabled => '1' }"
      end

      it { should contain_package('xdmod').that_requires('Yumrepo[epel]') }
      it { should contain_package('xdmod').that_requires('Yumrepo[local]') }
    end
  end
end
