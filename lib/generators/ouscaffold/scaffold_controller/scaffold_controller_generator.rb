require 'rails/generators'
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'

# TODO: implement as_draft option

module Ouscaffold
  module Generators
    class ScaffoldControllerGenerator < Rails::Generators::ScaffoldControllerGenerator
      source_root File.join(File.dirname(__FILE__), 'templates')

      class_option :confirm,  :type => :boolean, :default => true,  :desc => "Need input confirmation"
      class_option :as_draft, :type => :boolean, :default => false, :desc => "Implement confirmation using draft column (not implemented)"

      hook_for :template_engine, :in => :ouscaffold
      hook_for :test_framework, :in => :ouscaffold

      def create_controller_files
        template 'controller.rb', File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
      end
     
    end
  end
end
