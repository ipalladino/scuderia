require 'spec_helper'

describe "promo_codes/edit" do
  before(:each) do
    @promo_code = assign(:promo_code, stub_model(PromoCode,
      :code => "MyString",
      :charges => 1
    ))
  end

  it "renders the edit promo_code form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => promo_codes_path(@promo_code), :method => "post" do
      assert_select "input#promo_code_code", :name => "promo_code[code]"
      assert_select "input#promo_code_charges", :name => "promo_code[charges]"
    end
  end
end
