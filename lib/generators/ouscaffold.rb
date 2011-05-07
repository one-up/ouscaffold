require 'rails/generators'
require 'rails/generators/named_base'

class Rails::Generators::GeneratedAttribute
  attr_accessor :notnull
end

# --model=MODEL option is given, original class name is replaced with MODEL
class Rails::Generators::SpecifiedNamedBase < Rails::Generators::NamedBase
  attr_reader :options
  attr_reader :named_base

  def initialize(named_base, options)
    @options = options
    @named_base = named_base
    assign_names!
  end

  # specified name resolver methods
  def specified?
    !options[:model].blank?
  end
  
  def assign_names!
    if specified? && @file_name.blank?
      @name = options[:model]
      @class_path = @name.include?('/') ? @name.split('/') : @name.split('::')
      @class_path.map! { |m| m.underscore }
      @file_name = @class_path.pop
    end
  end
  
  def class_path
    specified? ? @class_path : named_base.class_path
  end
  
  def file_name
    @file_name || named_base.file_name
  end

  def singular_name
    @singular_name ||=
      specified? ? file_name : named_base.singular_name
  end

  def plural_name
    @plural_name ||=
      (specified? ? file_name : singular_name).pluralize
  end

  def class_name
    @class_name ||=
      (class_path + [file_name]).map!{ |m| m.camelize }.join('::')
  end

  def table_name
    @table_name ||= begin
      base = pluralize_table_names? ? plural_name : singular_name
      (class_path + [base]).join('_')
    end
  end

  def singular_table_name
    @singular_table_name ||=
      (pluralize_table_names? ? table_name.singularize : table_name)
  end

  # generate nested resource string
  def resource
    return "@" + singular_table_name unless specified?
    (named_base.class_path.empty? ? "" : "[" + named_base.class_path.map{|v| ":#{v}" }.join(',') + "," ) +
    "@" + singular_table_name +
    (named_base.class_path.empty? ? "":"]")
  end

end



class Rails::Generators::NamedBase

  def specified
    @specified ||= Rails::Generators::SpecifiedNamedBase.new(self, options)
  end

end



module Rails::Generators::ResourceHelpers

  # [see] railties-3.0.x/lib/rails/generators/resource_helpers.rb
  def orm_instance(name = nil)
    name ||= specified.singular_table_name
    @orm_instance ||= @orm_class.new(name)
  end


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

