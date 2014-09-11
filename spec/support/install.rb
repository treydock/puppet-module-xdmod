shared_context "xdmod::install" do
  it { should contain_class('epel') }

  it do
    should contain_package('xdmod').only_with({
      :ensure   => 'present',
      :name     => 'xdmod',
      :require  => 'Yumrepo[epel]',
    })
  end
end
