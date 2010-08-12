require 'generators/ouscaffold'
require 'generators/rspec'
require 'rails/generators/resource_helpers'
require 'generators/rspec/scaffold/scaffold_generator'

module Ouscaffold
  module Generators
    class RspecGenerator < Rspec::Generators::ScaffoldGenerator
      include Rails::Generators::ResourceHelpers
      include Ouscaffold::ExtendedAttributes

      undef_method :copy_controller_files, :copy_view_files, :copy_routing_files

      #source_root File.join(File.dirname(__FILE__), 'templates')  # workaround for Rspec::Generators::ScaffoldGenerator
      def self.source_root
        @_source_root = File.join(File.dirname(__FILE__), 'templates')
      end
      source_root

      class_option :singleton, :type => :boolean, :desc => "Supply to create a singleton controller"
      class_option :confirm,  :type => :boolean, :default => true,  :desc => "Need input confirmation"
      class_option :as_draft, :type => :boolean, :default => false, :desc => "Implement confirmation using draft column (not implemented)"

      def copy_controller_files
        template 'controller_spec.rb',
                 File.join('spec/controllers', controller_class_path, "#{controller_file_name}_controller_spec.rb")
      end

      def copy_view_files
        copy_view :edit
        copy_view :index unless options[:singleton]
        copy_view :new
        copy_view :show

        if options[:confirm]
          copy_view :confirm_new
          copy_view :confirm_edit
        end
      end

      def create_test_file
        template 'model_spec.rb', File.join('spec/models', class_path, "#{file_name}_spec.rb")
      end

      def copy_routing_files
        template 'routing_spec.rb',
          File.join('spec/routing', controller_class_path, "#{controller_file_name}_routing_spec.rb")
      end

      protected
      def value_for(attribute)
        if attribute.type == :integer
          @_value_for_cache_offset ||= rand(1000000) + 100000
          @_value_for_cache ||= {}
          @_value_for_cache[attribute.name] || \
            @_value_for_cache[attribute.name] = @_value_for_cache.size + @_value_for_cache_offset
        else
          super
        end
      end

    end
  end
end

