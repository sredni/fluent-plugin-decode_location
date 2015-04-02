module Fluent
  class DecodeLocationOutput < Output
  	Fluent::Plugin.register_output('decode_location', self)
  	config_param :key,                    :string, :default => 'parameters.loc'
    config_param :tag_prefix,             :string, :default => 'location_decoded.'
    config_param :sub_key,                :string, :default => nil

    SEPARATOR = 'a';
    SEPARATOR_DOT = 'b';
    SEPARATOR_DASH = 'c';

    def initialize
      super
      require 'base62'
      require 'base64'
    end

	  # Define `log` method for v0.10.42 or earlier
    unless method_defined?(:log)
      define_method("log") { $log }
    end

    def configure(conf)
      super
    end

    def start
      super
    end

    def shutdown
      super
    end

    def emit(tag, es, chain)
      es.each {|time, record|
        t = tag.dup
        new_record = decode_location(record)

        t = @tag_prefix + t unless @tag_prefix.nil?

        Engine.emit(t, time, new_record)
      }
      chain.next
    rescue => e
      log.warn("out_decode_location: error_class:#{e.class} error_message:#{e.message} tag:#{tag} es:#{es} bactrace:#{e.backtrace.first}")
    end

    def decode_location(record)
      source = record

      key.split('.').each do |v|
        if source[v] || source[v.to_sym]
          source = source[v] ? source[v] : source[v.to_sym]
        else
          record['break'] = true
          source = nil
          break
        end
      end

      if source
        hash = {}
        city = ''

        if source.include? ":|"
          exploded = source.split(":|")
          source = exploded[0]
          city = exploded[1]

          if city.is_a?(String)
            city = Base64.decode64(city)
            city.force_encoding('utf-8')
          end
        end

        array = source.to_i.base62_encode.gsub(SEPARATOR_DASH, '-').gsub(SEPARATOR_DOT, '.').split(SEPARATOR)

        hash['lat'] = array[0] ? array[0] : ''
        hash['lng'] = array[1] ? array[1] : ''
        hash['continent'] = array[2] ? array[2] : ''
        hash['countryCode'] = array[3] ? array[3] : ''
        hash['province'] = array[4] ? array[4] : ''
        hash['city'] = city

        target = sub_key ? (record[sub_key] ||= {}) : record

        target.merge!(hash)
      end
      return record
    rescue => e
      log.warn("out_decode_location: error_class:#{e.class} error_message:#{e.message} tag:#{tag} record:#{record} bactrace:#{e.backtrace.first}")
    end

  end
end