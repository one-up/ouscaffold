class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= specified.table_name %> do |t|
<% for attribute in attributes -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>
<% if options[:timestamps] %>
      t.timestamps
<% end -%>
    end
  end

  def self.down
    drop_table :<%= specified.table_name %>
  end
end
