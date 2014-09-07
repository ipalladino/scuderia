require "spec_helper"

describe PromoCodesController do
  describe "routing" do

    it "routes to #index" do
      get("/promo_codes").should route_to("promo_codes#index")
    end

    it "routes to #new" do
      get("/promo_codes/new").should route_to("promo_codes#new")
    end

    it "routes to #show" do
      get("/promo_codes/1").should route_to("promo_codes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/promo_codes/1/edit").should route_to("promo_codes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/promo_codes").should route_to("promo_codes#create")
    end

    it "routes to #update" do
      put("/promo_codes/1").should route_to("promo_codes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/promo_codes/1").should route_to("promo_codes#destroy", :id => "1")
    end

  end
end
