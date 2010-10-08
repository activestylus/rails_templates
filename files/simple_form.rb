SimpleForm.wrapper_tag = :div
       
module SimpleForm
  
  module ActionViewExtensions
    module Builder

      def collection_radio(attribute, collection, value_method, text_method, options={}, html_options={})
        collection.inject('') do |result, item|
          value = item.send value_method
          text  = item.send text_method

          default_html_options = default_html_options_for_collection(item, value, options, html_options)

          result << radio_button(attribute, value, default_html_options) <<
                    label("#{attribute}_#{value.to_s.downcase}", text, :class => "collection_radio")
        end
      end

      def collection_check_boxes(attribute, collection, value_method, text_method, options={}, html_options={})
        collection.inject('') do |result, item|
          value = item.send value_method
          text  = item.send text_method

          default_html_options = default_html_options_for_collection(item, value, options, html_options)
          default_html_options[:multiple] = true

          result << check_box(attribute, default_html_options, value, '') <<
                    label("#{attribute}_#{value.to_s.downcase}", text, :class => "collection_check_boxes")
        end
      end

    end
  end
  
  module Inputs
    class Base
    protected
      def attribute_required?
        options[:required] || false
      end
    end
  end

# Patch to make boolean inputs display before labels
  class FormBuilder < ActionView::Helpers::FormBuilder
    def input(attribute_name, options={}, &block)
      define_simple_form_attributes(attribute_name, options)
      if block_given?
        SimpleForm::Inputs::BlockInput.new(self, block).render
      else
        klass = self.class.mappings[input_type] ||
          self.class.const_get(:"#{input_type.to_s.camelize}Input")
        if input_type == :boolean 
          SimpleForm.components = [ :input, :label, :hint, :error ]
        else
          SimpleForm.components = [ :label, :input, :hint, :error ]
        end
        klass.new(self).render
      end
    end
    alias :attribute :input
  end

# Patches to make simple_form play nice with i18n backend
  module Components
    module Labels
      def self.included(base)
        base.extend ClassMethods
      end
      module ClassMethods #:nodoc:
        def translate_required_html
          "<abbr title='required'>*</abbr>"
        end
      end
    end
  end

  module Inputs
    class Base
    protected
      def translate(namespace, default='')
        lookups = []
        lookups << :"#{object_name}.#{lookup_action}.#{reflection_or_attribute_name}"
        lookups << :"#{object_name}.#{reflection_or_attribute_name}"
        lookups << :"#{reflection_or_attribute_name}"
        lookups << default
        I18n.t(lookups.shift, :scope => :"simple_form.#{namespace}", :default => lookups)
      end
    end
  end
end