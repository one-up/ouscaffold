class <%= specified.class_name %> < <%= parent_class_name.classify %>
<% attributes.select {|attr| attr.reference? }.each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>

<% attributes.each do |attr| -%>
<%   case attr.type
     when :integer -%>
  validates :<%= attr.name %>, :numericality => true<%= ", :allow_nil => true" unless attr.notnull %>
<%   when :string, :text -%>
<%     if attr.notnull -%>
  validates :<%= attr.name %>, :length => { :minimum => 1 }
<%     end -%>
<%   end -%>
<% end -%>

end
