require 'rails/generators'

module Ouscaffold
  module Generators
    class I18nGenerator < Rails::Generators::Base
      source_root File.join(File.dirname(__FILE__), 'templates')

      # TODO? to enable other locales
      def append_base_files
        get "http://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/ja.yml", "config/locales/ja.yml"
        gsub_file "config/application.rb", /#\s*(config.i18n.default_locale) = :\w+.*$/, \
            "\\1 = :ja" + 
            "\n    config.i18n.load_path << 'config/locales/ja.yml'" + 
            "\n    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'ja', '**', '*.{rb,yml}').to_s]" +
            "\n"
      
        empty_directory 'config/locales/ja'
        template 'scaffold_ja.yml', 'config/locales/ja/scaffold.yml'
      end

    end
  end
end

