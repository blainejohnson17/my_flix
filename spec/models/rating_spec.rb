require 'spec_helper'

describe Rating do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:value) }
  it { should validate_numericality_of(:value).only_integer }
  it { should ensure_inclusion_of(:value).in_range(1..5) }
  it do
    Fabricate(:rating)
    should validate_uniqueness_of(:video_id).scoped_to(:user_id)
  end
  it { should delegate_method(:update_average_rating).to(:video) }
end