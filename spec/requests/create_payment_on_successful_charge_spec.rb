require 'spec_helper'

describe "Create payment on successful charge" do

  let(:event_data) do
    {
      "id" => "evt_103dS92tP72EN7gHnPd05clx",
      "created" => 1394388081,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_103dS92tP72EN7gHboqLv382",
          "object" => "charge",
          "created" => 1394388081,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_103dS92tP72EN7gHjh6FzRSO",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 3,
            "exp_year" => 2014,
            "fingerprint" => "E7xNEtOzftFyy9Cq",
            "customer" => "cus_3dS9SJXfBBCtJ8",
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
          "captured" => true,
          "refunds" => [],
          "balance_transaction" => "txn_103dS92tP72EN7gH1qcthMx3",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_3dS9SJXfBBCtJ8",
          "invoice" => "in_103dS92tP72EN7gHmAPjrpZ4",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {}
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3dS9a39zyipXXu"
    }
  end

  it "creates a payment with the webhook from for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates a payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3dS9SJXfBBCtJ8")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates a payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3dS9SJXfBBCtJ8")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates a payment with the reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3dS9SJXfBBCtJ8")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_103dS92tP72EN7gHboqLv382")
  end
end