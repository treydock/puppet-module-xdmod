Puppet::Type.newtype(:xdmod_supremm_setting) do
  ensurable

  newparam(:name, namevar: true) do
    desc 'Section/setting name to manage from supremm.ini'
    # namevar should be of the form section/setting
    validate do |value|
      unless value =~ %r{\S+/\S+}
        raise("Invalid xdmod_supremm_setting #{value}, entries should be in the form of section/setting.")
      end
    end
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'
    munge do |v|
      '"' + v.to_s.strip + '"'
    end

    def is_to_s(currentvalue) # rubocop:disable Style/PredicateName
      if resource.secret?
        '[old secret redacted]'
      else
        currentvalue
      end
    end

    def should_to_s(newvalue)
      if resource.secret?
        '[new secret redacted]'
      else
        newvalue
      end
    end
  end

  newparam(:secret, boolean: true) do
    desc 'Whether to hide the value from Puppet logs. Defaults to `false`.'

    newvalues(:true, :false)

    defaultto false
  end

  validate do
    if self[:ensure] == :present
      if self[:value].nil?
        raise Puppet::Error, "Property value must be set for #{self[:name]} when ensure is present"
      end
    end
  end

  autorequire(:file) do
    [
      '/etc/xdmod/portal_settings.d/supremm.ini',
    ]
  end
end
