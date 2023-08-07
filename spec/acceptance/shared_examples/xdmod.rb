# frozen_string_literal: true

shared_examples_for 'xdmod-full' do |node|
  describe package('xdmod'), node: node do
    it { is_expected.to be_installed }
  end

  describe package('xdmod-appkernels'), node: node do
    it { is_expected.to be_installed }
  end

  describe package('xdmod-supremm'), node: node do
    it { is_expected.to be_installed }
  end

  describe file('/etc/xdmod/portal_settings.ini'), node: node do
    its(:content) { is_expected.to match %r{^appkernels = "on"$} }
  end

  describe file('/etc/xdmod/portal_settings.d/appkernels.ini'), node: node do
    its(:content) { is_expected.to match %r{^appkernels = "on"$} }
  end

  describe command('curl -L --insecure http://xdmod.localdomain'), node: node do
    its(:stdout) { is_expected.to match %r{Open XDMoD} }
  end
end

shared_examples_for 'xdmod-default' do |node|
  describe package('xdmod'), node: node do
    it { is_expected.to be_installed }
  end

  describe file('/etc/xdmod/portal_settings.ini'), node: node do
    its(:content) { is_expected.to match %r{^appkernels = "off"$} }
  end

  describe command('curl -L --insecure http://xdmod.localdomain'), node: node do
    its(:stdout) { is_expected.to match %r{Open XDMoD} }
  end
end

shared_examples_for 'xdmod-appkernels' do |node|
  describe package('xdmod'), node: node do
    it { is_expected.to be_installed }
  end

  describe package('xdmod-appkernels'), node: node do
    it { is_expected.to be_installed }
  end

  describe file('/etc/xdmod/portal_settings.ini'), node: node do
    its(:content) { is_expected.to match %r{^appkernels = "on"$} }
  end

  describe file('/etc/xdmod/portal_settings.d/appkernels.ini'), node: node do
    its(:content) { is_expected.to match %r{^appkernels = "on"$} }
  end

  describe command('curl -L --insecure http://xdmod.localdomain'), node: node do
    its(:stdout) { is_expected.to match %r{Open XDMoD} }
  end
end

shared_examples_for 'xdmod-supremm' do |node|
  describe package('xdmod'), node: node do
    it { is_expected.to be_installed }
  end

  describe package('xdmod-supremm'), node: node do
    it { is_expected.to be_installed }
  end

  describe command('curl -L --insecure http://xdmod.localdomain'), node: node do
    its(:stdout) { is_expected.to match %r{Open XDMoD} }
  end
end
