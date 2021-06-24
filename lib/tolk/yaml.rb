module Tolk
  module YAML
    SAFE_YAML_OPTIONS = SafeYAML::Deep.freeze({
      default_mode: :safe,
      deserialize_symbols: true,
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
      if payload.respond_to?(:ya2yaml)
        payload.ya2yaml(syck_compatible: true)
      else
        ::YAML.dump(payload, line_width: Tolk::Config.yaml_line_width)
      end
    end
  end
end
