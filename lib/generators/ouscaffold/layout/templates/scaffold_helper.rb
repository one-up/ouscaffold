module ScaffoldHelper
  def title
    @title ? @title : action_name
  end
end