require 'rails/generators'

module Ouscaffold
  module Generators
    class LayoutGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      hook_for :stylesheets

      def copy_layout_files
        copy_file "_menu.html.erb", "app/views/shared/_menu.html.erb"
        template "ouscaffold.html.erb", "app/views/layouts/ouscaffold.html.erb"
        copy_file "ouscaffold_helper.rb", "app/helpers/ouscaffold_helper.rb"
      end

    end
  end
end
