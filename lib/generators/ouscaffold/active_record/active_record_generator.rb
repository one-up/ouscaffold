require 'rails/generators'
require 'rails/generators/active_record/model/model_generator'

require 'generators/ouscaffold'

module Ouscaffold
  module Generators
    class ActiveRecordGenerator < ActiveRecord::Generators::ModelGenerator
      include Ouscaffold::ExtendedAttributes
      source_root File.join(File.dirname(__FILE__), 'templates')

      class_option :model,    :type => :string,  :desc => "Specify model name"

      def create_migration_file
        return unless options[:migration] && options[:parent].nil?
        migration_template "migration.rb", "db/migrate/create_#{specified.table_name}.rb"
      end

      def create_model_file
        template 'model.rb', File.join('app/models', specified.class_path, "#{specified.file_name}.rb")
      end

      def create_module_file
        return if specified.class_path.empty?
        template 'module.rb', File.join('app/models', "#{specified.class_path.join('/')}.rb") if behavior == :invoke
      end

      remove_hook_for :test_framework

      #hook_for :rspec_model, :in => :ouscaffold
      invoke "ouscaffold:rspec_model"
      invoke "ouscaffold:i18n_model"
      
    end
  end
end


