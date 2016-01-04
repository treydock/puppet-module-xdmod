shared_examples_for 'compute' do |node|
  describe package('pcp'), :node => node do
    it { should be_installed }
  end
end
