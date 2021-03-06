require 'generators/rspec/model/model_generator'
require 'generators/ouscaffold'

module Ouscaffold
  module Generators
    class RspecModelGenerator < Rspec::Generators::ModelGenerator
      include Ouscaffold::ExtendedAttributes
      include Ouscaffold::SpecHelpers

      class_option :model,    :type => :string,  :desc => "Specify model name"

      def self.source_root
        @_source_root = File.join(File.dirname(__FILE__), 'templates')
      end
      source_root
      #source_root File.join(File.dirname(__FILE__), 'templates')

      def create_model_spec
        template 'model_spec.rb', File.join('spec/models', specified.class_path, "#{file_name}_spec.rb")
      end

      def create_fixture_file
        if options[:fixture] && options[:fixture_replacement].nil?
          template 'fixtures.yml', File.join('spec/fixtures', specified.class_path, "#{table_name}.yml")
        end
      end
    end
  end
end
