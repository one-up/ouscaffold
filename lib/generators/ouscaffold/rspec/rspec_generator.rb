require 'generators/rspec'
require 'rails/generators/resource_helpers'
require 'generators/rspec/scaffold/scaffold_generator'
require 'generators/ouscaffold'

module Ouscaffold
  module Generators
    class RspecGenerator < Rspec::Generators::ScaffoldGenerator
      include Rails::Generators::ResourceHelpers
      include Ouscaffold::ExtendedAttributes
      include Ouscaffold::SpecHelpers

      class_option :model,    :type => :string,  :desc => "Specify model name"

      undef_method :generate_controller_spec, :generate_view_specs, :generate_routing_spec

      #source_root File.join(File.dirname(__FILE__), 'templates')  # workaround for Rspec::Generators::ScaffoldGenerator
      def self.source_root
        @_source_root = File.join(File.dirname(__FILE__), 'templates')
      end
      source_root

      class_option :singleton, :type => :boolean, :desc => "Supply to create a singleton controller"
      class_option :confirm,  :type => :boolean, :default => true,  :desc => "Need input confirmation"
      class_option :as_draft, :type => :boolean, :default => false, :desc => "Implement confirmation using draft column (not implemented)"

      def generate_controller_spec
        template 'controller_spec.rb',
                 File.join('spec/controllers', controller_class_path, "#{plural_file_name}_controller_spec.rb")
      end

      def generate_view_specs
        copy_view :edit
        copy_view :index unless options[:singleton]
        copy_view :new
        copy_view :show

        if options[:confirm]
          copy_view :confirm_new
          copy_view :confirm_edit
        end
      end

      def generate_routing_spec
        template 'routing_spec.rb',
          File.join('spec/routing', controller_class_path, "#{plural_file_name}_routing_spec.rb")
      end

      private
      def mock_file_name(hash=nil)
        if hash
          method, and_return = hash.to_a.first
          method = orm_instance.send(method).split('.').last.gsub(/\(.*?\)/, '')
          "mock_#{specified.singular_table_name}(:#{method} => #{and_return})"
        else
          "mock_#{specified.singular_table_name}"
        end
      end

      def controller_path
        if controller_class_path.blank?
          plural_file_name
        else
          [controller_class_path, plural_file_name].join('/')
        end
      end

    end
  end
end

