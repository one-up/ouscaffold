require 'rails/generators'

class Rails::Generators::GeneratedAttribute
  attr_accessor :notnull
end

module Ouscaffold
  module ExtendedAttributes
    # override. defined in NamedBase
    def parse_attributes! #:nodoc:
      self.attributes = (attributes || []).map do |key_value|
        name, type, notnull = key_value.split(':')
        Rails::Generators::GeneratedAttribute.new(name, type).tap do |attr|
          attr.notnull = true if notnull.present?
        end
      end
    end
  end
end

