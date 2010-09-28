require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= controller_path %>/edit.html.<%= options[:template_engine] %>" do
  before(:each) do
<% if options[:confirm] -%>
<% end -%>
    @<%= singular_table_name %> = assign(:<%= singular_table_name %>, stub_model(<%= class_name %>,
      :new_record? => false<%= output_attributes.empty? ? '' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= attribute.default.inspect %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
    ))
<% if options[:confirm] -%>
    @confirm_path = confirm_edit_<%= "#{singular_table_name}_path(@#{singular_table_name})" %>
<% end -%>
  end

  it "renders the edit <%= singular_table_name %> form" do
    render

<% action = options[:confirm] ? "confirm_edit_#{singular_table_name}_path(@#{singular_table_name})" : "#{singular_table_name}_path(@#{singular_table_name})" %>
    rendered.should have_selector("form", :action => <%= action %>, :method => "post") do |form|
<% for attribute in output_attributes -%>
      form.should have_selector("<%= attribute.input_type -%>#<%= singular_table_name %>_<%= attribute.name %>", :name => "<%= singular_table_name %>[<%= attribute.name %>]")
<% end -%>
    end
  end
end
