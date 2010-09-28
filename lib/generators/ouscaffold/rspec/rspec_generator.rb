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
                 File.join('spec/controllers', controller_class_path, "#{plural_file_name}_controller_spec.rb")
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

      def copy_routing_files
        template 'routing_spec.rb',
          File.join('spec/routing', controller_class_path, "#{plural_file_name}_routing_spec.rb")
      end

      private
      def mock_file_name(hash=nil)
        if hash
          method, and_return = hash.to_a.first
          method = orm_instance.send(method).split('.').last.gsub(/\(.*?\)/, '')
          "mock_#{singular_table_name}(:#{method} => #{and_return})"
        else
          "mock_#{singular_table_name}"
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

