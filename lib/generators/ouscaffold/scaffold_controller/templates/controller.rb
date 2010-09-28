class <%= controller_class_name %>Controller < ApplicationController

  layout 'ouscaffold'

<% unless options[:singleton] -%>
  # GET <%= route_url %>
  # GET <%= route_url %>.xml
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= plural_table_name %> }
    end
  end
<% end -%>

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.xml
  def show
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= singular_table_name %> }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.xml
  def new
    @<%= singular_table_name %> ||= <%= orm_class.build(class_name) %>

    respond_to do |format|
<% if options[:confirm] -%>
      @confirm_path = confirm_new_<%= plural_table_name %>_path
<% end -%>
      format.html # new.html.erb
      format.xml  { render :xml => @<%= singular_table_name %> }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
<% if options[:confirm] -%>
    @confirm_path = confirm_edit_<%= singular_table_name %>_path(@<%= singular_table_name %>)
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
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>

    if @<%= singular_table_name %>.invalid?
      confirmation_error(@<%= singular_table_name %>, confirm_new_<%= plural_table_name %>_path) and return
    end
  end

  def confirm_edit
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= singular_table_name %>.attributes = params[:<%= singular_table_name %>]

    if @<%= singular_table_name %>.invalid?
      confirmation_error(@<%= singular_table_name %>, confirm_edit_<%= singular_table_name %>_path(@<%= singular_table_name %>)) and return
    end
  end
<% end -%>

  # POST <%= route_url %>
  # POST <%= route_url %>.xml
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to(@<%= singular_table_name %>, :notice => t('created_success', :scope => :scaffold, :model => <%= class_name %>.model_name.human)) }
        format.xml  { render :xml => @<%= singular_table_name %>, :status => :created, :location => @<%= singular_table_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.xml
  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %> 

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        format.html { redirect_to(@<%= singular_table_name %>, :notice => t('updated_success', :scope => :scaffold, :model => <%= class_name %>.model_name.human, :id => @<%= singular_table_name %>.id)) }
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
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to(<%= index_helper %>_url, :notice => t('destroyed_success', :scope => :scaffold, :model => <%= class_name %>.model_name.human, :id => @<%= singular_table_name %>.id)) }
      format.xml  { head :ok }
    end
  end

end
