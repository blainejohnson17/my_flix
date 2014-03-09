require 'spec_helper'

describe StripeWrapper do

  let(:token) do
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 1,
        :exp_year => 2015,
        :cvc => "314"
      }
    ).id
  end

  describe StripeWrapper::Charge do

    describe ".create" do

      let(:response) do 
        StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: "a valid charge"
        )
      end

      context "with valid card" do

        let(:card_number) { "4242424242424242" }

        it "makes a successful charge", :vcr do
          expect(response).to be_successful
        end
      end

      context "with declined card" do

        let(:card_number) { "4000000000000002" }

        it "makes a card declined charge", :vcr do     
          expect(response).not_to be_successful
        end

        it "sets @error_message for declined card", :vcr do
          expect(response.error_message).to eq("Your card was declined.")
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do

      let(:response) do 
        StripeWrapper::Customer.create(
          user: Fabricate(:user),
          card: token
        )
      end

      context "with valid card" do

        let(:card_number) { "4242424242424242" }

        it "creates a customer with valid card", :vcr do
          expect(response).to be_successful
        end

        it "returns the customer token", :vcr do
          expect(response.customer_token).to be_present
        end
      end

      context "with declined card" do

        let(:card_number) { "4000000000000002" }

        it "does not create a customer with declined card", :vcr do
          expect(response).not_to be_successful
        end

        it "sets @error_message for declined card", :vcr do
          expect(response.error_message).to eq("Your card was declined.")
        end
      end
    end
  end
end