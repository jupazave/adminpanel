module Adminpanel
  class <%= camelized_resource -%> < ActiveRecord::Base
    include Adminpanel::Base

    <%= associations if has_associations? -%>

<% if needs_name? -%>
    def name
      self.id.to_s
    end
<% end -%>

    def self.form_attributes
      [
<%= indent(form_attributes_hash, 8) + "," %>
<%= indent(file_field_form_hash, 8) if has_gallery? %>
      ]
    end

    def self.display_name
      '<%= camelized_resource %>' #singular
    end

    # def self.icon
    #   "truck" # fa-{icon}
    # end
  end
end
