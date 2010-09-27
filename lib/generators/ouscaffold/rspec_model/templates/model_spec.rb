require 'spec_helper'

describe <%= class_name %> do
  def new_<%= file_name %>(options = {})
    <%= class_name %>.new({
<% attributes.each do |attr| -%>
      :<%= attr.name %> => <%= value_for(attr) %>,
<% end -%>
    }.merge(options))
  end

  context "when all attributes are proper" do
    it "should be valid" do
      new_<%= file_name %>.should be_valid
    end
  end

<% attributes.each do |attr| -%>

  <%- if attr.respond_to?(:notnull) and attr.notnull -%>
  context "when <%= attr.name %> is nil" do
    it "should not be valid" do
      new_<%= file_name %>(:<%= attr.name %> => nil).should_not be_valid
    end
  end
  <%- else -%>
  context "when <%= attr.name %> is nil" do
    it "should be valid" do
      new_<%= file_name %>(:<%= attr.name %> => nil).should be_valid
    end
  end

  <%- end -%>
  <%- if attr.type == :integer -%>
  context "when non-numeric <%= attr.name %> given" do
    it "should not be valid" do
      <%= class_name %>.new(:<%= attr.name %> => 'notinteger').should_not be_valid
    end
  end

  <%- end -%>
<% end -%>
end

