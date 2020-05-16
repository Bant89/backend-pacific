# frozen_string_literal: true

FactoryBot.define do
  factory :store do
    title { Faker::Company.name }
    description { Faker::Lorem.sentence(word_count: 5) }
    category { Faker::Commerce.department(max: 1) }
    image { Faker::LoremPixel.image(size: '300x150') }
  end
end
