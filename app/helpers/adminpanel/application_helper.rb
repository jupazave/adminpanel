module Adminpanel
  module ApplicationHelper
    include SessionsHelper
    include BreadcrumbsHelper
    include SharedPagesHelper

    def adminpanel_form_for(name, *args, &block)
      options = args.extract_options!
      options.reverse_merge! builder: Adminpanel::AdminpanelFormBuilder, html: { class: "form-horizontal" }

      form_for(name, *(args << options), &block)
    end

    def full_title(page_title)
      base_title = t("Panel title")
      if page_title.empty?
        base_title
      else
        "#{page_title} | #{base_title}"
      end
    end

    def is_current_section?(display_name)
      display_name == params[:controller].classify.constantize.display_name ? 'active' : nil
    end

    def link_to_add_fields(name, f, association, hidden='not-hidden')
      new_object = f.object.send(association).klass.new
      id = new_object.object_id
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render('adminpanel/shared/image_fields', f: builder)
      end
      add_another_image_button = content_tag(:div, id: 'new-image-button') do
        content_tag(:button, class: 'btn btn-success btn-mini') do
          content_tag(:h6, name)
        end
      end
      link_to(
        add_another_image_button,
        '#',
        class: "add-fields #{hidden}",
        id: 'add-image-link',
        data: {
          id: id,
          fields: fields.gsub("\n", "")
        }
      )
    end

    def route_symbol(model_name)
      model_name.pluralize.downcase
    end

    def symbol_class(symbol_model)
      "adminpanel/#{symbol_model.to_s.singularize}".classify.constantize
    end

    def main_root_path
      if main_app.respond_to?(root_path)
        main_app.root_path
      else
        "/"
      end
    end
  end
end
