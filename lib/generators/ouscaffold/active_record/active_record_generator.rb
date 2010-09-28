require 'rails/generators'
require 'rails/generators/active_record/model/model_generator'

require 'generators/ouscaffold'

module Ouscaffold
  module Generators
    class ActiveRecordGenerator < ActiveRecord::Generators::ModelGenerator
      include Ouscaffold::ExtendedAttributes
      source_root File.join(File.dirname(__FILE__), 'templates')

      remove_hook_for :test_framework

      #hook_for :rspec_model, :in => :ouscaffold
      invoke "ouscaffold:rspec_model"
      invoke "ouscaffold:i18n_model"
      
    end
  end
end


