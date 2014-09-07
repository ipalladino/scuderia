require 'spec_helper'

describe "orders/show" do
  before(:each) do
    @order = assign(:order, stub_model(Order,
      :new => "New",
      :ferrari_id => 1,
      :ip_address => "Ip Address",
      :first_name => "First Name",
      :last_name => "Last Name",
      :card_type => "Card Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/New/)
    rendered.should match(/1/)
    rendered.should match(/Ip Address/)
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Card Type/)
  end
end
