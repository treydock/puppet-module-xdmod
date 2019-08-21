# Function to test member substring
Puppet::Functions.create_function(:'xdmod::member_substring') do
  # Function to test member substring
  # @param array The array to check.
  # @param substring The substring used for check.
  # @return [String] Returns `present` if substring in array
  # @return [String] Returns `absent` if substring not in array
  # @example Return `present`
  #   member(['nfsclient.bytes.write.server','infiniband.hca.type'], '^nfsclient')
  # @example Return `absent`
  #   member(['nfsclient.bytes.write.server','nfsclient.bytes.write.server'], '^infiniband')
  dispatch :check do
    param 'Array', :array
    param 'String', :substring
  end

  def check(array, substring)
    match = array.any? do |a|
      a =~ %r{#{substring}}
    end

    return 'present' if match
    'absent'
  end
end
