shared_examples_for 'xdmod-full' do |node|
  describe package('xdmod'), :node => node do
    it { should be_installed }
  end

  describe package('xdmod-appkernels'), :node => node do
    it { should be_installed }
  end

  describe package('xdmod-supremm'), :node => node do
    it { should be_installed }
  end

  describe file('/etc/xdmod/portal_settings.ini'), :node => node do
    its(:content) { should match /^appkernels = "on"$/ }
  end

  describe file('/etc/xdmod/portal_settings.d/appkernels.ini'), :node => node do
    its(:content) { should match /^appkernels = "on"$/ }
  end

  describe command('curl -L --insecure http://xdmod.localdomain'), :node => node do
    its(:stdout) { should match /Open XDMoD/ }
  end
end

shared_examples_for 'xdmod-default' do |node|
  describe package('xdmod'), :node => node do
    it { should be_installed }
  end

  describe file('/etc/xdmod/portal_settings.ini'), :node => node do
    its(:content) { should match /^appkernels = "off"$/ }
  end

  describe command('curl -L --insecure http://xdmod.localdomain'), :node => node do
    its(:stdout) { should match /Open XDMoD/ }
  end
end

shared_examples_for 'xdmod-appkernels' do |node|
  describe package('xdmod'), :node => node do
    it { should be_installed }
  end

  describe package('xdmod-appkernels'), :node => node do
    it { should be_installed }
  end

  describe file('/etc/xdmod/portal_settings.ini'), :node => node do
    its(:content) { should match /^appkernels = "on"$/ }
  end

  describe file('/etc/xdmod/portal_settings.d/appkernels.ini'), :node => node do
    its(:content) { should match /^appkernels = "on"$/ }
  end

  describe command('curl -L --insecure http://xdmod.localdomain'), :node => node do
    its(:stdout) { should match /Open XDMoD/ }
  end
end

shared_examples_for 'xdmod-supremm' do |node|
  describe package('xdmod'), :node => node do
    it { should be_installed }
  end

  describe package('xdmod-supremm'), :node => node do
    it { should be_installed }
  end

  describe command('curl -L --insecure http://xdmod.localdomain'), :node => node do
    its(:stdout) { should match /Open XDMoD/ }
  end
end
