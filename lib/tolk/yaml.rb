module Tolk
  module YAML
    SAFE_YAML_OPTIONS = SafeYAML::Deep.freeze({
      :default_mode => :safe,
      :deserialize_symbols => true
    })

    def self.load(yaml)
      # SafeYAML.load has different arity depending on the YAML engine used.
      if SafeYAML::YAML_ENGINE == "psych"
        SafeYAML.load(yaml, nil, SAFE_YAML_OPTIONS)
      else # syck
        SafeYAML.load(yaml, SAFE_YAML_OPTIONS)
      end
    end

    def self.load_file(filename)
      SafeYAML.load_file(filename, SAFE_YAML_OPTIONS)
    end

    def self.dump(payload)
      ::YAML.dump(payload)
    end
  end
end
