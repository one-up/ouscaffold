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

      remove_hook_for :orm
      remove_hook_for :scaffold_controller
      remove_hook_for :test_framework
      remove_hook_for :stylesheets
      hook_for :orm, :in => :ouscaffold
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
          route_config =  class_path.collect{|namespace| "namespace :#{namespace} do " }.join(" ")
          route_config << "resource :#{controller_file_name}, &confirm_rules"
          route_config << " end" * class_path.size
          route route_config
        else
          route_config =  class_path.collect{|namespace| "namespace :#{namespace} do " }.join(" ")
          route_config << "resources :#{controller_file_name.pluralize}, &confirm_rules"
          route_config << " end" * class_path.size
          route route_config
        end
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

    end
  end
end

