require 'spec_helper'

describe "promo_codes/new" do
  before(:each) do
    assign(:promo_code, stub_model(PromoCode,
      :code => "MyString",
      :charges => 1
    ).as_new_record)
  end

  it "renders new promo_code form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => promo_codes_path, :method => "post" do
      assert_select "input#promo_code_code", :name => "promo_code[code]"
      assert_select "input#promo_code_charges", :name => "promo_code[charges]"
    end
  end
end
