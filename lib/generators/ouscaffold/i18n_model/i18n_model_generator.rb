require 'rails/generators'

require 'generators/ouscaffold'

module Ouscaffold
  module Generators
    class I18nModelGenerator < Rails::Generators::NamedBase
      include Ouscaffold::ExtendedAttributes
      source_root File.join(File.dirname(__FILE__), 'templates')

      class_option :model,    :type => :string,  :desc => "Specify model name"

      # TODO: locales except jp
      def append_model_i18n
        model_locales = 'config/locales/ja/models'
        empty_directory model_locales
        template 'locale_ja.yml', File.join(model_locales, specified.class_path, "#{specified.file_name}.yml")
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

