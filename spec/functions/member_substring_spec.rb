require 'spec_helper'

describe 'member_substring' do
  it 'should exist' do
    expect(Puppet::Parser::Functions.function('member_substring')).to eq('function_member_substring')
  end

  context 'array contains substring' do
    let(:array) {['nfsclient.bytes.write.server','infiniband.hca.type']}

    it 'should return present' do
      is_expected.to run.with_params(array, '^nfsclient').and_return('present')
    end
  end

  context 'array does not contain substring' do
    let(:array) {['nfsclient.bytes.write.server','nfsclient.bytes.write.server']}

    it 'should return present' do
      is_expected.to run.with_params(array, '^infiniband').and_return('absent')
    end
  end

  it 'should raise a ParseError if there is not 2 arguments' do
    is_expected.to run.with_params().and_raise_error(/wrong number of arguments/)
  end
  
  it 'should raise a ParseError if first argument is not an array' do
    is_expected.to run.with_params('foo', 'bar').and_raise_error(/First argument must be an array/)
  end

  it 'should raise a ParseError if second argument is not a string' do
    is_expected.to run.with_params(['foo'], ['bar']).and_raise_error(/Second argument must be a string/)
  end
end
