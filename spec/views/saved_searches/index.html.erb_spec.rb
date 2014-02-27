require 'spec_helper'

describe "saved_searches/index" do
  before(:each) do
    assign(:saved_searches, [
      stub_model(SavedSearch,
        :user_id => 1,
        :price_fr => "Price Fr",
        :price_to => "Price To",
        :year_fr => "Year Fr",
        :year_to => "Year To",
        :car_model => "Car Model",
        :keywords => "Keywords"
      ),
      stub_model(SavedSearch,
        :user_id => 1,
        :price_fr => "Price Fr",
        :price_to => "Price To",
        :year_fr => "Year Fr",
        :year_to => "Year To",
        :car_model => "Car Model",
        :keywords => "Keywords"
      )
    ])
  end

  it "renders a list of saved_searches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Price Fr".to_s, :count => 2
    assert_select "tr>td", :text => "Price To".to_s, :count => 2
    assert_select "tr>td", :text => "Year Fr".to_s, :count => 2
    assert_select "tr>td", :text => "Year To".to_s, :count => 2
    assert_select "tr>td", :text => "Car Model".to_s, :count => 2
    assert_select "tr>td", :text => "Keywords".to_s, :count => 2
  end
end
