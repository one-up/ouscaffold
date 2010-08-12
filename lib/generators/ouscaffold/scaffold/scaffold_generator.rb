require 'rails/generators'
require 'rails/generators/rails/scaffold/scaffold_generator'

require 'generators/ouscaffold'

module Ouscaffold
  module Generators
    class ScaffoldGenerator < Rails::Generators::ScaffoldGenerator
      include Ouscaffold::ExtendedAttributes

      source_root File.join(File.dirname(__FILE__), 'templates')

      class_option :confirm,  :type => :boolean, :default => true,  :desc => "Need input confirmation"
      class_option :as_draft, :type => :boolean, :default => false, :desc => "Implement confirmation using draft column (not implemented)"
      class_option :display_id, :type => :boolean, :default => false, :desc => "create ActiveModel::Base#id view"
      class_option :git_add, :type => :boolean, :default => false, :desc => "git-add(1) to generated files"

      remove_hook_for :scaffold_controller
      remove_hook_for :test_framework
      hook_for :scaffold_controller, :required => true, :in => :ouscaffold

      def append_route_function
        prepend_file 'config/routes.rb', <<-END

def confirm_rules
  proc {
    member     do put  :confirm_edit; end
    collection do post :confirm_new ; end
  }
end

        END
      end

      def add_resource_route
        return if options[:actions].present?
        return super unless options[:confirm]
        if options[:singleton]
          route "resource :#{controller_file_name}, &confirm_rules"
        else
          route "resources :#{controller_file_name.pluralize}, &confirm_rules"
        end
      end

      # TODO: move to model generator
      def append_validation
        attributes.reverse_each do |attr|
          case attr.type
          when :integer
            inject_into_class File.join('app/models', class_path, "#{file_name}.rb"), "#{class_name}" do
              if attr.notnull
                "  validates :#{attr.name}, :numericality => true\n"
              else
                "  validates :#{attr.name}, :numericality => true, :allow_nil => true\n"
              end
            end
          when :string, :text
            if attr.notnull
              inject_into_class File.join('app/models', class_path, "#{file_name}.rb"), "#{class_name}" do
                "  validates :#{attr.name}, :length => { :minimum => 1 }\n"
              end
            end
          end
        end
      end

      # TODO: move to model generator
      # TODO: locales except jp
      def append_model_i18n
        model_locales = 'config/locales/ja/models'
        empty_directory model_locales
        template 'locale_ja.yml', File.join(model_locales, class_path, "#{file_name}.yml")
      end

      def git_add
        return unless options[:git_add]
        files = [
          "config/routes.rb",
          "app/controllers/#{controller_file_name}_controller.rb",
          "app/helpers/#{controller_file_name}_helper.rb",
          "app/models/#{file_name}.rb",
          "app/views/#{controller_file_name}/_confirm.html.erb",
          "app/views/#{controller_file_name}/_form.html.erb",
          "app/views/#{controller_file_name}/edit.html.erb",
          "app/views/#{controller_file_name}/index.html.erb",
          "app/views/#{controller_file_name}/new.html.erb",
          "app/views/#{controller_file_name}/show.html.erb",
          "config/locales/ja/models/#{file_name}.yml",
          "spec/controllers/#{controller_file_name}_controller_spec.rb",
          "spec/helpers/#{controller_file_name}_helper_spec.rb",
          "spec/models/#{file_name}_spec.rb",
          "spec/requests/#{controller_file_name}_spec.rb",
          "spec/routing/#{controller_file_name}_routing_spec.rb",
          "spec/views/#{controller_file_name}/edit.html.erb_spec.rb",
          "spec/views/#{controller_file_name}/index.html.erb_spec.rb",
          "spec/views/#{controller_file_name}/new.html.erb_spec.rb",
          "spec/views/#{controller_file_name}/show.html.erb_spec.rb",
          "db/migrate/*_create_#{controller_file_name}.rb"
        ]
        if options[:confirm]
          files += [
            "app/views/#{controller_file_name}/confirm_new.html.erb",
            "app/views/#{controller_file_name}/confirm_edit.html.erb",
            "spec/views/#{controller_file_name}/confirm_new.html.erb_spec.rb",
            "spec/views/#{controller_file_name}/confirm_edit.html.erb_spec.rb",
          ]
        end
        files.each do |f|
          git :add => f unless Dir.glob(f).empty?
        end
      end

      private
      def translate(eng)
        @translator ||= Translator.new('ja')
        @translator.translate(eng)
      end

    end
  end
end
#
# NOTE: from amatsuda-i18n_generator
#

class Translator
  def initialize(lang)
    @lang, @cache = lang, {}
  end

  def translate(word)
    return @cache[word] if @cache[word]
    begin
      w = CGI.escape ActiveSupport::Inflector.humanize(word)
      json = OpenURI.open_uri("http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=#{w}&langpair=en%7C#{@lang}").read
      result = if RUBY_VERSION >= '1.9'
                 ::JSON.parse json
               else
                 ActiveSupport::JSON.decode(json)
               end
      result['responseStatus'] == 200 ? (@cache[word] = result['responseData']['translatedText']) : word
    rescue => e
      puts %Q[failed to translate "#{word}" into "#{@lang}" language.]
      word
    end
  end
end

