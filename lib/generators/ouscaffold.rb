require 'rails/generators'

class Rails::Generators::GeneratedAttribute
  attr_accessor :notnull
end

module Ouscaffold
  module ExtendedAttributes
    # override. defined in NamedBase
    def parse_attributes! #:nodoc:
      self.attributes = (attributes || []).map do |key_value|
        name, type, notnull, *attrs = key_value.split(':')
        Rails::Generators::GeneratedAttribute.new(name, type).tap do |attr|
          attr.notnull = true if notnull.present?
          attr.rest = attrs if attrs.present?
        end
      end
    end

    def self.included(klass)
      klass.argument :attributes, :type => :array, :default => [], :banner => "field:type:null? field:type:null?"
    end

  end

  module SpecHelpers
    protected
    def value_for(attribute)
      case attribute.type
      when :string
        "#{attribute.name.titleize}".inspect
      when :integer
        @_value_for_cache_offset ||= rand(10000000) + 100000
        @_value_for_cache ||= {}
        @_value_for_cache[attribute.name] || \
          @_value_for_cache[attribute.name] = @_value_for_cache.size + @_value_for_cache_offset
      else
        attribute.default.inspect
      end
    end
  end

end

