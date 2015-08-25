shared_examples_for "xdmod::install" do
  it { should contain_class('epel') }

  it do
    should contain_package('xdmod').only_with({
      :ensure   => 'present',
      :name     => 'xdmod',
      :require  => 'Yumrepo[epel]',
    })
  end

  it { should_not contain_package('xdmod-appkernels') }

  context 'when enable_appkernel => true' do
    let(:params) {{ :enable_appkernel => true }}

    it do
      should contain_package('xdmod-appkernels').only_with({
        :ensure   => 'present',
        :name     => 'xdmod-appkernels',
        :require  => 'Yumrepo[epel]',
      })
    end
  end
end
