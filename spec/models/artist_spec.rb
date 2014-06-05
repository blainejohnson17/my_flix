require 'spec_helper'

describe Artist do
  it { should have_many(:actor_roles).dependent(:destroy) }
  it { should have_many(:acting_parts).through(:actor_roles).source(:video) }
  it { should have_many(:creator_roles).dependent(:destroy) }
  it { should have_many(:creatorships).through(:creator_roles).source(:video) }
end