require 'rails/generators'
require 'rails/generators/erb/scaffold/scaffold_generator'

module Ouscaffold
  module Generators
    class ErbGenerator < Erb::Generators::ScaffoldGenerator
      source_root File.join(File.dirname(__FILE__), 'templates')

      argument :attributes, :type => :array, :default => [], :banner => "field:type[:option] field:type[:option]"

      class_option :confirm,  :type => :boolean, :default => true,  :desc => "Need input confirmation"
      class_option :as_draft, :type => :boolean, :default => false, :desc => "Implement confirmation using draft column (not implemented)"

      class_option :display_id, :type => :boolean, :default => false, :desc => "create ActiveModel::Base#id view"

      def available_views
        if options[:confirm]
          %w(index edit show new _form confirm_new confirm_edit _confirm)
        else
          %w(index edit show new _form)
        end
      end

      private
      def qualifier(attribute, content, options = {})
        case attribute.type
        when :timestamp, :date
          "l(#{content}) rescue nil"
        when :text
          if options[:truncate]
            "truncate(#{content}, :length => #{options[:truncate]})"
          else
            "content_tag(:pre, #{content})"
          end
        when :string
          if options[:truncate]
            "truncate(#{content}, :length => #{options[:truncate]})"
          else
            content
          end
        else
          content
        end
      end
            
    end
  end
end

