require "spec_helper"

describe SavedSearchesController do
  describe "routing" do

    it "routes to #index" do
      get("/saved_searches").should route_to("saved_searches#index")
    end

    it "routes to #new" do
      get("/saved_searches/new").should route_to("saved_searches#new")
    end

    it "routes to #show" do
      get("/saved_searches/1").should route_to("saved_searches#show", :id => "1")
    end

    it "routes to #edit" do
      get("/saved_searches/1/edit").should route_to("saved_searches#edit", :id => "1")
    end

    it "routes to #create" do
      post("/saved_searches").should route_to("saved_searches#create")
    end

    it "routes to #update" do
      put("/saved_searches/1").should route_to("saved_searches#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/saved_searches/1").should route_to("saved_searches#destroy", :id => "1")
    end

  end
end
