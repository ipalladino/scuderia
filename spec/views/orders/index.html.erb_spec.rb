require 'spec_helper'

describe "orders/index" do
  before(:each) do
    assign(:orders, [
      stub_model(Order,
        :new => "New",
        :ferrari_id => 1,
        :ip_address => "Ip Address",
        :first_name => "First Name",
        :last_name => "Last Name",
        :card_type => "Card Type"
      ),
      stub_model(Order,
        :new => "New",
        :ferrari_id => 1,
        :ip_address => "Ip Address",
        :first_name => "First Name",
        :last_name => "Last Name",
        :card_type => "Card Type"
      )
    ])
  end

  it "renders a list of orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "New".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Ip Address".to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Card Type".to_s, :count => 2
  end
end
