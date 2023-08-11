# frozen_string_literal: true

shared_examples_for 'akrr' do |node|
  describe command('/home/akrr/akrr-1.0.0/bin/akrr.sh status'), node: node do
    its(:stdout) { is_expected.to match %r{AKRR Server is up} }
  end

  describe command('python /home/akrr/akrr-1.0.0/setup/scripts/akrrcheck_daemon.py'), node: node do
    its(:stdout) { is_expected.to match %r{REST API is up and running} }
    its(:stderr) { is_expected.to be_empty }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
