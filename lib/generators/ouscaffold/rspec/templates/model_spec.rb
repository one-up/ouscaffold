require 'spec_helper'

describe <%= class_name %> do
  pending "add some examples to (or delete) #{__FILE__}"

<% attributes.each do |attr| -%>
  <%- if attr.type == :integer -%>
  context "when numeric <%= attr.name %> given" do
    it "should be valid" do
      <%= class_name %>.new(:<%= attr.name %> => 1).should be_valid
    end
  end
  context "when non-numeric <%= attr.name %> given" do
    it "should not be valid" do
      <%= class_name %>.new(:<%= attr.name %> => 'notstring').should_not be_valid
    end
  end

  <%- end -%>
<% end -%>
end

