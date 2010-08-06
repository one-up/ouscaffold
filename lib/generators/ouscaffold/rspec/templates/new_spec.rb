require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= table_name %>/new.html.<%= options[:template_engine] %>" do
  before(:each) do
    assign(:<%= file_name %>, stub_model(<%= class_name %>,
      :new_record? => true<%= output_attributes.empty? ? '' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
    ))
<% if options[:confirm] -%>
    @confirm_path = confirm_new_<%= table_name %>_path
<% end -%>
  end

  it "renders new <%= file_name %> form" do
    render

<% action = options[:confirm] ? "confirm_new_#{table_name}_path" : "#{table_name}_path" %>
    rendered.should have_selector("form", :action => <%= action %>, :method => "post") do |form|
<% for attribute in output_attributes -%>
      form.should have_selector("<%= attribute.input_type -%>#<%= file_name %>_<%= attribute.name %>", :name => "<%= file_name %>[<%= attribute.name %>]")
<% end -%>
    end
  end
end
