require 'rails/generators'
require 'rails/generators/rails/helper/helper_generator'

module Ouscaffold
  module Generators
    class HelperGenerator < Rails::Generators::HelperGenerator
      source_root File.expand_path('../templates', __FILE__)
    end
  end
end
