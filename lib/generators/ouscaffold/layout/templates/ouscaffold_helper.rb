module OuscaffoldHelper
  def title
    @title ? @title : action_name
  end
end
