module CurieLookup
  extend ActiveSupport::Concern
  class InvalidCurie < StandardError; end

  module ClassMethods
    def curie_lookup(*fields)
      # options = fields.last.is_a?(Hash) ? fields.pop : {}
      serializer = DbRecord.new # (options[:serializer] || DbRecord).new

      fields.each do |field|
        define_method(:_curie_cache) do
          @_curie_cache ||= {}
        end

        define_method(field) do
          value = self[field]
          _curie_cache[value] ||= serializer.load(value)
        end

        define_method("#{field}=") do |value|
          key = serializer.dump(value)
          _curie_cache[key] = value unless key == value
          self[field] = key
        end
      end
    end
  end

  class Serializer
    REGEXP = /\[(.*):(.*)\]/

    def dump(obj)
      case obj
      when nil
        nil
      when String
        obj =~ REGEXP ? obj : raise(CurieLookup::InvalidCurie, obj)
      else
        "[#{obj.class.to_s.underscore}:#{obj.uid}]"
      end
    end

    def extract(curie)
      return nil if curie.blank?

      match, klass_name, uid = *curie.match(REGEXP)
      raise(InvalidCurie, curie) if match.nil?

      block_given? ? yield(klass_name, uid) : [klass_name, uid]
    end
  end

  class DbRecord < Serializer
    def load(curie)
      extract(curie) do |klass_name, uid|
        klass = klass_name.classify.constantize
        finder_options = { uid: uid }

        if klass.column_names.include?('state')
          finder_options[:state] = 'current'
        end

        klass.find_by(finder_options)
      end
    end
  end
end
