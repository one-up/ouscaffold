require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= controller_path %>/new.html.<%= options[:template_engine] %>" do
  before(:each) do
    assign(:<%= singular_table_name %>, stub_model(<%= class_name %>,
      :new_record? => true<%= output_attributes.empty? ? '' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
    ))
<% if options[:confirm] -%>
    @confirm_path = confirm_new_<%= plural_table_name %>_path
<% end -%>
  end

  it "renders new <%= singular_table_name %> form" do
    render

<% action = options[:confirm] ? "confirm_new_#{plural_table_name}_path" : "#{plural_table_name}_path" %>
    rendered.should have_selector("form", :action => <%= action %>, :method => "post") do |form|
<% for attribute in output_attributes -%>
      form.should have_selector("<%= attribute.input_type -%>#<%= singular_table_name %>_<%= attribute.name %>", :name => "<%= singular_table_name %>[<%= attribute.name %>]")
<% end -%>
    end
  end
end
