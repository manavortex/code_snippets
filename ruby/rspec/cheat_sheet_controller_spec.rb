require 'rails_helper'

RSpec.describe TodosController, :type => :controller do

  context "GET index" do
  #context "POST create" do
  #context "GET show" do
  #context "PATCH update" do (or PUT update)
  #context "DELETE destroy" do
  #context "GET new" do
  #context "GET edit" do
  
    
    # NORMALLY, you DO NOT want render_views, or you only want to call it in
    # a single context.
    # More on render_views: 
    # https://www.relishapp.com/rspec/rspec-rails/v/3-1/docs/controller-specs/render-views
    render_views # ONLY have this if you're certain you need it
    
    it "reads like a sentence (almost)" do
      
      get :index
      
      params = { id: 123 }
      get :edit, params
      
      params = { widget: { description: 'Hello World' } }
      params.merge!(format: :js) # Specify format for AJAX/JS responses (e.g. create.js.erb view)
      post :create, params
      
      # Testing 404s in controllers (assuming default Rails handling of RecordNotFound)
      expect { delete :destroy, { id: 'unknown' } }.to raise_error(ActiveRecord::RecordNotFound)
      
      # Rails `:symbolized` status codes at end of each status code page at http://httpstatus.es/
      expect(response).to have_http_status(:success) # 200
      expect(response).to have_http_status(:forbidden) # 403
      
      expect(response).to redirect_to foo_path
      expect(response).to render_template(:template_filename_without_extension)
      expect(response).to render_template(:destroy)
      
      # Need response.body? Requires render_views call outside "it" block (see above & read given URL)
      expect(response.body).to match /Bestsellers/ 
      expect(response.body).to include "Bestsellers"
      
      expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
      expect(response.headers["Content-Type"]).to eq "text/javascript; charset=utf-8"
      
      # assigns(:foobar) accesses the @foobar instance variable
      # the controller method made available to the view
      
      # Think of assigns(:widgets) as @widgets in the controller method
      expect(assigns(:widgets)).to eq([widget1, widget2, widget3])

      # Think of assigns(:product) as @product in the controller method
      expect(assigns(:product)).to eq(bestseller)
      expect(assigns(:cat)).to be_cool # cat.cool is a boolean, google "rspec predicate matchers"
      expect(assigns(:employee)).to be_a_new(Employee) 
      
    
      # Asserting flash messages
      expect(flash[:notice]).to eq "Congratulations on buying our stuff!"
      expect(flash[:error]).to eq "Buying our stuff failed :-("
      expect(flash[:alert]).to eq "You didn't buy any of our stuff!!!"
      
      # Oi Eliot - TODO: add cookies and session examples here
      
      # Query the db to assert changes persisted
      expect(Invoice.count).to eq(1)
      
      # Reload from db an object fetched in test setup when its record in db
      # is updated by controller method, otherwise you're testing stale data
      employee.reload
      invoice.reload
      product.reload
      widget.reload

    end
    
  end

end
