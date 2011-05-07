require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= controller_path %>/confirm_new.html.<%= options[:template_engine] %>" do
  before(:each) do
    assign(:<%= specified.singular_table_name %>, stub_model(<%= specified.class_name %>,
      :new_record? => true,
      :id => nil<%= output_attributes.empty? ? '' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
    ))
  end

  it "renders confirmation of new <%= specified.resource %> form" do
    render
    rendered.should have_selector("form", :action => <%= plural_table_name %>_path, :method => "post") do |form|
<% for attribute in output_attributes -%>
      rendered.should contain(<%= value_for(attribute) %>.to_s)
      form.should have_selector("input#<%= specified.singular_table_name %>_<%= attribute.name %>", :type => "hidden", :name => "<%= specified.singular_table_name %>[<%= attribute.name %>]")
<% end -%>
    end
  end
end
