require 'spec_helper'

describe "promo_codes/show" do
  before(:each) do
    @promo_code = assign(:promo_code, stub_model(PromoCode,
      :code => "Code",
      :charges => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Code/)
    rendered.should match(/1/)
  end
end
