require 'rails/generators'

module Ouscaffold
  module Generators
    class LayoutGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      class_option :jslib,  :type => :string, :default => 'jquery',  :desc => "jquery or prototype"

      def copy_layout_files
        copy_file "ouscaffold.css", "public/stylesheets/ouscaffold/ouscaffold.css"
        copy_file "common.css", "public/stylesheets/ouscaffold/common.css"
        copy_file "forms.css", "public/stylesheets/ouscaffold/forms.css"
        copy_file "pages.css", "public/stylesheets/ouscaffold/pages.css"
        copy_file "_menu.html.erb", "app/views/shared/_menu.html.erb"
        template "ouscaffold.html.erb", "app/views/layouts/ouscaffold.html.erb"
        copy_file "ouscaffold_helper.rb", "app/helpers/ouscaffold_helper.rb"
      end

    end
  end
end
