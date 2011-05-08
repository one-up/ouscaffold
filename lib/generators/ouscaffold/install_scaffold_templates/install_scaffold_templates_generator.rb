require 'rails/generators/resource_helpers'

module Ouscaffold
  module Generators
    class InstallScaffoldTemplatesGenerator < Rails::Generators::Base
      
      source_root File.join(File.dirname(__FILE__), '../erb/templates')

      def create_root_folder
        empty_directory "lib/templates/ouscaffold/erb"
      end

      def copy_view_files
        available_views.each do |view|
          filename = view+".html.erb"
          copy_file filename, File.join("lib/templates/ouscaffold/erb", filename)
        end
      end

    protected

      def available_views
        %w(index edit show new _form confirm_new confirm_edit _confirm)
      end
      
    end
  end
end

