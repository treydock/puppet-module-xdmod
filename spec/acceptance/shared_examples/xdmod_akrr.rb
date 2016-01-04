shared_examples_for 'akrr' do |node|
  describe command('/home/akrr/akrr-1.0.0/bin/akrr.sh status'), :node => node do
    its(:stdout) { should match /AKRR Server is up/ }
  end

  describe command('python /home/akrr/akrr-1.0.0/setup/scripts/akrrcheck_daemon.py'), :node => node do
    its(:stdout) { should match /REST API is up and running/ }
    its(:stderr) { should be_empty }
    its(:exit_status) { should eq 0 }
  end
end
