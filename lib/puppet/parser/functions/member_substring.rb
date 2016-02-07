module Puppet::Parser::Functions
  newfunction(:member_substring, :type => :rvalue, :doc => <<-EOS
This function determines if a substring variable is a member of an array.

*Examples:*

    member(['nfsclient.bytes.write.server','infiniband.hca.type'], '^nfsclient')

Would return: 'present'

    member(['nfsclient.bytes.write.server','nfsclient.bytes.write.server'], '^infiniband')

Would return: 'absent'
    EOS
  ) do |args|

    # Validate the number of args
    if args.size != 2
      raise(Puppet::ParseError, "member_substring(): wrong number of arguments " +
            "given #{args.size}, require 2.")
    end

    array = args[0]
    substring = args[1]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, "member_substring(): First argument must be an array")
    end

    unless substring.is_a?(String)
      raise(Puppet::ParseError, "member_substring(): Second argument must be a string")
    end

    match = array.any? do |a|
      a =~ /#{substring}/
    end

    if match
      return 'present'
    else
      return 'absent'
    end
  end
end
