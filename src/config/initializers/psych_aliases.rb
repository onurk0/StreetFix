# frozen_string_literal: true

# Enable YAML aliases for Psych to maintain compatibility with older Rails YAML configs
# This is needed for Rails applications using YAML aliases in configuration files
# when running with newer versions of the Psych gem (5.0+)

module Psych
  class << self
    alias_method :original_load_file, :load_file
    alias_method :original_load, :load

    def load_file(filename, fallback: false, **kwargs)
      kwargs[:aliases] = true unless kwargs.key?(:aliases)
      original_load_file(filename, fallback: fallback, **kwargs)
    end

    def load(yaml, filename: nil, fallback: false, **kwargs)
      kwargs[:aliases] = true unless kwargs.key?(:aliases)
      original_load(yaml, filename: filename, fallback: fallback, **kwargs)
    end
  end
end