require 'rails/generators'

module Ouscaffold
  module Generators
    class InstallGenerator < Rails::Generators::Base
      invoke 'ouscaffold:i18n'
      invoke 'ouscaffold:layout'
    end
  end
end

