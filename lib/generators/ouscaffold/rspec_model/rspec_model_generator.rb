require 'generators/rspec/model/model_generator'
require 'generators/ouscaffold'

module Ouscaffold
  module Generators
    class RspecModelGenerator < Rspec::Generators::ModelGenerator
      include Ouscaffold::ExtendedAttributes
      include Ouscaffold::SpecHelpers

      def self.source_root
        @_source_root = File.join(File.dirname(__FILE__), 'templates')
      end
      source_root
      #source_root File.join(File.dirname(__FILE__), 'templates')

      def create_test_file
        template 'model_spec.rb', File.join('spec/models', class_path, "#{file_name}_spec.rb")
      end
    end
  end
end