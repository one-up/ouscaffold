class <%= controller_class_name %>Controller < ApplicationController

  layout 'ouscaffold'

<% unless options[:singleton] -%>
  # GET <%= route_url %>
  # GET <%= route_url %>.xml
  def index
    @<%= specified.plural_table_name %> = <%= orm_class.all(specified.class_name) %>

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= specified.plural_table_name %> }
    end
  end
<% end -%>

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.xml
  def show
    @<%= specified.singular_table_name %> = <%= orm_class.find(specified.class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= specified.singular_table_name %> }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.xml
  def new
    @<%= specified.singular_table_name %> ||= <%= orm_class.build(specified.class_name) %>

    respond_to do |format|
<% if options[:confirm] -%>
      @confirm_path = confirm_new_<%= plural_table_name %>_path
<% end -%>
      format.html # new.html.erb
      format.xml  { render :xml => @<%= specified.singular_table_name %> }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= specified.singular_table_name %> = <%= orm_class.find(specified.class_name, "params[:id]") %>
<% if options[:confirm] -%>
    @confirm_path = confirm_edit_<%= singular_table_name %>_path(@<%= specified.singular_table_name %>)
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
    @<%= specified.singular_table_name %> = <%= orm_class.build(specified.class_name, "params[:#{specified.singular_table_name}]") %>

    if @<%= specified.singular_table_name %>.invalid?
      confirmation_error(@<%= specified.singular_table_name %>, confirm_new_<%= plural_table_name %>_path) and return
    end
  end

  def confirm_edit
    @<%= specified.singular_table_name %> = <%= orm_class.find(specified.class_name, "params[:id]") %>
    @<%= specified.singular_table_name %>.attributes = params[:<%= specified.singular_table_name %>]

    if @<%= specified.singular_table_name %>.invalid?
      confirmation_error(@<%= specified.singular_table_name %>, confirm_edit_<%= specified.singular_table_name %>_path(@<%= specified.singular_table_name %>)) and return
    end
  end
<% end -%>

  # POST <%= route_url %>
  # POST <%= route_url %>.xml
  def create
    @<%= specified.singular_table_name %> = <%= orm_class.build(specified.class_name, "params[:#{specified.singular_table_name}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to(<%= specified.resource %>, :notice => t('created_success', :scope => :scaffold, :model => <%= specified.class_name %>.model_name.human)) }
        format.xml  { render :xml => @<%= specified.singular_table_name %>, :status => :created, :location => @<%= specified.singular_table_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.xml
  def update
    @<%= specified.singular_table_name %> = <%= orm_class.find(specified.class_name, "params[:id]") %> 

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{specified.singular_table_name}]") %>
        format.html { redirect_to(<%= specified.resource %>, :notice => t('updated_success', :scope => :scaffold, :model => <%= specified.class_name %>.model_name.human, :id => @<%= specified.singular_table_name %>.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.xml
  def destroy
    @<%= specified.singular_table_name %> = <%= orm_class.find(specified.class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to(<%= index_helper %>_url, :notice => t('destroyed_success', :scope => :scaffold, :model => <%= specified.class_name %>.model_name.human, :id => @<%= specified.singular_table_name %>.id)) }
      format.xml  { head :ok }
    end
  end

end
