module <%= specified.class_path.map(&:camelize).join('::') %>
  def self.table_name_prefix
    '<%= specified.class_path.join('_') %>_'
  end
end
