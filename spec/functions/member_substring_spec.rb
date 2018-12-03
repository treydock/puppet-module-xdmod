require 'spec_helper'

describe 'xdmod::member_substring' do
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
    is_expected.to run.with_params().and_raise_error(/expects 2 arguments/)
  end
  
  it 'should raise a ParseError if first argument is not an array' do
    is_expected.to run.with_params('foo', 'bar').and_raise_error(/parameter 'array' expects an Array/)
  end

  it 'should raise a ParseError if second argument is not a string' do
    is_expected.to run.with_params(['foo'], ['bar']).and_raise_error(/parameter 'substring' expects a String/)
  end
end
