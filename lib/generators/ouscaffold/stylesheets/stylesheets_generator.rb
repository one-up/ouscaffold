require 'rails/generators'

module Ouscaffold
  module Generators
    class StylesheetsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_style_files
        copy_file "ouscaffold.css", "public/stylesheets/ouscaffold/ouscaffold.css"
        copy_file "common.css", "public/stylesheets/ouscaffold/common.css"
        copy_file "forms.css", "public/stylesheets/ouscaffold/forms.css"
        copy_file "pages.css", "public/stylesheets/ouscaffold/pages.css"
      end

    end
  end
end

