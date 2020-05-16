# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  it { should have_many(:products).dependent(:destroy) }
  %i[title].each do |field|
    it { should validate_presence_of(field) }
  end
end
