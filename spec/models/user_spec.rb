# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # Relation test
  it { should have_one(:store) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:is_admin) }
end
