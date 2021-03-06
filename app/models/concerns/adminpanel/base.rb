module Adminpanel
  module Base
    extend ActiveSupport::Concern

    module ClassMethods

      # Adminpanel API
      def mount_images(relation)
        has_many relation, dependent: :destroy
        accepts_nested_attributes_for relation, allow_destroy: true
      end

      # implementing cache by default.
      def belongs_to(name, scope = nil, options = {})
        super(name, scope, options.reverse_merge!({touch: true}))
      end

      # The fields and the types that should be used to generate form
      # and display fields
      def form_attributes
        []
      end

      # The name that is going to be shown in the new button and that is going
      # to be pluralized (if not overwritten) to generate collection_name
      def display_name
        'please overwrite self.display_name'
      end

      # side menu icon
      def icon
        'truck'
      end

      # The word that is going to be shown in the side menu, routes and
      # breadcrumb.
      def collection_name
        display_name.pluralize(I18n.default_locale)
      end

      def get_attribute_label(field)
        form_attributes.each do |attribute|
          attribute.each do |name, properties|
            if name == field
              return properties['label']
            end
          end
        end
        return "field #{field} 'label' property not found :("
      end

      # returns the attributes that should be shown in the correspondin view
      # (some attributes may be filtered from the index table, from the show
      # or even both)
      def display_attributes(type)
        display_attributes = []
        form_attributes.each do |attribute|
          attribute.each do |name, properties|
            if (
              properties['show'].nil? ||
              properties['show'] == 'true' ||
              (
                properties['show'] == type &&
                properties['type'] != 'adminpanel_file_field' #file fields get only displayed in form
              )
            )
              display_attributes << attribute
            end
          end
        end
        return display_attributes
      end

      # return true if model has adminpanel_file_field in
      # it's attributes
      def has_gallery?
        form_attributes.each do |fields|
          fields.each do |attribute, properties|
            if properties['type'] == 'adminpanel_file_field'
              return true
            end
          end
        end
        return false
      end

      # returns the attribute that should be namespaced to be the class
      # ex: returns 'productfiles', so class is Adminpanel::Productfile
      def gallery_relationship
        form_attributes.each do |fields|
          fields.each do |attribute, properties|
            if properties['type'] == 'adminpanel_file_field'
              return attribute
            end
          end
        end
        return false
      end

      # gets the class gallery and return it's class
      def gallery_class
        "adminpanel/#{gallery_relationship}".classify.constantize
      end

      # returns all the class of the attributes of a given type.
      # Usage:
      # To get all classes of all belongs_to attributes:
      #   @model.relationships_of('belongs_to')
      #   # => ['Adminpanel::Category', Adminpanel::ModelBelongTo]
      def relationships_of(type_property)
        classes_of_relation = []
        form_attributes.each do |fields|
          fields.each do |attribute, properties|
            if properties['type'] == type_property
              classes_of_relation << properties['model'].classify.constantize
            end
          end
        end
        return classes_of_relation
      end

      def routes_options
        { path: collection_name.parameterize }
      end

      def has_route?(route)
        if (!exclude?(route)) && include_route(route)
          true
        else
          false
        end
      end

      def fb_share?
        false
      end

      def twitter_share?
        false
      end

      def member_routes
        []
      end

      def collection_routes
        []
      end

      def is_sortable?
        false
      end

      def has_sortable_gallery?
        if has_gallery?
          gallery_class.is_sortable?
        end
      end

      private

      def exclude?(route)
        if routes_options[:except].nil?
          false
        elsif routes_options[:except].include?(route)
          true
        else
          false
        end
      end

      def include_route(route)
        if routes_options[:only].nil? || routes_options[:only].include?(route)
          true
        else
          false
        end
      end
    end
  end
end
