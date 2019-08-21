shared_examples_for 'compute' do |node|
  describe package('pcp'), node: node do
    it { is_expected.to be_installed }
  end
end
