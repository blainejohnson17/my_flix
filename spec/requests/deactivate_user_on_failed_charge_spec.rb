require 'spec_helper'

describe "Deactivate user on failed charge" do

  let(:event_data) do
    {
      "id" => "evt_103gd32tP72EN7gH50NOH1a6",
      "created" => 1395120574,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_103gd32tP72EN7gHEnag48iq",
          "object" => "charge",
          "created" => 1395120574,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_103gcx2tP72EN7gHrOJnZoUk",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 3,
            "exp_year" => 2017,
            "fingerprint" => "WYoxhIxnHXqUD5hq",
            "customer" => "cus_3dY7H03XhrcV7G",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_3dY7H03XhrcV7G",
          "invoice" => nil,
          "description" => "payment fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3gd3DYErs8uw0Z"
    }
  end

  it "deactivates a user with the web hook data from stripe for a charge failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3dY7H03XhrcV7G", active: true)
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end