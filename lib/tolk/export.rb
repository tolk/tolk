module Tolk
  class Export
    attr_reader :name, :data, :destination

    def initialize(args)
      @name = args.fetch(:name, '')
      @data = args.fetch(:data, {})
      @destination = args.fetch(:destination, self.class.dump_path)
    end

    def dump
      File.open("#{destination}/#{name}.yml", "w+") do |file|
        file.write(YAML.dump(data))
      end
    end

    class << self
      def dump(args)
        new(args).dump
      end

      def dump_path
        Tolk::Locale._dump_path
      end
    end
  end
end
