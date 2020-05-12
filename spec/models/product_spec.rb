# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should belong_to(:store) }
  %i[title price amount].each do |field|
    it { should validate_presence_of(field) }
  end
end
