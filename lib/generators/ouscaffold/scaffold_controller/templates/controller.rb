class <%= controller_class_name %>Controller < ApplicationController

  layout :ouscaffold

<% unless options[:singleton] -%>
  # GET /<%= table_name %>
  # GET /<%= table_name %>.xml
  def index
    @<%= table_name %> = <%= orm_class.all(class_name) %>

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= table_name %> }
    end
  end
<% end -%>

  # GET /<%= table_name %>/1
  # GET /<%= table_name %>/1.xml
  def show
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /<%= table_name %>/new
  # GET /<%= table_name %>/new.xml
  def new
    @<%= file_name %> ||= <%= orm_class.build(class_name) %>

    respond_to do |format|
<% if options[:confirm] -%>
      @confirm_path = confirm_new_<%= table_name %>_path
<% end -%>
      format.html # new.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /<%= table_name %>/1/edit
  def edit
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
<% if options[:confirm] -%>
    @confirm_path = confirm_edit_<%= file_name %>_path(@<%= file_name %>)
<% end -%>
  end

<% if options[:confirm] -%>
  def confirmation_error(obj, next_path)
    respond_to do |format|
      @confirm_path = next_path
      format.html { render :action => 'new' }
      format.xml  { render :xml => obj }
    end
  end
  private :confirmation_error

  def confirm_new
    @<%= file_name %> = <%= orm_class.build(class_name, "params[:#{file_name}]") %>

    if @<%= file_name %>.invalid?
      confirmation_error(@<%= file_name %>, confirm_new_<%= table_name %>_path) and return
    end
  end

  def confirm_edit
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= file_name %>.attributes = params[:<%= file_name %>]

    if @<%= file_name %>.invalid?
      confirmation_error(@<%= file_name %>, confirm_edit_<%= file_name %>_path(@<%= file_name %>)) and return
    end
  end
<% end -%>

  # POST /<%= table_name %>
  # POST /<%= table_name %>.xml
  def create
    @<%= file_name %> = <%= orm_class.build(class_name, "params[:#{file_name}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to(@<%= file_name %>, :notice => '<%= human_name %> was successfully created.') }
        format.xml  { render :xml => @<%= file_name %>, :status => :created, :location => @<%= file_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /<%= table_name %>/1
  # PUT /<%= table_name %>/1.xml
  def update
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %> 

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{file_name}]") %>
        format.html { redirect_to(@<%= file_name %>, :notice => '<%= human_name %> was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= table_name %>/1
  # DELETE /<%= table_name %>/1.xml
  def destroy
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to(<%= table_name %>_url) }
      format.xml  { head :ok }
    end
  end

end
