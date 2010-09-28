module OuscaffoldHelper
  def title
    @title ? @title : action_name
  end

  def tr_with_zebra(options = {})
    options = options.dup
    t = cycle('odd', 'even')
    if options[:class]
      options[:class] << " #{t}"
    else
      options[:class] = t
    end
    tag("tr", options, true)
  end
end
