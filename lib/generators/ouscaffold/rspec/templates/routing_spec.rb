require "spec_helper"

describe <%= controller_class_name %>Controller do
  describe "routing" do

    <%- unless options[:singleton] -%>
    it "recognizes and generates #index" do
      { :get => "<%= route_url %>" }.should route_to(:controller => "<%= controller_path %>", :action => "index")
    end

    <%- end -%>
    it "recognizes and generates #new" do
      { :get => "<%= route_url %>/new" }.should route_to(:controller => "<%= controller_path %>", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "<%= route_url %>/1" }.should route_to(:controller => "<%= controller_path %>", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "<%= route_url %>/1/edit" }.should route_to(:controller => "<%= controller_path %>", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "<%= route_url %>" }.should route_to(:controller => "<%= controller_path %>", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "<%= route_url %>/1" }.should route_to(:controller => "<%= controller_path %>", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "<%= route_url %>/1" }.should route_to(:controller => "<%= controller_path %>", :action => "destroy", :id => "1") 
    end

    <%- if options[:confirm] -%>
    it "recognizes and generates #confirm_new" do
      { :post => "<%= route_url %>/confirm_new" }.should route_to(:controller => "<%= controller_path %>", :action => "confirm_new")
    end

    it "recognizes and generates #confirm_edit" do
      { :put => "<%= route_url %>/1/confirm_edit" }.should route_to(:controller => "<%= controller_path %>", :action => "confirm_edit", :id => "1")
    end
    <%- end -%>
                    
  end
end
