require 'spec_helper'

describe "saved_searches/new" do
  before(:each) do
    assign(:saved_search, stub_model(SavedSearch,
      :user_id => 1,
      :price_fr => "MyString",
      :price_to => "MyString",
      :year_fr => "MyString",
      :year_to => "MyString",
      :car_model => "MyString",
      :keywords => "MyString"
    ).as_new_record)
  end

  it "renders new saved_search form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => saved_searches_path, :method => "post" do
      assert_select "input#saved_search_user_id", :name => "saved_search[user_id]"
      assert_select "input#saved_search_price_fr", :name => "saved_search[price_fr]"
      assert_select "input#saved_search_price_to", :name => "saved_search[price_to]"
      assert_select "input#saved_search_year_fr", :name => "saved_search[year_fr]"
      assert_select "input#saved_search_year_to", :name => "saved_search[year_to]"
      assert_select "input#saved_search_car_model", :name => "saved_search[car_model]"
      assert_select "input#saved_search_keywords", :name => "saved_search[keywords]"
    end
  end
end
