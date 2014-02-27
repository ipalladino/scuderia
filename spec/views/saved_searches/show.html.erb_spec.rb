require 'spec_helper'

describe "saved_searches/show" do
  before(:each) do
    @saved_search = assign(:saved_search, stub_model(SavedSearch,
      :user_id => 1,
      :price_fr => "Price Fr",
      :price_to => "Price To",
      :year_fr => "Year Fr",
      :year_to => "Year To",
      :car_model => "Car Model",
      :keywords => "Keywords"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Price Fr/)
    rendered.should match(/Price To/)
    rendered.should match(/Year Fr/)
    rendered.should match(/Year To/)
    rendered.should match(/Car Model/)
    rendered.should match(/Keywords/)
  end
end
